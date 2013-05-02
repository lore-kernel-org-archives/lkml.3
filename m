Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3EBRzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:55:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3EBRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:55:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH, RFC 15/22] USB: EHCI: remove bogus #error
Date: Thu, 2 May 2013 19:55:08 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <Pine.LNX.4.44L0.1305021333020.1436-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1305021333020.1436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305021955.08470.arnd@arndb.de>
X-Provags-ID: V02:K0:HYXSAoLVnEyykqoXNd1SCmrUUGk0luCg9n/GO7oMBsW
 T2BHsHJ3lcUxHY5PPvMxsDirCsvcfrNhy3CBJxCqxXO8af2sZq
 utjBfYFaE9/Y47w1ctTwAqCRJJ5B4KWO++l+Gm94lurtlH94Ys
 r1cVI739zZ8Zn142swrbZ3sWgJ9J7OEfffYYF4SEuRrIc2vBho
 HpY+folLsKlovhYt86q6w+xYM5t5bcgXwv6lpiI7sxQitkbFEg
 i5L0jjbY+7rlwNGD7UtwLE4VDubp+JsmSUEDt4KcEJHsAEyJ4P
 wGftBO/KKi3xFn2WfJxvxuKcwY147Xnc46CO5Q7GnfBoqR3kE8
 m9EYNKTL78/a8I6j4mYs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Alan Stern wrote:
> On Thu, 2 May 2013, Arnd Bergmann wrote:
> 
> > The EHCI host controller driver can be built standalone now,
> > without enabling any of the available bus glue drivers, so
> > there is not really a reason to error out here:
> 
> On the other hand, there's no reason to build the driver without any 
> bus glue.  It wouldn't do anything.

Yes, as I mention below, we could also use Kconfig logic to prevent
that case, as the OHCI and UHCI patches from this series do, but I felt
that would be a lot of unnecessary churn, and having just ehci-hci.ko
enabled without a bus glue is not an error, it's just as pointless
as most of the other drivers we get with "make randconfig".

> > drivers/usb/host/ehci-hcd.c:1303:2: error:
> >  #error "missing bus glue for ehci-hcd"  #error "missing bus glue for ehci-hcd"
> > 
> > The alternative would be to change the Kconfig code to build
> > the ehci-hcd module only if any of the symbols below are
> > in fact enabled.

	Arnd
