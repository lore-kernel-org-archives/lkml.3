Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaGDK1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:27:13 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59241 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaGDK1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:27:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: get rid of hardcoded assumptions about kernel stack size
Date: Fri, 04 Jul 2014 12:27:04 +0200
Message-ID: <4429781.iuSvvPCxYj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53B6541B.6000702@samsung.com>
References: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com> <201407032224.28386.arnd@arndb.de> <53B6541B.6000702@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:umN1ztHvhSOG/w7LYpvkxXO8gLuCk9sKMoRjdm0bd2F
 xFts66eXjHO7HUjMhMix7oFNk7ZJNDqRylX9fSeJpnKfbCY40Q
 idvTOv8i14fcv88Qn5rGSObTJReu9ofR00mnFm/9CHfS+NKtWW
 bTfGA8Vo6LqSh+4NR+SRfL0ke2wEoqZTTaj2yhhR1Gr73WrG8x
 Iju4OJZqzlgoEAV4UhLaM/SIqVbwYD56QuQ8/kFSgAG3IL0gTN
 ibZX6xtViCQtTwQRAIV5GLEytvZrb2UEMsS0msf95e9mEo76lH
 s690DSJIHqlmdzyDtNmfRKHi+W+2PgtJKKn7a7XxuN2F6JL/GK
 zZI8xxPtdjhrjHOOBWbk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014 11:13:31 Andrey Ryabinin wrote:
> > 
> > but I wonder if there is a way to avoid the extra include here, as it might also
> > cause a general slowdown because of asm/memory.h getting pulled into more .c
> > files. Would it be reasonable to hardcode PAGE_SIZE here?
> > 
> 
> IMO it's a bug of iop13xx platform, that it includes "higlevel" linux/reboot.h
> from a very "lowlevel" header mach/iop13xx.h. I think it should be fixed with a patch above.
> Slowing down of kernel build for a few more seconds is not good enough reason for me to
> hardcode PAGE_SIZE here.

I don't think we can pinpoint a specific header that is "wrong" here, the
fundamental problem is that our header files are a bit messy when it comes
to recursive inclusion and we'd be better off if we generally were a little
more careful about including headers from other headers.

It's also very hard to retroactively clean this up on a large scale.

	Arnd
