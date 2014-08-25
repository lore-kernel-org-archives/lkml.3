Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaHYGeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:34:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:3669 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbaHYGeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="581211145"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Dave Young <dyoung@redhat.com>, Matt Fleming <matt@console-pimps.org>
CC: "Fleming, Matt" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: RE: kernel boot fail with efi earlyprintk (bisected)
Thread-Topic: kernel boot fail with efi earlyprintk (bisected)
Thread-Index: AQHPu4XSRTaCxkfh/U+HttRB4JxB75vg3lk+gAAHPUA=
Date: Mon, 25 Aug 2014 06:34:02 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880265F57B@SHSMSX101.ccr.corp.intel.com>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
 <20140822100258.GA1877@darkstar.nay.redhat.com>
 <20140825060713.GA4011@darkstar.nay.redhat.com>
In-Reply-To: <20140825060713.GA4011@darkstar.nay.redhat.com>
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

Hi,

> From: Dave Young [mailto:dyoung@redhat.com]
> Sent: Monday, August 25, 2014 2:07 PM
> To: Matt Fleming
> Cc: Zheng, Lv; Fleming, Matt; linux-efi@vger.kernel.org; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org; devel@acpica.org;
> lenb@kernel.org; Wysocki, Rafael J; Moore, Robert
> Subject: Re: kernel boot fail with efi earlyprintk (bisected)
> 
> On 08/22/14 at 06:02pm, Dave Young wrote:
> > On 08/21/14 at 09:52pm, Matt Fleming wrote:
> > > On Tue, 19 Aug, at 04:16:58PM, Dave Young wrote:
> > > > Hi,
> > > >
> > > > 3.16 kernel boot fail with earlyprintk=efi on my laptop.
> > > > It keeps scrolling at the bottom line of screen.
> > > >
> > > > Bisected, the first bad commit is below:
> > > > commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> > > > Author: Lv Zheng <lv.zheng@intel.com>
> > > > Date:   Fri Apr 4 12:38:57 2014 +0800
> > > >
> > > >     ACPICA: Tables: Fix table checksums verification before installation.
> > > >
> > > >
> > > > I did some debugging by enabling both serial and efi earlyprintk, below is
> > > > some debug dmesg, seems early_ioremap fails in scroll up function due to
> > > > no free slot, but I'm still not sure if the debug info is right or not.
> > >
> > > Thanks Dave, your callstack seems to make sense.
> > >
> > > Can you also enable early_ioremap_debug so that we can figure out where
> > > all the FIXMAP slots are going?
> >
> > With early_ioremap_debug enabled, there will be a lot of "dropped printk", so
> > I can not get any useful information.
> >
> > Will try to do more debug.
> 
> early_ioremap_debug does not work because we are debugging early_printk but
> early_ioremap_debug itself will print warning message at the same time.
> 
> Tried what Lv mentioned, increasing the early ioremap slots does help.

Could you send a tested patch to linux-acpi@vger.kermel.org for this?
I think the number of early mapping slots need to be increased by 1 because of this case.

Thanks and best regards
-Lv
