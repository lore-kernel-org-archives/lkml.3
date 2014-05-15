Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaEOEY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:24:59 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:38169 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaEOEY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:24:58 -0400
Message-ID: <53744197.7090502@colorfullife.com>
Date: Thu, 15 May 2014 06:24:55 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de
Subject: Re: [PATCH 6/6] ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT}) standard
 compliant
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com> <1399716199-26776-2-git-send-email-manfred@colorfullife.com> <1399716199-26776-3-git-send-email-manfred@colorfullife.com> <1399716199-26776-4-git-send-email-manfred@colorfullife.com> <1399716199-26776-5-git-send-email-manfred@colorfullife.com> <1399716199-26776-6-git-send-email-manfred@colorfullife.com> <1399716199-26776-7-git-send-email-manfred@colorfullife.com> <1400079158.9356.10.camel@buesod1.americas.hpqcorp.net> <20140514153042.40e75ab7b63c0d32afa1e10c@linux-foundation.org>
In-Reply-To: <20140514153042.40e75ab7b63c0d32afa1e10c@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 05/15/2014 12:30 AM, Andrew Morton wrote:
> On Wed, 14 May 2014 07:52:38 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
>
>>> -	semcnt = 0;
>>> +	BUG_ON(sop->sem_flg & IPC_NOWAIT);
>>> +	BUG_ON(sop->sem_op > 0);
>> Hmm in light of Linus' recent criticism about randomly sprinkling
>> BUG_ONs in the kernel I'm not sure we want this. Yes, all those calls
>> are correct from a logical pov and should never occur, however, would
>> WARN be more suitable instead? I don't know.
> Well, this BUG_ON is so old that a decent approach would be to just
> delete the thing, if only Manfred wasn't changing stuff.
>
> Yes, if we can reasonably warn-then-recover then I guess that's worth
> doing.
I'll update the series anyway, then I remove the BUG_ONs entirely:
They are just debuging helpers, there is no need to keep them in the 
final code.

--
     Manfred
