Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaHIRn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:43:57 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:60916 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaHIRnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:43:52 -0400
MIME-Version: 1.0
In-Reply-To: <53E65747.9070108@roeck-us.net>
References: <20140808213457.511493898@linuxfoundation.org>
	<53E57279.1030106@roeck-us.net>
	<20140809034911.GA2348@kroah.com>
	<20140809034950.GB2348@kroah.com>
	<53E5A0D1.10507@roeck-us.net>
	<20140809141609.GA21639@kroah.com>
	<53E63871.5040504@roeck-us.net>
	<CA+55aFwFMFgj2PqftqZLntjYkbm+pG8adJPMO+sD9=U67WOYkg@mail.gmail.com>
	<53E65747.9070108@roeck-us.net>
Date: Sat, 9 Aug 2014 10:43:51 -0700
X-Google-Sender-Auth: PPYXiSXu6ogc8NqwNXRNCaw5j3E
Message-ID: <CA+55aFw=1YEfa+J5xLMbSycT4YBvEmgbDGN62nD1AL9-q1NPoA@mail.gmail.com>
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>, YoungJun Cho <yj44.cho@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        satoru takeuchi <satoru.takeuchi@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>, stable <stable@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 10:15 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>
> ERROR (phandle_references): Reference to non-existent node or label
> "disp_pd"
>
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [arch/arm/boot/dts/exynos5420-arndale-octa.dtb] Error 2

Ok, so it's something else that was apparently known about in -next,
but not mentioned when pushing to me. Oh well.

The new disp_dt use was added by commit 5a8da524049c ("ARM: dts:
exynos5420: add dsi node"), while commit d51cad7df871 ("ARM: dts:
remove display power domain for exynos5420") removed the node.

I'll leave it broken until the ARM people get around to fixing it.
Likely by just removing the disp_dt line from the dsi node, but I'll
let the proper people sort it out.

               Linus
