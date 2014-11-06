Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaKFWUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:20:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaKFWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:20:52 -0500
Date: Thu, 6 Nov 2014 23:20:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
In-Reply-To: <20141106162049.GA14689@cerebellum.variantweb.net>
Message-ID: <alpine.LNX.2.00.1411062312220.29198@pobox.suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com> <1415284748-14648-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411061607250.29198@pobox.suse.cz> <20141106162049.GA14689@cerebellum.variantweb.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Seth Jennings wrote:

> > Thanks a lot for having started the work on this!
> > 
> > We will be reviewing it carefully in the coming days and will getting back 
> > to you (I was surprised to see that that diffstat indicates that it's 
> > actually more code than our whole kgraft implementation including the 
> > consistency model :) ).
> 
> The structure allocation and sysfs stuff is a lot of (mundane) code.
> Lots of boring error path handling too.

Also, lpc_create_object(), lpc_create_func(), lpc_create_patch(), 
lpc_create_objects(), lpc_create_funcs(), ... they all are pretty much 
alike, and are asking for some kind of unification ... perhaps iterator 
for generic structure initialization?

I am not also really fully convinced that we need the patch->object->funcs 
abstraction hierarchy (which also contributes to the structure allocation 
being rather a spaghetti copy/paste code) ... wouldn't patch->funcs be 
suffcient, with the "object" being made just a property of the function, 
for example?

> Plus, I show that kernel/kgraft.c + kernel/kgraft_files.c is
> 906+193=1099.  I'd say they are about the same size :)

Which is still seem to me to be a ratio worth thinking about improving :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
