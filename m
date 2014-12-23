Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbaLWLOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:14:50 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:45516 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaLWLOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:14:48 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        joe@perches.com, ocfs2-devel@oss.oracle.com,
        Mark Fasheh <mfasheh@suse.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/1 linux-next] ocfs2: remove unnecessary sizeof(char)
Organization: D03
References: <1419275109-11641-1-git-send-email-fabf@skynet.be>
	<20141222133501.916a0944e5f0719e60e2c4eb@linux-foundation.org>
X-Hashcash: 1:20:141223:akpm@linux-foundation.org::cM6Lx7PU8xdMfuMt:0000000000000000000000000000000000000HXR
X-Hashcash: 1:20:141223:mfasheh@suse.com::m4p9eNrdeCd5+eq9:01zAV
X-Hashcash: 1:20:141223:linux-kernel@vger.kernel.org::mFrE8k6d8p6Kpq12:0000000000000000000000000000000002d4C
X-Hashcash: 1:20:141223:ocfs2-devel@oss.oracle.com::IYRLdmlivFeTHMo+:000000000000000000000000000000000004LUD
X-Hashcash: 1:20:141223:fabf@skynet.be::xb17i7Z7iZZlc6Mx:0005tZH
X-Hashcash: 1:20:141223:joe@perches.com::uTvdwUEhUtMOZ5TU:00NyGO
Date: Tue, 23 Dec 2014 12:14:44 +0100
In-Reply-To: <20141222133501.916a0944e5f0719e60e2c4eb@linux-foundation.org>
	(Andrew Morton's message of "Mon, 22 Dec 2014 13:35:01 -0800")
Message-ID: <87k31ibot7.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22 2014, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 22 Dec 2014 20:05:09 +0100 Fabian Frederick <fabf@skynet.be> wrote:
>
>>  
>> -	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) +
>> -			     (osb->max_slots * sizeof(char)), GFP_KERNEL);
>> +	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) + osb->max_slots,
>> +			     GFP_KERNEL);
>>  
>
> I dunno.  The code at present isn't particularly idiomatic, but it has
> some documentation value and says "I know what I'm doing".
>
> It would be better if it was
>
> 	kzalloc(sizeof(struct ocfs2_replay_map) *
> 		sizeof(struct ocfs2_replay_map.rm_replay_slots[0]), ...);
>
> And it would be better if C permitted that ;)
>
> 	kzalloc(sizeof(struct ocfs2_replay_map) *
> 		sizeof((struct ocfs2_replay_map *)0)->rm_replay_slots[0]), ...);
>
> yuk.

Well, the yuckiness could be hidden behind FIELD_SIZEOF. CodingStyle
explicitly mentions that macro. No opinion on whether it's worth it in
this case.

Rasmus
