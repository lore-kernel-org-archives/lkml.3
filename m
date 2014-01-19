Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaASOh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 09:37:28 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43178 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaASOhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 09:37:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140119122058.GB27187@pd.tnic>
References: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
	<1390079163.25980.2.camel@x41>
	<CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
	<20140118221212.GB15543@pd.tnic>
	<CACPM=kUtm0i5qRWGs9yKBMDZ0fFEQ5-US6wdfa+bjh6ZB2ZhOQ@mail.gmail.com>
	<20140118223308.GH15466@pd.tnic>
	<CACPM=kVDpAFSWb3v8zS0+JE2U5C6pSNvqvL+aQ-npLtU05JGrA@mail.gmail.com>
	<20140118234611.GJ15466@pd.tnic>
	<CACPM=kXvNHA42yP9oBJX1OoH_c+v9mDX4UaYx9huKsk8FJZHwA@mail.gmail.com>
	<20140119122058.GB27187@pd.tnic>
Date: Sun, 19 Jan 2014 15:37:24 +0100
X-Google-Sender-Auth: Gy69m654zdcjHnHb9MYbWH3xLTU
Message-ID: <CACPM=kUf+yR1HsPMJy+rf=p5uLWEw0RJSxgye0dPGe+-DeBURA@mail.gmail.com>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/19 Borislav Petkov <bp@alien8.de>:
> On Sun, Jan 19, 2014 at 12:57:11AM +0100, Bjarke Istrup Pedersen wrote:
>> To be able to build the kvp deamon, which has been broken since the
>> UAPI split a few versions ago.
>
> Right.
>
>> The tool located in tools/hv.
>
> Ah, I see.
>
> Those things there could use a Makefile, btw.
>
> $ gcc -Wall -o hv_kvp_daemon{,.c}
> hv_kvp_daemon.c:38:26: fatal error: linux/hyperv.h: No such file or directory
>  #include <linux/hyperv.h>
>                           ^
> compilation terminated.

Yep, but applying the v2 patch, and then building the headers,
followed by copying hyperv.h from the output to /usr/include/linux
makes it build fine. :-)

> Oh, and some build infra so that they can be buildable from within the
> kernel tree.

Indeed, but first lets get it building :-)

/Bjarke

> Oh well...
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
