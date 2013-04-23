Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3DWTCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:02:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60410 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3DWTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:02:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 18/21] usb: phy: tegra: don't call into tegra-ehci directly
Date: Tue, 23 Apr 2013 21:02:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1304231239220.1679-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1304231239220.1679-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232102.20573.arnd@arndb.de>
X-Provags-ID: V02:K0:6fs050SmvZhYpI1RUlDGd9s1//yFP1yNv+3RbKrrWpY
 IwMSsLg6uTzXke7hnOADpXwVKBza8rZPuID7LToSuU0uxlkY2/
 BJvcnI4ZD3veYGoKdsoMog29KZtKoD4XqbVc4pyJvbC7wlhOdu
 us7Ngmn6KoQzp4akfalaRaH0a9+sgduPQNDyWzY4IyWI0REtik
 rkvKrPmo9/CPqW5AZ0q/20JOjqO+Pr6sA0h/CteuSWXz8k90bn
 MSye1bpUe0F/5Xnhjvf6jBR7YtFXQWq5WW8DP/Dy80Lq317+s8
 U/qvznuOnQ3fwTMGjiYaP09CM3TVqNX2dYU8MEqUFHKwwFVVCg
 3GR1ALKz4P/C3vr8Vd8Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Alan Stern wrote:
> On Tue, 23 Apr 2013, Arnd Bergmann wrote:

> > @@ -733,7 +731,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
> >  
> >  	tegra->phy = tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
> >  					pdata->phy_config,
> > -					TEGRA_USB_PHY_MODE_HOST);
> > +					TEGRA_USB_PHY_MODE_HOST,
> > +					&tegra_ehci_set_pts,
> > +					tegra_ehci_set_phcd);
> 
> Does the compiler warn about the unnecessary '&'? 

No, AFAIK, both variants are equally acceptable C.

> In any case, it
> looks strange to have one function pointer with an '&' and another
> without.

Yes, that was certainly not intentional. I've removed the '&' now.

> Aside from that minor detail, the ehci-tegra.c changes are fine.

Ok, thanks for the feedback.

	Arnd
