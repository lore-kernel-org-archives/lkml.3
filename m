Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaEHO1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:27:19 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59866 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaEHO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:27:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 5/8] usb: phy: msm: reset controller is mandatory now
Date: Thu, 08 May 2014 16:27:12 +0200
Message-ID: <63604204.8DeBUXOvCl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399558909.8165.8.camel@iivanov-dev>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de> <1399557141-1346645-6-git-send-email-arnd@arndb.de> <1399558909.8165.8.camel@iivanov-dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3HqqTj6fM0UOcLVRoX36G3V/LSfAXPsuZ6HmtZwQK9I
 ENSNk0XeXN/MsRgK8b6/zzQDRniX9AkIPLWJUhllVMe+u6mxm1
 HLKpXkiVRwRkAqcGPQYwjksGv9Mt+9QSMHAOGzAO2lI2ioXxir
 MN2J4owdcJyhzHjsCQCmtlHCGEB3wmbDqJ3ALJ4FN0PZJw3kNZ
 83UaAwxux956GbS003bhoIg9Mu3b/ZFHKLiyZRo6XoyzHWYxWe
 VdfTctYLRgXerKAjqptmgcGlh9ru3mN74/R9rbfIMStkxosCH8
 0xZ78x069/ySBDLK/HRX1BElnlEBs6Kxw81LPtFsITKAmludRj
 1WE3Ws63hBMNL2sfXCqY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2014 17:21:49 Ivan T. Ivanov wrote:
> > @@ -168,7 +168,7 @@ config USB_EHCI_HCD_AT91
> >  
> >  config USB_EHCI_MSM
> >       tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
> > -     depends on ARCH_MSM
> > +     depends on ARCH_MSM && RESET_CONTROLLER
> 
> This driver did not use reset controller API.
> 
> >       select USB_EHCI_ROOT_HUB_TT
> >       select USB_MSM_OTG

It does select USB_MSM_OTG though, which uses it:

Maybe that 'select' is wrong?

	Arnd
