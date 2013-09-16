Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab3IPBWC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 21:22:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:16516 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab3IPBV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 21:21:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,912,1371106800"; 
   d="scan'208";a="403738790"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
Thread-Topic: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
Thread-Index: AQHOsJQAl34IB1lxyU2PFiwcEyBhepnEW9mAgAF8/4CAAa8jcIAACnDA
Date: Mon, 16 Sep 2013 01:21:53 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802463A46@SHSMSX101.ccr.corp.intel.com>
References: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
 <1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
 <1AE640813FDE7649BE1B193DEA596E880246367A@SHSMSX101.ccr.corp.intel.com>
 <20130915065151.GK7393@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024639E4@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024639E4@SHSMSX101.ccr.corp.intel.com>
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

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Zheng, Lv
> Sent: Monday, September 16, 2013 8:47 AM
> 
> > From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> > Sent: Sunday, September 15, 2013 2:52 PM
> >
> > On Sat, Sep 14, 2013 at 12:10:37AM +0000, Zheng, Lv wrote:
> > > Is it possible to install the handler for ACPI_ROOT_OBJECT?
> > > Can it be achieved by implementing a setup callback?
> >
> > Yes that can be done. However, that would mean that we always install the
> > operation region handler even if there is no suitable GPIO driver loaded.
> > With this patch we install the handler once the GPIO driver for this device
> > is registered. If nothing is registered no handlers will be installed.
> >
> > What would be the advantage in doing what you propose?
> 
> A pseudo device may be created to access the GPIO operation region fields provided by one GPIO device.
> The pseudo device may have other functions to access other GPIO operation region fields provided by other GPIO devices, or even worse to
> access other ACPI provided value-adds.
> So hierarchically the pseudo device only requires CPU, thus should not be under the GPIO device, which means the GPIO operation regions
> have nothing to do with the GPIO devices' ACPI handle.

Sorry for the wording.
It's better to say the GPIO operation region users haven't strict relationship to the GPIO operation region providers.
As the installation is to provide GPIO operation regions to the users, it shouldn't relate to the providers' ACPI handle.

> We cannot imply that the BIOS writers won't create such Frankenstein in the future.
> So it's better to install address space handlers from ACPI_ROOT_OBJECT.

If we didn't do this and such a pseudo device was created, then the error message: "Region XXX has no handler" would be prompted.

Thanks
-Lv

> 
> > > Maybe you can also eliminate acpi_attach_data usages by doing so.
> >
> > I think we still need that for ACPI _EVT handling.
> 
> It could be good if we can find a way to eliminate all acpi_attach_data usages and make this function deprecated.
> But that's fine. :-)
> 
> Thanks and best regards
> -Lv
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
