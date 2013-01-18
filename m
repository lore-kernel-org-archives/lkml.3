Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3AROaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:30:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3AROaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:30:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 07/76] ARC: [optim] uaccess __{get,put}_user() optimised
Date: Fri, 18 Jan 2013 14:30:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-8-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-8-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181430.16142.arnd@arndb.de>
X-Provags-ID: V02:K0:wWUd1nJoKAxWr98BKLcgbWNMsIqJmGRXRyWjocOkOkx
 5HAed1v7m0/2jHVmEuWW7yQX2B+IR1DpjPy1olsEbWdRO0lM5d
 5aXPYpce8xjaYm5MwhW/s7tZkzrdheAtB16wPVJ1HZD6nm6Y/r
 +Dy3ylr2/cgD9aXkQ5AAoypi2vKP44pQzKR05a7rCUJRZWIQqw
 nouQ64bv1SXDpQPqAv3sW0qVwGjGHOcLmi5rN4ondPFkHyLUnn
 YEeuLAPdwEd+kVRmGHdrvz1NVuKHOVqVORNvtn8MHs2AoNTA8/
 wsHF92F0vnw3e2ygOCxNHxPwiGHYOZ0oC5sjhGKCXChhtAJ1UK
 QGvcO1rN1+neowxxhz0w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> Override asm-generic implementations. We basically gain on 2 fronts
> 
> * checks for alignment no longer needed as we are only doing "unit"
>   sized copies.
> 
>   (Careful observer could argue that While the kernel buffers are aligned,
>    the user buffer in theory might not be - however in that case the
>    user space is already broken when it tries to deref a hword/word
>    straddling word boundary - so we are not making it any worse).
> 
> * __copy_{to,from}_user( ) returns bytes that couldn't be copied,
>   whereas get_user() returns 0 for success or -EFAULT (not size). Thus
>   the code to do leftover bytes calculation can be avoided as well.

Interesting. I had thought that the compiler would be able to simplify
the calculation of the return value inline, but of course it cannot
because it has to be done inside the asm fixup.

> The savings were significant: ~17k of code.
> 
> bloat-o-meter vmlinux_uaccess_pre vmlinux_uaccess_post
> add/remove: 0/4 grow/shrink: 8/118 up/down: 1262/-18758 (-17496)
>                                                         ^^^^^^^^^
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
