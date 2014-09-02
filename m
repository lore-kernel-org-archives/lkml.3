Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaIBQuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:50:20 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:38402 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaIBQuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:50:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7oZVWAiVTyiRkW5H1jB7JTPLZv==upSm6FcPZyj8hV5A@mail.gmail.com>
References: <alpine.LNX.2.00.1409021101450.2481@pobox.suse.cz> <CA+5PVA7oZVWAiVTyiRkW5H1jB7JTPLZv==upSm6FcPZyj8hV5A@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 2 Sep 2014 09:49:54 -0700
Message-ID: <CAK5ve-K7b5DDZZYZVNpGoA7Op-qMSmjnCzWYV-cyDeSvEEDQuw@mail.gmail.com>
Subject: Re: [PATCH] Revert "leds: convert blink timer to workqueue"
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Vincent Donnefort <vdonnefort@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 8:55 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Tue, Sep 2, 2014 at 5:03 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>> This reverts commit 8b37e1bef5a6b60e949e28a4db3006e4b00bd758.
>>
>> It's broken as it changes led_blink_set() in a way that it can now sleep
>> (while synchronously waiting for workqueue to be cancelled). That's a
>> problem, because it's possible that this function gets called from atomic
>> context (tpt_trig_timer() takes a readlock and thus disables preemption).
>>
>> This has been brought up 3 weeks ago already [1] but no proper fix has
>> materialized, and I keep seeing the problem since 3.18-rc1.
>>
>> [1] https://lkml.org/lkml/2014/8/16/128
>
> FWIW we're seeing it reported in Fedora too.  Perhaps a revert is the
> right approach for now.
>

I'm going to apply this patch and will send it out for Linus soon.

Thanks,
-Bryan
