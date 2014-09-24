Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaIXKhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:37:16 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59752 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaIXKhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:37:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: behanw@converseincode.com
Cc: mq@suse.cz, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Tom Gundersen <teg@jklm.no>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: Re: [PATCH] kbuild, LLVMLinux: Fix asm-offset generation to work with clang
Date: Wed, 24 Sep 2014 12:37:03 +0200
Message-ID: <3907075.FRP0QfugZW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411500331-9861-1-git-send-email-behanw@converseincode.com>
References: <1411500331-9861-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xGluiSujYK4wtSx0uxt+JmmcsgLNcoPecTsYZK7/IKb
 r1MKSn/7rkL9p2YvVOlSwTc4JIJZQx8UHb37JyCAtcQ0TLDyXc
 zPj5wFBadtoTGxcHPtzzrPfE9BtnzYq7CYiilPXvKqKV/3dUL9
 JNvzLCtTmq1E1xqyD1A+51NjcPeN31ArN71bL9qy6YablvImPv
 TlbuaF5rHgxjMRMeYOoqwNLk2RUu5zbrvC6pS2YxUQoxXKCJlK
 zLBispOyKXMOzgDUfPMLqlTIgTNJ8rijvG8QHsHeGnQPj7mYj5
 6B05GelaGnBkNIzMtME25lWeoJnnI+qHVIkQ4T9nuxI5mActpx
 lDc3gKLyp1GuxMqiaGGk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 12:25:31 behanw@converseincode.com wrote:
> 
>  #define DEFINE(sym, val) \
> -        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
> +       asm volatile("\n@->" #sym " %0 " #val : : "i" (val))

Isn't the '@' character to start a comment architecture specific?

If this makes it work on ARM, what about other architectures?

	Arnd
