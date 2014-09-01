Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaIASmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:42:13 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54648 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbaIASmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:42:11 -0400
Date: Mon, 1 Sep 2014 19:42:08 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [bisected, regression] 3.17-rc2 kernel doesn't load initramfs
 with EFI stub boot
Message-ID: <20140901184208.GA3001@console-pimps.org>
References: <1409155357.1084.1.camel@kepstin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409155357.1084.1.camel@kepstin.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug, at 12:02:37PM, Calvin Walton wrote:
> Hi all,
> 
> When I tried booting the 3.17-rc2 kernel on my Lenovo ThinkPad T440p 
> (16gb ram) via Gummiboot/EFI stub, it failed with an error saying that 
> it could not mount root. A little investigation revealed that the 
> initramfs did not load, so mounting by filesystem UUID failed.
> 
> A video of the failed boot is available here, if you're curious:
> https://www.youtube.com/watch?v=wOHTvg8Tico
> 
> I've bisected the change, and it has led me to:
> 
> 4bf7111f50167133a71c23530ca852a41355e739 is the first bad commit
> commit 4bf7111f50167133a71c23530ca852a41355e739
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Sat Jun 14 12:23:41 2014 -0700
> 
>     x86/efi: Support initrd loaded above 4G
> 
>     For boot efi kernel directly without bootloader.
>     If the kernel support XLF_CAN_BE_LOADED_ABOVE_4G, we should
>     not limit initrd under hdr->initrd_add_max.
> 
>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>     Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> 
> This commit reverts cleanly on top of 3.17-rc2, and the resulting 
> kernel boots correctly.

Thanks for reporting this. Could you try the below commit and see
whether it fixes things for you?

  http://article.gmane.org/gmane.linux.kernel.efi/4524

-- 
Matt Fleming, Intel Open Source Technology Center
