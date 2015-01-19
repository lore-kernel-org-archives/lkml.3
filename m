Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbbASTsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:48:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbbASTso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:48:44 -0500
Date: Mon, 19 Jan 2015 20:48:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: support for repatching a function
In-Reply-To: <20150119145431.GC1737@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1501192046130.10817@pobox.suse.cz>
References: <b211111ad4f29886a44871dddc313a542c48960b.1420834026.git.jpoimboe@redhat.com> <alpine.LNX.2.10.1501161743220.1074@wotan.suse.de> <20150119145431.GC1737@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Josh Poimboeuf wrote:

> > If this is implemented really in a fully stackable manner (i.e. you 
> > basically would be able to disable only the function that is currently 
> > "active", i.e. on top of the stack), woudln't that provide more 
> > predictable semantics?
> 
> Yes, I agree.  Thanks for the comment.
> 
> Would you want to enforce stacking even if there are no dependencies
> between the patches?  I think that would be easiest (and cleanest).

Yup, I think that makes the most sense (especially in this "first step"). 
Relaxing the revert rules to cover only patches which are really dependent 
on each other (and we'd have to be careful about defining the meaning 
this, especially with repsect to various consistency models coming in the 
future) is something tha can always be done later on top.

Thanks,

-- 
Jiri Kosina
SUSE Labs
