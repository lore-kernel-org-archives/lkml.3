Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3C3MDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:03:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3C3MDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:03:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 2/7] USB: EHCI: make ehci-spear a separate driver
Date: Sat, 30 Mar 2013 12:03:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Deepak Saxena <dsaxena@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
References: <Pine.LNX.4.44L0.1303291353210.1467-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303291353210.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303301203.03562.arnd@arndb.de>
X-Provags-ID: V02:K0:/xjXrrYXX8/TwO+/smoXWX+ZIhE/FH51ckFcPTDW/Lq
 uJitjmrl+fKM8FK8iSOWCFyigwzG9NcQhn9MMbel1W0wKBpXTH
 l7EygwZO2BLdEl5Wa/xZUqvIHIZnoDgEfTQshd7fByIfJRD3iq
 zPfWKAEOVq1QwebN2j4GYZ3Ogxr4S5T+b5UyhYdE2oinWZr7Ls
 tghCSv1fy0lDPmBw+hgGYVpB5cDac5Kb6YpF9rXaCc37EYin2a
 AEYj27906+rB9S2mmJ4obrgR+aOsoI1XpU9mwAyHWZd99Yq/EL
 Xxq+u9LLEESqs6IsV2dWLFZaLQlggzza1NOCuuIXwsVI9/nepD
 2Z54MOH3m+o3jLkyYBIs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 March 2013, Alan Stern wrote:
> On Thu, 28 Mar 2013, Arnd Bergmann wrote:
> 
> > From: Manjunath Goudar <manjunath.goudar@linaro.org>
> > 
> > Separate the SPEAr host controller driver from ehci-hcd host code
> > so that it can be built as a separate driver module.
> > This work is part of enabling multi-platform kernels on ARM;
> > however, note that other changes are still needed before SPEAr can be
> > booted with a multi-platform kernel, but they are queued in the
> > arm-soc tree for 3.10.
> > 
> > With the infrastructure added by Alan Stern in patch 3e0232039
> > "USB: EHCI: prepare to make ehci-hcd a library module", we can
> > avoid this problem by turning a bus glue into a separate
> > module, as we do here for the SPEAr bus glue.
> > 
> > In V3:
> >  -Detailed commit message added here about why this patch is required.
> >  -Eliminated ehci_spear_setup routine beacuse hcd registers
> >   directly setting in spear_ehci_hcd_drv_probe function.
> 
> Fix the grammar, please.

Done. I agree some of this is hardly legible.

Manjunath, I can teach you about device drivers and submission
procedures, but I cannot teach you basic English. If necessary, find
someone to proofread your emails.
> > -static int ehci_spear_setup(struct usb_hcd *hcd)
> > -{
> > -	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> > -
> > -	/* registers start at offset 0x0 */
> > -	ehci->caps = hcd->regs;
> 
> This line never got moved into spear_ehci_hcd_drv_probe().

Ah, I missed it. Thanks for looking at this more carefully than
I did.

> > @@ -161,7 +130,7 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
> >  		goto err_put_hcd;
> >  	}
> >  
> > -	ehci = (struct spear_ehci *)hcd_to_ehci(hcd);
> > +	ehci = to_spear_ehci(hcd);
> >  	ehci->clk = usbh_clk;
> 
> I strongly believe that the name "ehci" should be reserved for
> variables of type struct ehci_hcd.  Here and in the start, stop, and
> remove routines, please use "spear_ehci" as the name for a variable of
> type struct spear_ehci.  Or whatever else you want -- just don't call
> it "ehci" or "ehci_p".

Ok, renamed to "sehci" in lack of a better idea. I noticed this before,
but I did not ask Manjunath to fix it because it was a preexisting mistake
in the driver.

	Arnd
