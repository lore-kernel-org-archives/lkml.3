Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722AbaE3WXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:23:09 -0400
Received: from srv01.voixit.com ([78.47.68.188]:37935 "EHLO srv01.voixit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934266AbaE3WXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:23:08 -0400
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O Scheduler
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
From: Paolo Valente <paolo.valente@unimore.it>
In-Reply-To: <20140530160712.GG24871@htj.dyndns.org>
Date: Sat, 31 May 2014 00:23:01 +0200
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it>
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <20140530160712.GG24871@htj.dyndns.org>
To: Tejun Heo <tj@kernel.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il giorno 30/mag/2014, alle ore 18:07, Tejun Heo <tj@kernel.org> ha scritto:

> Hello, Paolo.
> 
> On Thu, May 29, 2014 at 11:05:31AM +0200, Paolo Valente wrote:
>> this patchset introduces the last version of BFQ, a proportional-share
>> storage-I/O scheduler. BFQ also supports hierarchical scheduling with
>> a cgroups interface. The first version of BFQ was submitted a few
>> years ago [1]. It is denoted as v0 in the patches, to distinguish it
>> from the version I am submitting now, v7r4. In particular, the first
>> two patches introduce BFQ-v0, whereas the remaining patches turn it
>> progressively into BFQ-v7r4. Here are some nice features of this last
>> version.
> 
> So, excellent work.  I haven't acteually followed the implementation
> of the scheduling logic itself but read all the papers and it seems
> great to me; however, the biggest problem that I have is that while
> being proposed as a separate iosched, this basically is an improvement
> of cfq.  It shares most of the infrastructure code, aims the same set
> of devices and usages scenarios and while a lot more clearly
> characterized and in general better performing even the scheduling
> behavior isn't that different from cfq.
> 

I am really glad to hear that, thanks.

> We do have multiple ioscheds but sans for anticipatory which pretty
> much has been superceded by cfq, they serve different purposes and I'd
> really hate the idea of carrying two mostly similar ioscheds in tree.
> 
> For some reason, blkcg implementation seems completely different but
> outside of that, bfq doesn't really seem to have diverged a lot from
> cfq and the most likely and probably only way for it to be merged
> would be if you just mutate cfq into bfq.  The whole effort is mostly
> about characterizing and refining the scheduling algorithm anyway,
> right?  I'd really love to see that happening.
> 

I do agree that bfq has essentially the same purpose as cfq. I am not sure that it is what you are proposing, but, in my opinion, since both the engine and all the new heuristics of bfq differ from those of cfq, a replacement would be most certainly a much easier solution than any other transformation of cfq into bfq (needless to say, leaving the same name for the scheduler would not be a problem for me). Of course, before that we are willing to improve what has to be improved in bfq.

BTW, we are already working on your recommendations for patch 01.

Paolo

> Thanks.
> 
> -- 
> tejun


--
Paolo Valente                                                 
Algogroup
Dipartimento di Fisica, Informatica e Matematica		
Via Campi, 213/B
41125 Modena - Italy        				  
homepage:  http://algogroup.unimore.it/people/paolo/

