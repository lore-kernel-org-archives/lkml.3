Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbaIKPPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:15:15 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:63335 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaIKPPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:15:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Yang Yingliang <yangyingliang@huawei.com>, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will.deacon@arm.com
Subject: Re: [PATCH] arm64: add guard macro of unistd.h to prevent double inclusion
Date: Thu, 11 Sep 2014 17:14:36 +0200
Message-ID: <3578303.U9ScbKhEK5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410235185-16652-1-git-send-email-yangyingliang@huawei.com>
References: <1410235185-16652-1-git-send-email-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lGuhKRrZhmYlmczF0cc4DRy75/MHGFQ2eGKMxB5pLHz
 I2oad37QzYZmUcIXK2JqLPlL3Bn/Um4AUsn2mHdY9pWlmqeHqx
 GwwWCYDoFs/jxqxHY0zZow44Wz3bhaG2bODrMDpSTMzkqPPnHs
 TJCYJDiuFNwtZQh6U3ev+qhfs08I3vRz8iv/uSHROjKC1U5y6W
 ujI1gdddcQeeKVpRalE+49s6nYh7A2ZzuUTSrQsN1L8gzMZtwK
 wYULn0L4wYitUcKtbdVU5VU+/pBPxyjcG1KSqua1LwAMxKNwxB
 aRbUOOKQ418lSj3vNvES0XIuW3xVAMShUSJIIdKAusAKxtkJoI
 oWmuMd3VZMr/A2a8BKYQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 11:59:45 Yang Yingliang wrote:
> Add guard macros in both uapi/asm/unistd.h and asm/unistd.h.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  arch/arm64/include/asm/unistd.h      | 5 +++++
>  arch/arm64/include/uapi/asm/unistd.h | 5 +++++
>  2 files changed, 10 insertions(+)

This will lead to an empty system call table, because asm/unistd.h
is intentionally included multiple times in order to get both the
syscall definition and the macros, which are defined in pairs in
this file.

How did you come up with this patch?

	Arnd

> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> index 6d2bf41..21a7dec 100644
> --- a/arch/arm64/include/asm/unistd.h
> +++ b/arch/arm64/include/asm/unistd.h
> @@ -13,6 +13,9 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
> +#ifndef __ASM_ARM64_UNISTD_H
> +#define __ASM_ARM64_UNISTD_H
> +
>  #ifdef CONFIG_COMPAT
>  #define __ARCH_WANT_COMPAT_SYS_GETDENTS64
>  #define __ARCH_WANT_COMPAT_STAT64
> @@ -48,3 +51,5 @@
>  #include <uapi/asm/unistd.h>
>  
>  #define NR_syscalls (__NR_syscalls)
> +
> +#endif /* __ASM_ARM64_UNISTD_H */
> diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
> index 1caadc2..ab72cac 100644
> --- a/arch/arm64/include/uapi/asm/unistd.h
> +++ b/arch/arm64/include/uapi/asm/unistd.h
> @@ -13,4 +13,9 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
> +#ifndef _UAPI__ASM_ARM64_UNISTD_H
> +#define _UAPI__ASM_ARM64_UNISTD_H
> +
>  #include <asm-generic/unistd.h>
> +
> +#endif /* _UAPI__ASM_ARM64_UNISTD_H */
> 

