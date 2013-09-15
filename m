Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab3IOLeo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 07:34:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58866 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3IOLen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 07:34:43 -0400
Message-ID: <52359B4E.7060700@colorfullife.com>
Date: Sun, 15 Sep 2013 13:34:38 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] ipc/sem.c: Race in sem_lock()
References: <1379194496-4642-1-git-send-email-manfred@colorfullife.com> <1379225343.5545.154.camel@marge.simpson.net>
In-Reply-To: <1379225343.5545.154.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 09/15/2013 08:09 AM, Mike Galbraith wrote:
> On Sat, 2013-09-14 at 23:34 +0200, Manfred Spraul wrote:
>
>> The bug is probably also present in 3.10 and 3.11, but for these kernels
>> is is probably simpler just to move the test of sma->complex_count after
>> the spin_is_locked() test.
> IMHO, your 6 patch series should go to stable as well.  Scalability is
> still BAD without them.  Now, you've shown the lock split to be buggy.
>
> Logically, the whole thing should be reverted entirely in stable, or
> fixed up properly.
Davidlohr: Are you working on fixing the open issues?

IMHO Mike is right, especially for the 3.10 long-term kernel:
Either everything in ipc/*.c must be reverted or it should be fixed 
properly (i.e.: cherry-pick ipc/*)

I have created bugzilla entries for all issues I'm aware of:

https://bugzilla.kernel.org/show_bug.cgi?id=61351
     I sent a patch yesterday.

https://bugzilla.kernel.org/show_bug.cgi?id=61321
https://bugzilla.kernel.org/show_bug.cgi?id=61331
https://bugzilla.kernel.org/show_bug.cgi?id=61341
https://bugzilla.kernel.org/show_bug.cgi?id=61361
https://bugzilla.kernel.org/show_bug.cgi?id=61371
     No patches for theses 5 bugs.

And: Given these numbers from Mike, I would hate to revert anything:
On 09/15/2013 10:06 AM, Mike Galbraith wrote:
> On Sun, 2013-09-15 at 08:09 +0200, Mike Galbraith wrote:
>
>> Humongous improvements...
> (a couple sem-waitzero numbers)
>
> master:  Cpus 64, interleave 1 delay 0: 10039494796 in 30 secs
> 3.10.10: Cpus 64, interleave 1 delay 0:   129236313 in 30 secs
>
> (rapidly scrolling micro-font bench vs reality disclaimer)
One semop() completed every 3 ns, around 600 cpu ticks per operation.

--
     Manfred
