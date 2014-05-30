Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790AbaE3Xyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:54:40 -0400
Received: from srv01.voixit.com ([78.47.68.188]:37963 "EHLO srv01.voixit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbaE3Xyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:54:39 -0400
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O Scheduler
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
From: Paolo Valente <paolo.valente@unimore.it>
In-Reply-To: <20140530232804.GA5057@htj.dyndns.org>
Date: Sat, 31 May 2014 01:54:34 +0200
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A8467E78-FC96-4458-A018-8E377F23E0F4@unimore.it>
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <20140530160712.GG24871@htj.dyndns.org> <464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it> <20140530232804.GA5057@htj.dyndns.org>
To: Tejun Heo <tj@kernel.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il giorno 31/mag/2014, alle ore 01:28, Tejun Heo <tj@kernel.org> ha scritto:

> Hello,
> 
> On Sat, May 31, 2014 at 12:23:01AM +0200, Paolo Valente wrote:
>> I do agree that bfq has essentially the same purpose as cfq. I am
>> not sure that it is what you are proposing, but, in my opinion,
>> since both the engine and all the new heuristics of bfq differ from
>> those of cfq, a replacement would be most certainly a much easier
>> solution than any other transformation of cfq into bfq (needless to
>> say, leaving the same name for the scheduler would not be a problem
>> for me). Of course, before that we are willing to improve what has
>> to be improved in bfq.
> 
> Well, it's all about how to actually route the changes and in general
> whenever avoidable we try to avoid whole-sale code replacement
> especially when most of the structural code is similar like in this
> case.  Gradually evolving cfq to bfq is likely to take more work but
> I'm very positive that it'd definitely be a lot easier to merge the
> changes that way and people involved, including the developers and
> reviewers, would acquire a lot clearer picture of what's going on in
> the process.

I understand, and apologize for proposing an inappropriate shortcut.

>  For example, AFAICS, most of the heuristics added by the
> later patches are refined versions of what's already in cfq and at
> least some are applicable regardless of the underlying scheduling
> algorithm.

Absolutely correct.

>  It all depends on the details but, for example, steps like
> the following would be it a lot easier to get merged.
> 
> * Identify the improvements which can be applied to cfq as-is or with
>  some adaptation and apply those improvements to cfq.
> 
> * Make prepatory changes to make transition to new base scheduling
>  algorithm easier.
> 
> * Strip out or disable cfq features which get in the way of
>  conversion.
> 
> * Switch the base algorithm to the timestamp based one.
> 
> * Rebuild stripped down features and apply new heuristics,
>  optimizations and follow-up changes.
> 

OK, we can try.

> I understand that this might be non-significant amount of work

This may be a non-negligible difficulty, as Arianna, who is actively helping me with this project, and I are working on bfq in our (little) spare time. But if you are patient enough, we will be happy to try to make it one step at a time.

> but at
> the same time it's not something which is inherently difficult.  It's
> mostly logistical after all and I'd be happy to help where I can.
> 

This is certainly reassuring for us.

Thanks again,
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

