Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaDRPJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:09:22 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:56345 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <53513A7E.5050907@meduna.org>
References: <534C3606.7010206@meduna.org>
	<534C731F.1050406@meduna.org>
	<534DADF1.6060608@meduna.org>
	<53500184.4050309@meduna.org>
	<53505BD7.9050004@meduna.org>
	<CAOcfFMyTmQH-FwGE2YWoA76ypzBtWPYVTyi+4QpEMnrRtw8QVg@mail.gmail.com>
	<53513A7E.5050907@meduna.org>
Date: Fri, 18 Apr 2014 11:09:16 -0400
Message-ID: <CAOcfFMwybECrCM6ovQs4HdOHDWPAMtyi3hzAYdsKZZBERQAzTQ@mail.gmail.com>
Subject: Re: BUG: spinlock trylock failure on UP - reverting timer patches helps
From: jordan <triplesquarednine@gmail.com>
To: Stanislav Meduna <stano@meduna.org>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey slavo

> many thanks for the tests. I probably botched something during
> the reverting - I now tried some more experiments and the system
> now runs without BUGs and without kernel leak - of course
> it needs some more uptime to be really sure.

No problem. It's good to hear that is working. My AMD Phenom II 965
has 1day, 10hours uptime. Hopefully that foreshadows your system
running well.

> My combined revert patch from 3.12.15-rt25 is at
>   http://pastebin.com/MYLqbmZw
> That was all that was needed.

Yup. I suggest anyone from the list who can't get their machines to
boot with those commits applied, test that patch.

>> Yeah, i know a handful of people [amd users] that have now reported
>> success booting into 3.14-rt1 reverting those patches.  Personally, I
>> have disabled NO_HZ_FULL and have switched back to 'old tick' method
>> in kconfig. I don't think the latest no_hz stuff is stable enough...
>
> My problems were with periodic timers (I am on an embedded system
> that runs things periodically anyway and I have also my doubts
> regarding the stability), so the latest code did not break
> only NO_HZ_FULL.

ah, thanks for the clarification [ i must have missed that bit - i was
just glad someone else had verified on the list that those commits
were problematic, as i hadn't gotten any response]. NO_HZ_FULL had
been alright for me, for a while - so i didn't really notice the
breakage with periodic timers, but that is good to know.

I think periodic timers + reverting those patches + resurrecting sirq
threads on seems to be the best on 3.14-rt, afaict.

Jordan

> Thanks
> --
>                                        Stano
>
