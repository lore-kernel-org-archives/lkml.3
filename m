Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3CSEMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 00:12:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2563 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3CSEMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 00:12:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 18 Mar 2013 21:12:29 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Tue, 19 Mar 2013 09:42:26 +0530
Subject: RE: [PATCH 5/7] usb: phy: tegra: get ULPI reset GPIO info using DT.
Thread-Topic: [PATCH 5/7] usb: phy: tegra: get ULPI reset GPIO info using DT.
Thread-Index: Ac4j2OIWcO63VwdaTNCDRLT/Jo6ZyQAfwGdg
Message-ID: <D958900912E20642BCBC71664EFECE3E6E50311A71@BGMAIL02.nvidia.com>
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
 <1363609781-4045-6-git-send-email-vbyravarasu@nvidia.com>
 <5147102F.1060204@cogentembedded.com>
In-Reply-To: <5147102F.1060204@cogentembedded.com>
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
> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-
> owner@vger.kernel.org] On Behalf Of Sergei Shtylyov
> Sent: Monday, March 18, 2013 6:32 PM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu;
> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> swarren@wwwdotorg.org; linux-tegra@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org
> Subject: Re: [PATCH 5/7] usb: phy: tegra: get ULPI reset GPIO info using DT.
> 
> Hello.
> 
> On 18-03-2013 16:29, Venu Byravarasu wrote:
> 
> > As GPIO information is avail through DT, used it to get Tegra ULPI
> > reset GPIO number. Added a new member to tegra_usb_phy structure to
> > store this number.
> 
> > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> > ---
> >   drivers/usb/phy/tegra_usb_phy.c   |   25 +++++++++++--------------
> >   include/linux/usb/tegra_usb_phy.h |    1 +
> >   2 files changed, 12 insertions(+), 14 deletions(-)
> 
> > diff --git a/drivers/usb/phy/tegra_usb_phy.c
> b/drivers/usb/phy/tegra_usb_phy.c
> > index b5b2037..29c5ac4 100644
> > --- a/drivers/usb/phy/tegra_usb_phy.c
> > +++ b/drivers/usb/phy/tegra_usb_phy.c
> [...]
> > @@ -622,18 +619,18 @@ static int	tegra_phy_init(struct usb_phy *x)
> [...]
> > -		gpio_request(ulpi_config->reset_gpio, "ulpi_phy_reset_b");
> > -		gpio_direction_output(ulpi_config->reset_gpio, 0);
> > +		gpio_request(phy->reset_gpio, "ulpi_phy_reset_b");
> > +		gpio_direction_output(phy->reset_gpio, 0);
> 
>     Why not use goio_request_one() instead of these two? Thought maybe it's
> a
> material of another patch...

Sure, can take this up as part of next patch.
Thanks for the review. 

> 
> WBR, Sergei
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
