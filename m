Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaACRtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:49:14 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37865 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaACRtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:49:12 -0500
MIME-Version: 1.0
In-Reply-To: <1388770748.14334.19.camel@joe-AO722>
References: <1388507067.2259.24.camel@joe-AO722>
	<201401011434.GAF34360.FFQOVtFOHJSMLO@I-love.SAKURA.ne.jp>
	<1388555362.2259.38.camel@joe-AO722>
	<201401011902.JEF43770.FSOVFFOHOtQLJM@I-love.SAKURA.ne.jp>
	<1388626389.2259.57.camel@joe-AO722>
	<201401021349.JGJ78109.OOFtFFHJMLSOQV@I-love.SAKURA.ne.jp>
	<CAGXu5jL7RunQuAw1MjnUMgWeYMX35+YcGeaZYCx6dhND3YUmsQ@mail.gmail.com>
	<1388770748.14334.19.camel@joe-AO722>
Date: Fri, 3 Jan 2014 09:49:11 -0800
X-Google-Sender-Auth: M8JJD-QQxEL074WotCeKP601dBw
Message-ID: <CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 9:39 AM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2014-01-03 at 09:08 -0800, Kees Cook wrote:
>> I'm on board with the idea of embedding comm/pid/whatever,
>
> I still think the space reduction isn't worth the
> complication.
>
>>  but I
>> either missed or do not understand why a second format-start character
>> is being added. I think this will complicate audits and maybe trigger
>> weird info leaks (imagine printing a string that was %-escaped, but
>> not 0x1A-escaped?)
>> Why not use % followed by 0x1A to be the start code, instead of just 0x1A?
>
> gcc would bleat an error for
>         "unknown conversion type character 0x1a in format".

Oh right. Bleh. Which gets me back around to the original patch which
overloaded %p.

Hrmpf. Yeah, on the fence about this.

-Kees

-- 
Kees Cook
Chrome OS Security
