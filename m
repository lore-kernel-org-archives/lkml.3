Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3IMGX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:23:59 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61746 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3IMGXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 02:23:55 -0400
MIME-Version: 1.0
In-Reply-To: <1379017042.2627.3.camel@leira.trondhjem.org>
References: <CAMuHMdViO7yNJ5rxvRkv5NhmW6PQY1N+HW75NwokFnGQp+nxxw@mail.gmail.com>
	<1378995227.3117.9.camel@leira.trondhjem.org>
	<CAMuHMdV+gVwKbk=RS0CNdiMuom-1j-8FAu+aVMLMDeOm3EXb1A@mail.gmail.com>
	<1379017042.2627.3.camel@leira.trondhjem.org>
Date: Fri, 13 Sep 2013 08:23:54 +0200
X-Google-Sender-Auth: izdoBxJyP2BaXwC4drp3odQo6f0
Message-ID: <CAMuHMdXz+wcjwf=ebcn3nMJhYk8mCGm2T16dcJzOGx+gN+TYTw@mail.gmail.com>
Subject: Re: Kernel size increase of +256 KiB (was: Re: RPCSEC_GSS: Share all
 credential caches on a per-transport basis)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:17 PM, Myklebust, Trond
<Trond.Myklebust@netapp.com> wrote:
>> Only for the modular case. What about builtin, e.g. for nfsroot?
>>
>> Or is it better to not build in NFS_V4 support in that case?
>>
>> config NFS_V4
>>           If unsure, say Y.
>>
>> config NFSD_V4
>>           If unsure, say N.
>>
>> So that's why my defconfig has NFS_V4 but not NFSD_V4.
>
> It should be possible now to compile in NFSv3 support (and/or NFSv2),
> while keeping NFSv4 a module. That will usually result in
> CONFIG_SUNRPC_GSS=m...

Indeed. Making NFS_V4 modular saves 102 KiB, i.e. 2.5% of a typical
almost-4-MiB kernel image!

> Of course, if your defconfig doesn't have module support then, yes, your
> only option to avoid compiling in rpcsec_gss is to not select NFSv4 at
> all.

It has. But it needs everything to boot (block, net, nfs) as built-in.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
