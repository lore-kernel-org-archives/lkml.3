Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720Ab3DBHNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:13:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9263 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3DBHM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:12:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 02 Apr 2013 00:12:11 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 2 Apr 2013 12:42:54 +0530
Subject: RE: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
Thread-Topic: [PATCH] usb: host: tegra: Reset Tegra USB controller before
 init
Thread-Index: Ac4ZOUx4ld3TXeheQwGwpQD0WTlwaAWNwbhQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6E50BE434F@BGMAIL02.nvidia.com>
References: <1362033418-7332-1-git-send-email-vbyravarasu@nvidia.com>
 <512F9F0B.1040303@wwwdotorg.org>
 <D958900912E20642BCBC71664EFECE3E6E4F7216C0@BGMAIL02.nvidia.com>
 <5134D210.3060405@wwwdotorg.org> <20130305003423.GA23996@kroah.com>
In-Reply-To: <20130305003423.GA23996@kroah.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, March 05, 2013 6:04 AM
> To: Stephen Warren
> Cc: Venu Byravarasu; stern@rowland.harvard.edu; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
> 
> On Mon, Mar 04, 2013 at 09:55:44AM -0700, Stephen Warren wrote:
> > On 03/04/2013 12:55 AM, Venu Byravarasu wrote:
> > > Stephen Warren wrote at Thursday, February 28, 2013 11:47 PM:
> > >> On 02/27/2013 11:36 PM, Venu Byravarasu wrote:
> > >>> To clear any configurations made by U-Boot on Tegra USB controller,
> > >>> reset it before init in probe.
> > >>
> > >>> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-
> tegra.c
> > >>
> > >>> @@ -691,6 +692,10 @@ static int tegra_ehci_probe(struct
> platform_device
> > >> *pdev)
> > >>>  	if (err)
> > >>>  		goto fail_clk;
> > >>>
> > >>> +	tegra_periph_reset_assert(tegra->clk);
> > >>> +	udelay(1);
> > >>> +	tegra_periph_reset_deassert(tegra->clk);
> > >>

> > Alan, Greg, if you're OK with this patch now, or for any revised
> > version, an Ack so I can take it through the Tegra tree would be great,
> > thanks.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 
Hi Greg,

Stephen initially thought that the patch can be taken through tegra tree, along with
other patches posted at  http://marc.info/?l=linux-tegra&m=136361016003625&w=2 .
As some other issues are blocking that patch series, can this change be merged
independent of that patch series via USB tree?

The original change can be seen at http://marc.info/?l=linux-usb&m=136203353205291&w=2  

Thanks,
Venu

