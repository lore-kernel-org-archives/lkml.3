Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaFBJyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:54:33 -0400
Received: from srv01.voixit.com ([78.47.68.188]:38944 "EHLO srv01.voixit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaFBJyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:54:32 -0400
Subject: Re: [PATCH RFC - TAKE TWO - 09/12] block, bfq: reduce latency during request-pool saturation
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
From: Paolo Valente <paolo.valente@unimore.it>
In-Reply-To: <20140531135402.GC24557@mtj.dyndns.org>
Date: Mon, 2 Jun 2014 11:54:28 +0200
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <949E9E1B-87D6-42D6-832C-3C73E44DF668@unimore.it>
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <1401354343-5527-10-git-send-email-paolo.valente@unimore.it> <20140531135402.GC24557@mtj.dyndns.org>
To: Tejun Heo <tj@kernel.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il giorno 31/mag/2014, alle ore 15:54, Tejun Heo <tj@kernel.org> ha scritto:

> On Thu, May 29, 2014 at 11:05:40AM +0200, Paolo Valente wrote:
>> This patch introduces an heuristic that reduces latency when the
>> I/O-request pool is saturated. This goal is achieved by disabling
>> device idling, for non-weight-raised queues, when there are weight-
>> raised queues with pending or in-flight requests. In fact, as
>> explained in more detail in the comment to the function
>> bfq_bfqq_must_not_expire(), this reduces the rate at which processes
>> associated with non-weight-raised queues grab requests from the pool,
>> thereby increasing the probability that processes associated with
>> weight-raised queues get a request immediately (or at least soon) when
>> they need one.
> 
> Wouldn't it be more straight-forward to simply control how many
> requests each queue consume by returning ELV_MQUEUE_NO?

Arianna proposed me exactly this improvement about two months ago. The problem was that our TO-ADD list already contained several other improvements. So, to avoid waiting several more years before (re)submitting bfq, I decided that it would have been better to finally freeze the code for a while and pack it for submission.

If you agree, investigating and implementing this improvement will be our next step immediately after, and if the current version of bfq gets merged in some form.

Thanks,
Paolo

>  Seeky ones do
> benefit from larger number of requests in elevator but to only certain
> number given the fifo timeout anyway and controlling that explicitly
> would be a lot easier to anticipate the behavior of than playing
> roulette with random request allocation failures.
> 
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

