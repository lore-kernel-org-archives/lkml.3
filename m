Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632AbaGXUy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:54:29 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:37617 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553AbaGXUy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140724203019.GA20737@khazad-dum.debian.net>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
 <20140724151814.GE32421@khazad-dum.debian.net> <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
 <20140724190206.GL6673@thunk.org> <20140724203019.GA20737@khazad-dum.debian.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 24 Jul 2014 13:54:05 -0700
Message-ID: <CALCETrXtNUSCQEZ+SKJ5Br41rnF35kGqStkFuX6dN-3z5hVdmQ@mail.gmail.com>
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 1:30 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Thu, 24 Jul 2014, Theodore Ts'o wrote:
>> On Thu, Jul 24, 2014 at 08:21:38AM -0700, Andy Lutomirski wrote:
>> > > Should we add E<SOMETHING> to be able to deny access to GRND_RANDOM or some
>> > > future extension ?
>> >
>> > This might actually be needed sooner rather than later.  There are
>> > programs that use containers and intentionally don't pass /dev/random
>> > through into the container.  I know that Sandstorm does this, and I
>> > wouldn't be surprised if other things (Docker?) do the same thing.
>>
>> I wouldn't add the error to the man page until we actually modify the
>> kernel to add such a restriction.
>
> By then, it might be too late.  It would be really sad to find ourselves
> forced to return ENOSYS to getrandom(GRND_RANDOM) when we actually wanted to
> return EPERM/EACCES.
>
> Actually, we might not be able to do even that much: all it takes is for
> someone to have the bright idea of deploying userspace code that checks for
> ENOSYS only on a first "probe" getrandom() syscall without GRND_RANDOM, and
> does something idiotic when it gets ENOSYS later on a
> getrandom(GRND_RANDOM).  meh.  We can't even abuse the system ourselves :-)
>

Or that someone writes userspace code that gets -EPERM/-EACCESS on
getrandom with GRND_RANDOM and falls back to something worse than
getrandom w/o GRND_RANDOM.

--Andy
