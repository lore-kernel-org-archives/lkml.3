Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaIBRNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:13:49 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:42127 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaIBRNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:13:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-KnjD58aAsqdtYSNgmZt7mNCP5fsr809y7D1_AtBaB7wg@mail.gmail.com>
References: <alpine.LNX.2.00.1409021101450.2481@pobox.suse.cz>
	<CAK5ve-KnjD58aAsqdtYSNgmZt7mNCP5fsr809y7D1_AtBaB7wg@mail.gmail.com>
Date: Tue, 2 Sep 2014 13:13:47 -0400
X-Google-Sender-Auth: sgzTeVMWU2HRv7JfbhBkffaQV3U
Message-ID: <CA+5PVA7pqqVo6f3bjdwNM42rOWLLr+R308vjvS7bZSrTn2+0QQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "leds: convert blink timer to workqueue"
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Bryan Wu <cooloney@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Vincent Donnefort <vdonnefort@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 1:02 PM, Bryan Wu <cooloney@gmail.com> wrote:
> On Tue, Sep 2, 2014 at 2:03 AM, Jiri Kosina <jkosina@suse.cz> wrote:
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
>
> Is this 3.18-rc1? I think it should be 3.17-rc1, right?

Yes
.
josh
