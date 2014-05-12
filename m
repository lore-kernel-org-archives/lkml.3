Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbaELRuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:50:44 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41586 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853AbaELRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:50:43 -0400
Message-ID: <537109EF.4010902@colorfullife.com>
Date: Mon, 12 May 2014 19:50:39 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Subject: Re: [PATCH 1/6] ipc/sem.c: further whitespace cleanups
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com> <1399716199-26776-2-git-send-email-manfred@colorfullife.com> <1399851275.11110.1.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1399851275.11110.1.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On 05/12/2014 01:34 AM, Davidlohr Bueso wrote:
> On Sat, 2014-05-10 at 12:03 +0200, Manfred Spraul wrote:
>> Somehow <TAB>$ was overlooked in the last round of whitespace
>> cleanups.
>> Do that now, before making further changes.
> No big deal, but this patch could easily be included in the the second
> patch instead on its own. Thanks.
The patch series you see is the third approach to fix the issue:
- do not store anything, call perform_atomic_semop() in count_semncnt()
   Really cool, no impact at all for semop() - but nasty.
   A sleeping operation could fail suddenly due to -ERANGE.

- store semncnt and semzcnt in struct sem:
   Increase in perform_atomic_semop(), decrease in unlink_queue().

- Now: store the pointer to the blocking op.

That's why the series got so fine-grained...

--
     Manfred


