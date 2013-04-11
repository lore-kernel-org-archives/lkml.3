Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3DKHos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:44:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab3DKHor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:44:47 -0400
Date: Thu, 11 Apr 2013 09:45:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dave Hansen <dave@sr71.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: sched/cputime: sig->prev_stime underflow
Message-ID: <20130411074529.GA1629@redhat.com>
References: <515DBB00.20208@sr71.net>
 <CAFTL4hxnNyWbn47PxPZDibzgOcqtw8v+t3EEzn+AM_pzFM=YeQ@mail.gmail.com>
 <5162E8DC.4080204@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5162E8DC.4080204@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 08:57:16AM -0700, Dave Hansen wrote:
> On 04/04/2013 04:41 PM, Frederic Weisbecker wrote:
> > Does this patch fix the issue for you?
> > https://lkml.org/lkml/2013/4/4/112
> 
> Nope, that doesn't seem to make a difference.  I'm still seeing the
> underflow.  I'm pretty sure it's already gone to hell by the time it
> gets in to the loop that's patched there.

Perhaps this is glich introduced by commit 
62188451f0d63add7ad0cd2a1ae269d600c1663d "cputime: Avoid multiplication
overflow on utime scaling" . Could you try to revert it and see if that
helps. If it does not, can you check if problem happen on 3.8 ?

Stanislaw
