Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3CFQIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:08:39 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:46353 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3CFQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:08:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130306080642.GA535@polaris.bitmath.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
	<20130306080642.GA535@polaris.bitmath.org>
Date: Wed, 6 Mar 2013 08:08:34 -0800
X-Google-Sender-Auth: MTMR_cD3L2WdOvST4UV52yvynNI
Message-ID: <CA+55aFxkDRoNEEw+8RwrSCsRUCUcRbEE57hzFQ8dPUXT2CWMog@mail.gmail.com>
Subject: Re: Linux 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 12:06 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
> Or not. ;-) This commit breaks boot on my MacBookAir3,1:
>
> commit 8d57470d8f859635deffe3919d7d4867b488b85a
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Fri Nov 16 19:38:58 2012 -0800
>
>     x86, mm: setup page table in top-down

Argh. The whole page table setup crud is scarily fragile.

> Being a 64-bit apple-EFI machine, it probably runs through an obscure
> path in this patch. I wish I had more vital information, but I get the
> white screen of death, so not much to go on so far.

I actually test on my MBA (also EFI boot), but it's a slightly newer
4,1 version, and the memory map looks very different (I've got 251
memory regions reported by efi, ugh).

So Apple EFI does work at least in some cases, just not yours. Let's
hope Yinghai can figure this one out..

                 Linus
