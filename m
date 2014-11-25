Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaKYTTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:19:39 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35166 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaKYTTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:19:37 -0500
MIME-Version: 1.0
In-Reply-To: <20141125191416.GA4648@wfg-t540p.sh.intel.com>
References: <20141125191416.GA4648@wfg-t540p.sh.intel.com>
Date: Tue, 25 Nov 2014 11:19:36 -0800
X-Google-Sender-Auth: 2POZak1pf_-lSX71ta3Wsgk19mY
Message-ID: <CAGXu5jLCSpy6aD9Si-i93HchqQ4nkV1T=d7K_Ysw7TCSdyPCxA@mail.gmail.com>
Subject: Re: [stable] KASLR could not find suitable E820 region...
From: Kees Cook <keescook@chromium.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Qian, Shijun" <shijun.qian@intel.com>,
        "Bernal Marin, Miguel" <miguel.bernal.marin@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 11:14 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Kees,
>
> We noticed the below boot errors in stable kernels 3.16.7 and 3.17.2
> on real hardwares:
>
>         early console in decompress_kernel
>         KASLR could not find suitable E820 region...
>
>         Decompressing Linux... Parsing ELF... Performing relocations...
>
>         32-bit relocation outside of kernel!
>
> These kconfig options are enabled:
>
>         CONFIG_RANDOMIZE_BASE=y
>         CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000
>
> Before digging further, we'd like to ask for a quick answer that
> whether they've been fixed by some commit in current mainline kernel?

Possibly. There are recent fixes to the bss/brk detection code, which
could lead to corruptions. Normally they've all be initramfs
corruption, so relocation corruption seems unlikely.

If these boots are due to loading kernels above 4G, there are still
patches being discussed to solve those problems.

-Kees

-- 
Kees Cook
Chrome OS Security
