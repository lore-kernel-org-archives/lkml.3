Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaIYJvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:51:14 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:39334 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaIYJvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140925093309.GG20043@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
	<1411579056-16966-10-git-send-email-will.deacon@arm.com>
	<54236A67.90001@uclinux.org>
	<20140925093309.GG20043@arm.com>
Date: Thu, 25 Sep 2014 11:51:10 +0200
X-Google-Sender-Auth: vbdHNkpDkuXCyfWvlTSboGMVM3c
Message-ID: <CAMuHMdVpCs2RtsdDpdN3tp9_Xa1TzDMM3Z5+pP07B7Y3He2hLA@mail.gmail.com>
Subject: Re: [PATCH v3 09/17] m68k: io: implement dummy relaxed accessor
 macros for writes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Greg Ungerer <gerg@uclinux.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:33 AM, Will Deacon <will.deacon@arm.com> wrote:
>> Putting them here means they won't have any multiple include protection
>> (there is no "#ifndef _IO_H" around them). Doesn't seem to lead to
>> any problems in practice. Just flagging it...
>
> That's easy enough to fix, and actually, we should have __KERNEL__ checks
> here too. Fixup below.

Why do we need __KERNEL__ checks? <asm/io.h> is not exported.
BTW, it seems there are many __KERNEL__ checks in arch/*/include/asm/
we don't need.

Or do I need more coffee?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
