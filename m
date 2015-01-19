Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbbASUCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:02:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbbASUCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:02:44 -0500
Date: Mon, 19 Jan 2015 14:02:39 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: support for repatching a function
Message-ID: <20150119200239.GA15916@treble.redhat.com>
References: <b211111ad4f29886a44871dddc313a542c48960b.1420834026.git.jpoimboe@redhat.com>
 <alpine.LNX.2.10.1501161743220.1074@wotan.suse.de>
 <20150119145431.GC1737@treble.redhat.com>
 <alpine.LNX.2.00.1501192046130.10817@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501192046130.10817@pobox.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 08:48:42PM +0100, Jiri Kosina wrote:
> On Mon, 19 Jan 2015, Josh Poimboeuf wrote:
> 
> > > If this is implemented really in a fully stackable manner (i.e. you 
> > > basically would be able to disable only the function that is currently 
> > > "active", i.e. on top of the stack), woudln't that provide more 
> > > predictable semantics?
> > 
> > Yes, I agree.  Thanks for the comment.
> > 
> > Would you want to enforce stacking even if there are no dependencies
> > between the patches?  I think that would be easiest (and cleanest).
> 
> Yup, I think that makes the most sense (especially in this "first step"). 
> Relaxing the revert rules to cover only patches which are really dependent 
> on each other (and we'd have to be careful about defining the meaning 
> this, especially with repsect to various consistency models coming in the 
> future) is something tha can always be done later on top.

Sounds good.  I'll do a v2.

FYI, I've also been working on a prototype of a consistency model, based
on my discussions with Vojtech on the list a few months ago
(LEAVE_PATCHED_SET + SWITCH_THREAD).  I'll probably have some patches to
send out for comments in a few weeks.  That should hopefully be a good
starting point for more discussion about the consistency model(s).

-- 
Josh
