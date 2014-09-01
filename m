Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaIAS7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:59:36 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39373 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaIAS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:59:33 -0400
Message-ID: <1409597968.1055.1.camel@kepstin.ca>
Subject: Re: [bisected, regression] 3.17-rc2 kernel doesn't load initramfs
 with EFI stub boot
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Matt Fleming <matt@console-pimps.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 01 Sep 2014 14:59:28 -0400
In-Reply-To: <20140901184208.GA3001@console-pimps.org>
References: <1409155357.1084.1.camel@kepstin.ca>
	 <20140901184208.GA3001@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 19:42 +0100, Matt Fleming wrote:
> On Wed, 27 Aug, at 12:02:37PM, Calvin Walton wrote:
> >  Hi all,
> > 
> >  When I tried booting the 3.17-rc2 kernel on my Lenovo ThinkPad 
> > T440p
> >  (16gb ram) via Gummiboot/EFI stub, it failed with an error saying 
> > that
> >  it could not mount root. A little investigation revealed that the
> >  initramfs did not load, so mounting by filesystem UUID failed.
> >  I've bisected the change, and it has led me to:
> > 
> >  4bf7111f50167133a71c23530ca852a41355e739 is the first bad commit
> >  commit 4bf7111f50167133a71c23530ca852a41355e739
> >  Author: Yinghai Lu <yinghai@kernel.org>
> >  Date:   Sat Jun 14 12:23:41 2014 -0700
> > 
> >      x86/efi: Support initrd loaded above 4G
> 
> Thanks for reporting this. Could you try the below commit and see
> whether it fixes things for you?
> 
>   http://article.gmane.org/gmane.linux.kernel.efi/4524

With Yinghai Lu's patch from the linked message, my ThinkPad is now 
booting correctly. (Admittedly using a rather "small" 7MB intramfs - I 
don't have any >2GB ones handy).

Feel free to take a
Tested-by: Calvin Walton <calvin.walton@kepstin.ca>

Thanks!


-- 
Calvin Walton <calvin.walton@kepstin.ca>
