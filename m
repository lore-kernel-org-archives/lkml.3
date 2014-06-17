Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbaFQRsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:48:36 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:27069 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbaFQRsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:48:35 -0400
Message-ID: <1403027312.2464.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RESEND] shm: shm exit scalability fixes
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jack Miller <millerjo@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        miltonm@us.ibm.com, anton@au1.ibm.com
Date: Tue, 17 Jun 2014 10:48:32 -0700
In-Reply-To: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 12:27 -0500, Jack Miller wrote:
> [ RESEND note: Adding relevant CCs, fixed a couple of typos in commit message,
> patches unchanged. Original intro follows. ]
> 
> All -
> 
> This is small set of patches our team has had kicking around for a few versions
> internally that fixes tasks getting hung on shm_exit when there are many
> threads hammering it at once.
> 
> Anton wrote a simple test to cause the issue:
> 
> http://ozlabs.org/~anton/junkcode/bust_shm_exit.c

I'm actually in the process of adding shm microbenchmarks to perf-bench
so I might steal this :-)

> 
> Before applying this patchset, this test code will cause either hanging
> tracebacks or pthread out of memory errors.

Are you seeing this issue in any real world setups? While the program
does stress the path you mention quite well, I fear it is very
unrealistic... how many shared mem segments do real applications
actually use/create for scaling issues to appear?

I normally wouldn't mind optimizing synthetic cases like this, but a
quick look at patch 1/3 shows that we're adding an extra overhead (16
bytes) in the task_struct.

In any case, I will take a closer look at the set.

Thanks,
Davidlohr

