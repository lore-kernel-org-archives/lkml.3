Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934997AbaEaAs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:48:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45100 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934638AbaEaAs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:48:57 -0400
Message-ID: <538926F6.7080409@kernel.dk>
Date: Fri, 30 May 2014 18:48:54 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Paolo Valente <paolo.valente@unimore.it>
CC: Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O Scheduler
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <20140530160712.GG24871@htj.dyndns.org>
In-Reply-To: <20140530160712.GG24871@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-30 10:07, Tejun Heo wrote:
> We do have multiple ioscheds but sans for anticipatory which pretty
> much has been superceded by cfq, they serve different purposes and I'd
> really hate the idea of carrying two mostly similar ioscheds in tree.

AS was removed, and exactly for that reason. So lets make one thing very 
clear: we are not going to carry two implementations of CFQ, that differ 
in various ways. That will not happen. We're going to end up with one 
"smart" IO scheduler, not several of them.

> For some reason, blkcg implementation seems completely different but
> outside of that, bfq doesn't really seem to have diverged a lot from
> cfq and the most likely and probably only way for it to be merged
> would be if you just mutate cfq into bfq.  The whole effort is mostly
> about characterizing and refining the scheduling algorithm anyway,
> right?  I'd really love to see that happening.

Patching CFQ would be the right way to go, imho. That would also make it 
very clear what the steps are to get there, leaving us with something 
that can actually be backtracked and debugged. I think the patch series 
already looks pretty good, basically patch #2 "just" needs to be turned 
into a series of patches for CFQ.

What I really like about the implementation is, as Tejun highlights, 
that the algorithm is detailed and characterized. Nobody ever wrote any 
detailed documentation on CFQ - I think the closest is a talk I gave at 
LCA in 2007 or so. That said, the devil is _always_ in the details when 
it comes to nice algorithms. When theory meets practice, then the little 
tweaks and tunings required to not drop 10% there or 20% here is when it 
gets ugly. And that's where CFQ has the history going for it, at least. 
Which is another reason for turning patch #2 into a series of changes 
for CFQ instead. We need to end up with something where we can 
potentially bisect our way down to whatever caused any given regression. 
The worst possible situation is "CFQ works fine for this workload, but 
BFQ does not" or vice versa. Or hangs, or whatever it might be.


-- 
Jens Axboe

