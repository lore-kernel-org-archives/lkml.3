Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3GXAWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:22:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:21922 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab3GXAV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:21:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,731,1367996400"; 
   d="scan'208";a="374955158"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: RE: [PATCH 01/13] ACPI/IPMI: Fix potential response buffer overflow
Thread-Topic: [PATCH 01/13] ACPI/IPMI: Fix potential response buffer overflow
Thread-Index: AQHOh3wLKhdEYIiVUE2C0IUCYAmbI5lx0/CAgAEj1aA=
Date: Wed, 24 Jul 2013 00:21:42 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024350EA@SHSMSX101.ccr.corp.intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com>
 <cover.1374566394.git.lv.zheng@intel.com>
 <be902a592144313dbf382876965166166bf81438.1374566394.git.lv.zheng@intel.com>
 <20130723145419.GA12065@kroah.com>
In-Reply-To: <20130723145419.GA12065@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-acpi-owner@vger.kernel.org
> [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Tuesday, July 23, 2013 10:54 PM
> 
> On Tue, Jul 23, 2013 at 04:08:59PM +0800, Lv Zheng wrote:
> > This patch enhances sanity checks on message size to avoid potential
> > buffer overflow.
> >
> > The kernel IPMI message size is IPMI_MAX_MSG_LENGTH(272 bytes) while
> > the ACPI specification defined IPMI message size is 64 bytes.  The
> > difference is not handled by the original codes.  This may cause crash
> > in the response handling codes.
> > This patch fixes this gap and also combines rx_data/tx_data to use
> > single data/len pair since they need not be seperated.
> >
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > Reviewed-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  drivers/acpi/acpi_ipmi.c |  100
> > ++++++++++++++++++++++++++++------------------
> >  1 file changed, 61 insertions(+), 39 deletions(-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the stable kernel
> tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>
> 
> Same goes for the other patches you sent in this thread...

OK, I'll add prerequisites for each that want to be accepted by the stable queue and re-send them (PATCH 01-06).

Thanks and best regards
-Lv

> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
