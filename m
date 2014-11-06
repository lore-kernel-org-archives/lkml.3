Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaKFSZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:25:02 -0500
Received: from jablonecka.jablonka.cz ([91.219.244.36]:50031 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaKFSZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:25:00 -0500
X-Greylist: delayed 1486 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2014 13:24:59 EST
Date: Thu, 6 Nov 2014 19:00:10 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141106180010.GA25761@suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411061607250.29198@pobox.suse.cz>
 <20141106162049.GA14689@cerebellum.variantweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106162049.GA14689@cerebellum.variantweb.net>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:20:49AM -0600, Seth Jennings wrote:

> Yes, I should explain it.
> 
> This is something that is currently only used in the kpatch approach.
> It allows the patching core to do dynamic relocations on the new
> function code, similar to what the kernel module linker does, but this
> works for non-exported symbols as well.
> 
> This is so the patch module doesn't have to do a kallsyms lookup on
> every non-exported symbol that the new functions use.
> 
> The fields of the dynrela structure are those of a normal ELF rela
> entry, except for the "external" field, which conveys information about
> where the core module should go looking for the symbol referenced in the
> dynrela entry.
> 
> Josh was under the impression that Vojtech was ok with putting the
> dynrela stuff in the core.  Is that not correct (misunderstanding)?

Yes, that is correct, as obviously the kpatch way of generating patches
by extracting code from a compiled kernel would not be viable without
it.

For our own kGraft usage we're choosing to compile patches from C
source, and there we can simply replace the function calls by calls via
pointer looked up through kallsyms.

However, kGraft also has tools to create patches in an automated way,
where the individual functions are extracted from the compiled patched
kernel using a modified objopy and this is hitting exactly the same
issue of having to do relocation of unexported symbols if any are
referenced.

So no objection to the idea. We'll have to look more into the code to
comment on the implementation of the dynrela stuff.

-- 
Vojtech Pavlik
Director SUSE Labs
