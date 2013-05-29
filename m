Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935220Ab3E2VeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:34:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab3E2VeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:34:06 -0400
Date: Wed, 29 May 2013 14:34:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ric Mason <ric.masonn@gmail.com>, Simon Jeons <simon.jeons@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/2] Make the batch size of the percpu_counter
 configurable
Message-Id: <20130529143404.68feeed7a3e7934275220735@linux-foundation.org>
In-Reply-To: <1369862412.27102.368.camel@schen9-DESK>
References: <8584b08e57e97ecc4769859b751ad459d038a730.1367574872.git.tim.c.chen@linux.intel.com>
	<20130521134122.4d8ea920c0f851fc2d97abc9@linux-foundation.org>
	<1369178849.27102.330.camel@schen9-DESK>
	<20130521164154.bed705c6e117ceb76205cd65@linux-foundation.org>
	<1369183390.27102.337.camel@schen9-DESK>
	<20130522002020.60c3808f.akpm@linux-foundation.org>
	<1369265838.27102.351.camel@schen9-DESK>
	<20130529122605.082cbb1ad8f5cbc9e82e7b16@linux-foundation.org>
	<1369862412.27102.368.camel@schen9-DESK>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013 14:20:12 -0700 Tim Chen <tim.c.chen@linux.intel.com> wrote:

> > Do we have any performance testing results?  They're pretty important
> > for a performance-improvement patch ;)
> > 
> 
> I've done a repeated brk test of 800KB (from will-it-scale test suite)
> with 80 concurrent processes on a 4 socket Westmere machine with a 
> total of 40 cores.  Without the patch, about 80% of cpu is spent on
> spin-lock contention within the vm_committed_as counter. With the patch,
> there's a 73x speedup on the benchmark and the lock contention drops off
> almost entirely.

Only a 73x speedup?  I dunno what they pay you for ;)

How serious is this performance problem in real-world work?  For
something of this magnitude we might want to backport the patch into
earlier kernels (because most everyone who uses those kernels will be
doing this anyway).  However such an act would require a pretty clear
explanation of the benefit which end-users will see.


