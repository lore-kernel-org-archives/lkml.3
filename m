Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaKGNNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:13:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaKGNNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:13:40 -0500
Date: Fri, 7 Nov 2014 14:13:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
In-Reply-To: <20141107125016.GB4071@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1411071405170.29198@pobox.suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com> <1415284748-14648-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411061607250.29198@pobox.suse.cz> <20141106162049.GA14689@cerebellum.variantweb.net> <alpine.LNX.2.00.1411062312220.29198@pobox.suse.cz>
 <20141107125016.GB4071@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014, Josh Poimboeuf wrote:

> > Also, lpc_create_object(), lpc_create_func(), lpc_create_patch(), 
> > lpc_create_objects(), lpc_create_funcs(), ... they all are pretty much 
> > alike, and are asking for some kind of unification ... perhaps iterator 
> > for generic structure initialization?
> 
> The allocation and initialization code is very simple and
> straightforward.  I really don't see a problem there.

This really boils down to the question I had in previous mail, whether 
three-level hierarchy (patch->object->funcs), which is why there is a lot 
of very alike initialization code, is not a bit over-designed.

> > I am not also really fully convinced that we need the 
> > patch->object->funcs abstraction hierarchy (which also contributes to 
> > the structure allocation being rather a spaghetti copy/paste code) ... 
> > wouldn't patch->funcs be suffcient, with the "object" being made just 
> > a property of the function, for example?
> > 
> > > Plus, I show that kernel/kgraft.c + kernel/kgraft_files.c is
> > > 906+193=1099.  I'd say they are about the same size :)
> > 
> > Which is still seem to me to be a ratio worth thinking about improving 
> > :)
> 
> Yes, this code doesn't have a consistency model, but it does have some
> other non-kGraft things like dynamic relocations, 

BTW we need to put those into arch/x86/ as they are unfortunately not 
generic. But more on this later independently.

> deferred module patching,

FWIW kgraft supports that as well.

> and a unified API.  There's really no point in comparing lines of code.

Oh, sure, I didn't mean that this is any kind of metrics that should be 
taken too seriously at all. I was just expressing my surprise that 
unification of the API would bring so much code that it makes the result 
comparably sized to "the whole thing" :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
