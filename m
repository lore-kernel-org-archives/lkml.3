Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3FMWag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:30:36 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:64929 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3FMWaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:30:35 -0400
Date: Thu, 13 Jun 2013 15:30:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613223028.GG13970@mtj.dyndns.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613151040.8e11da022519fff7d5e8ea77@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Jun 13, 2013 at 03:10:40PM -0700, Andrew Morton wrote:
> Look, we're falling into the age-old trap of trying to justify existing
> code just because it exists.
> 
> Stop.  Take a step back and pretend that the percpu tag allocator patch
> never existed.  Now, define the problem and propose solutions.
> 
> The absolute dead last and worst solution is "implement something new
> which largely duplicates existing code".  Such a step requires an
> extraordinary amount of justification and that hasn't happened.

I think you're looking at it from the complete opposite point from
mine.  That problem has always existed and the solutions implemented
many times over in the whole IO stack across aio, block layer proper,
SCSI and individual drivers, and most, if not all, suck.  If we can
consolidate those into a properly designed tag allocator, it's a win,
whether it's integrated into idr or not.  It's a well-known problem
with incomplete bad solutions implemented in multiple places.

Again, I'm not saying integrating this into idr is a bad idea.  If
that's reasonably doable, awesomer, but I think even just
consolidating the existing bad ones into a common one is beneficial
enough.

Thanks.

-- 
tejun
