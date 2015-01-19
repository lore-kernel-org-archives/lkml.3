Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbbASOyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:54:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbbASOyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:54:35 -0500
Date: Mon, 19 Jan 2015 08:54:31 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: support for repatching a function
Message-ID: <20150119145431.GC1737@treble.redhat.com>
References: <b211111ad4f29886a44871dddc313a542c48960b.1420834026.git.jpoimboe@redhat.com>
 <alpine.LNX.2.10.1501161743220.1074@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.10.1501161743220.1074@wotan.suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 05:51:11PM +0100, Jiri Kosina wrote:
> One thing that makes me worried here is we basically apply patches in a 
> 'stackable' manner, but then this allows them to be removed (disabled) in 
> an arbitrary order. Is this really the semantics we want?
> 
> The scenario I am concerned about, in a nutshell:
> 
> foo_unpatched()
> 	foo_patch1()
> 		foo_patch2()
> 			foo_patch3()
> 		disable(foo_patch2)
> 		disable(foo_patch3)
> 	foo_patch1()
> 
> I.e. basically due to reverting of foo_patch2() while it wasn't in use, we 
> turn subsequent revert of foo_patch3() into foo_patch1() state, although 
> the function foo_patch3() was originally patching was foo_patch2().
> 
> If this is implemented really in a fully stackable manner (i.e. you 
> basically would be able to disable only the function that is currently 
> "active", i.e. on top of the stack), woudln't that provide more 
> predictable semantics?

Yes, I agree.  Thanks for the comment.

Would you want to enforce stacking even if there are no dependencies
between the patches?  I think that would be easiest (and cleanest).

-- 
Josh
