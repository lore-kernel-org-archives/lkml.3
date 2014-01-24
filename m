Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaAXIxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:53:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56181 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaAXIxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:53:07 -0500
Date: Fri, 24 Jan 2014 09:52:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, oleg@redhat.com
Subject: Re: [PATCH 0/7][RFC] pid: changes to support audit
Message-ID: <20140124085248.GY30183@twins.programming.kicks-ass.net>
References: <20131220140417.GE14884@madcap2.tricolour.ca>
 <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
 <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
 <20131217095801.GF21999@twins.programming.kicks-ass.net>
 <20131220044826.GF14944@madcap2.tricolour.ca>
 <20131220085846.GA21999@twins.programming.kicks-ass.net>
 <cover.1390495874.git.rgb@redhat.com>
 <20140123212535.GX11314@laptop.programming.kicks-ass.net>
 <20140124061447.GH7084@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124061447.GH7084@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 01:14:47AM -0500, Richard Guy Briggs wrote:
> On 14/01/23, Peter Zijlstra wrote:
> > On Thu, Jan 23, 2014 at 02:32:33PM -0500, Richard Guy Briggs wrote:
> > > These are a number of patches inspired by ebiederman's container work that were
> > > included by me 2013-08-20 as the patchset:
> > > 	RFC: steps to make audit pid namespace-safe
> > > 
> > > They have been seperated out for the pid maintainer since there are no direct
> > > dependencies from the audit pid namespace patchset with the exception of:
> > > 	pid: get pid_t ppid of task in init_pid_ns
> > > 
> > > Andrew, are you willing to adopt these?
> > > 
> > > In particular, there is discussion around read-only task_struct::pid here:
> > > 	https://lkml.org/lkml/2013/12/16/552
> > 
> > I would have ordered them slightly different, but:
> 
> Can you briefly explain how and why so I can understand for next time?
> I originally had the ppid patch first...

Ah, I would have introduced CONST_CAST() earlier, then used it in the
make pid const and then avoided the conversion patch.
