Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407Ab3ICScc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:32:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760215Ab3ICScb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:32:31 -0400
Date: Tue, 3 Sep 2013 14:31:59 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: John Johansen <john.johansen@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 03/12] pid: get ppid pid_t of task in init_pid_ns safely
Message-ID: <20130903183159.GA28517@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com>
 <20130827172155.GC29147@redhat.com>
 <20130830195646.GJ21110@madcap2.tricolour.ca>
 <52210275.8040601@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52210275.8040601@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 01:37:09PM -0700, John Johansen wrote:
> On 08/30/2013 12:56 PM, Richard Guy Briggs wrote:
> > On Tue, Aug 27, 2013 at 07:21:55PM +0200, Oleg Nesterov wrote:
> >> On 08/20, Richard Guy Briggs wrote:
> > Most of the instances are current, but the one called from apparmour is
> > stored.  I've just learned that this is bad and someone else just chimed
> > in that they have a patch to remove it...
> 
> the apparmor case isn't actually stored long term. The stored task will be
> a parameter that was passed into an lsm hook and the buffer that it is
> stored in dies before the hook is done. Its temporarily stored in the
> struct so that it can be passed into the lsm_audit fn, and printed into an
> allocated audit buffer. The text version in the audit buffer is what will
> exist beyond the hook.
> 
> There are three patches, I'll reply them below once I have finished rebasing
> them to apply to the current tree instead of my dev tree.

John, thanks for this context and fix.  That helps simplify things.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
