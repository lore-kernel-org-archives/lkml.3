Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589Ab3IDJ1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:27:45 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44363 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934484Ab3IDJ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:27:43 -0400
MIME-Version: 1.0
In-Reply-To: <5226F9BF.8040304@asianux.com>
References: <52005571.4080704@asianux.com>
	<CAMuHMdXq3kY=xv7Rp5+OUTjefViNMTBzGAoutamuY07=cbRhNg@mail.gmail.com>
	<52268800.2010200@asianux.com>
	<CAMuHMdUkpEMx8LuoYxRcs2hmEg0ubJZ_c9kFXQUoOO_3sdh_vQ@mail.gmail.com>
	<5226EAAE.6090500@asianux.com>
	<CAMuHMdVY4jwKJau4ZbsMW3D2KabHU8fPibgzT_-tysDdiHzCXw@mail.gmail.com>
	<5226F9BF.8040304@asianux.com>
Date: Wed, 4 Sep 2013 11:27:43 +0200
X-Google-Sender-Auth: IPLRMx6VO5mt2KNq_ECzY0t4FrA
Message-ID: <CAMuHMdWc3mtva92qDy4j6iUhQc5grHA1-5=vC4iXZoSyFxB4cw@mail.gmail.com>
Subject: Re: [PATCH trivial] UAPI: Kbuild: add/modify comments for
 "uapi/Kbuild" and "uapi/linux/Kbuild"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 11:13 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>> Hmm... why we need "uapi/linux/" ?  (I can not find some related
>>> documents, so I have to 'guess').
>>
>> The "uapi" subdirectories are there to distinguish userspace headers from
>> kernelspace headers, and allow both to live in the kernel source tree.
>>
>> When running "make headers_install", the (processed) headers in the
>> various "uapi" subdirectories are copied to /usr/include.
>> Hence "uapi/linux/foo.h" becomes <linux/foo.h> in userspace.
>> In userspace there are no "uapi" subdirectories anymore.
>>
>
> Yeah, so why need another "uapi/*" excluding "uapi/linux" ?
>
> Are they also truly still "Userspace API" but which need not distinguish
> ? (at least, it seems that idea is not quite good).
>
> Hmm... maybe the "uapi/*" except "uapi/linux" are also installed? Is it
> for compatible (originally they are here, and now we have to follow, it
> is no reason to change if not find related critical issues)?

All uapi files are installed, a.o. /usr/include/scsi/, /usr/include/video/, ...

Historically, everything under "include" in the kernel source tree was
installed in /usr/include/, after (semi)manual cleanup.
Since the uapi split, everything is handled automatically.
Because of compatibility reasons (do not break userspace), paths had to
stay the same.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
