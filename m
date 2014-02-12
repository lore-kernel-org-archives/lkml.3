Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaBLLFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:05:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaBLLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:05:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Takahiro Akashi <takahiro.akashi@linaro.org>
Subject: Re: [PATCH 1/2] arm64: Add seccomp support
Date: Wed, 12 Feb 2014 12:05:10 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        wad <wad@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, "arndb@arndb.de" <arndb@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org> <2659759.AA5HtBcWYl@wuerfel> <CAB5YjtB6XnXRd90AUw=rJCOBKyfcngTQd3Kxft33XLCK+K=Vuw@mail.gmail.com>
In-Reply-To: <CAB5YjtB6XnXRd90AUw=rJCOBKyfcngTQd3Kxft33XLCK+K=Vuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402121205.10802.arnd@arndb.de>
X-Provags-ID: V02:K0:RokjlI/Dt+Sl2BJ/Dh1mB8gACif/054rWjV83TsExlC
 ie3J3RHdtOAv60N7c7EHo4MgWl34uZkJFRybUXRKGCHn1P6+Nh
 j2okdVt1/GBCwZMWADUpGzSl1Qi6/6G68qOXNvHu2EbYniAScT
 wcZKm9CI1JDyIaw1Flb0BbjInTqfK3hvwh9/QSoY5LFinqOe+t
 Hh0Z97tWVNTcPsQBH7rK9R/4bRtazhSL3BNyotQduDjtaOOSzj
 uxj9VNBiFe/1fya3Mm31n+0ADk2Qb5EJhdqomdUnCaU3soz4tk
 r8mIpDqRqKZlXtGygGkwB3niA57yF+gBwf/XiTF1wg8y7VZ/c9
 8x4eiDlDqKeDFA2hvzAo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 February 2014, Takahiro Akashi wrote:
> Thank you for your comment.
> I'm afraid that I can't do so because how compat syscall numbers
> are named varies from arch to arch. __NR_compat_read is used
> only on arm64, while __NR_ia32_read on x86. On other archs,
> __NR_read is common to 32-bit and 64-bit tasks.

It's fine, I'm the maintainer for asm-generic ;-)

All future architectures are required to do it the same way as
arm64 and use the generic syscall ABI. It just means we won't be
able to share this header with x86 or other architectures that
use a nonstandard string. We should have it in the generic place
even if arm64 is the only user for now.

	Arnd
