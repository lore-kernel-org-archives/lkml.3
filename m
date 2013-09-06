Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904Ab3IFR4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:56:18 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:55765 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3IFR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:56:16 -0400
MIME-Version: 1.0
In-Reply-To: <1378434264.4321.209.camel@pasglop>
References: <1378434264.4321.209.camel@pasglop>
Date: Fri, 6 Sep 2013 10:56:15 -0700
X-Google-Sender-Auth: aDWS0Gy4VcPZH-SbiBB57vaD9Zc
Message-ID: <CA+55aFwvPNu6-PHJmDkqihiCgMy=TH_we8LtVKm31teWhmLQPw@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 7:24 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
>  * A bunch of endian fixes ! We don't have full LE support yet in that
> release but this contains a lot of fixes all over arch/powerpc to use the
> proper accessors, call the firmware with the right endian mode, etc...

Ok, this caused a conflict in arch/powerpc/kernel/prom.c, where some
of the OF CPU number accessors had been moved to generic OF code
instead.

It *looks* to me like those accessors had already been made
endian-clean as part of the move to generic code, and so my conflict
resolution was to just ignore the parts of the changes the code that
no longer exists in prom.c, but you really should double-check my
resolution. Maybe I screwed it up.

But apparent'y the LE mode isn't finished, so hopefully even if I read
those changes wrong it won't affect you guys too badly. I didn't
test-compile any of it, yadda yadda..

              Linus
