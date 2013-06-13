Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab3FMWgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:36:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab3FMWgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:36:01 -0400
Date: Thu, 13 Jun 2013 15:35:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-Id: <20130613153551.39ffdf595d989be10c773d23@linux-foundation.org>
In-Reply-To: <20130613223028.GG13970@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
	<20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
	<20130613020536.GA10979@localhost>
	<20130612200311.7f9d938a.akpm@linux-foundation.org>
	<20130613185318.GB12075@mtj.dyndns.org>
	<20130613120439.fe56d178a1143089136fdacc@linux-foundation.org>
	<20130613191507.GB13970@mtj.dyndns.org>
	<20130613122339.239a721d097a64435817a780@linux-foundation.org>
	<20130613193514.GD13970@mtj.dyndns.org>
	<20130613151040.8e11da022519fff7d5e8ea77@linux-foundation.org>
	<20130613223028.GG13970@mtj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013 15:30:28 -0700 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Thu, Jun 13, 2013 at 03:10:40PM -0700, Andrew Morton wrote:
> > Look, we're falling into the age-old trap of trying to justify existing
> > code just because it exists.
> > 
> > Stop.  Take a step back and pretend that the percpu tag allocator patch
> > never existed.  Now, define the problem and propose solutions.
> > 
> > The absolute dead last and worst solution is "implement something new
> > which largely duplicates existing code".  Such a step requires an
> > extraordinary amount of justification and that hasn't happened.
> 
> I think you're looking at it from the complete opposite point from
> mine.  That problem has always existed and the solutions implemented
> many times over in the whole IO stack across aio, block layer proper,
> SCSI and individual drivers, and most, if not all, suck.  If we can
> consolidate those into a properly designed tag allocator, it's a win,
> whether it's integrated into idr or not.  It's a well-known problem
> with incomplete bad solutions implemented in multiple places.

Well that's news.  My awe at the dreadfulness of Kent's changelog
continues to grow.  Please identify these duplicated allocators
(function names will suffice).  That way, others can actually review
this code :(
