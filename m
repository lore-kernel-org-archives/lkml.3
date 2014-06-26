Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbaFZC3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:29:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46838 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757207AbaFZC26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:28:58 -0400
X-Sasl-enc: mlrUuzZ1+UFG0jFfomHTmurAl6AeJFAFLUt8xgwyaDLb 1403749737
Message-ID: <1403749735.2969.25.camel@perseus.fritz.box>
Subject: Re: [PATCH] autofs4 - fix false positive compile error
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jun 2014 10:28:55 +0800
In-Reply-To: <20140625130648.1e3cd0e578602918dc38bb6a@linux-foundation.org>
References: <20140625124939.31035.84884.stgit@perseus.fritz.box>
	 <20140625130648.1e3cd0e578602918dc38bb6a@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 13:06 -0700, Andrew Morton wrote:
> On Wed, 25 Jun 2014 20:49:39 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > On strict build environments we can see:
> > 
> > fs/autofs4/inode.c: In function 'autofs4_fill_super':
> > fs/autofs4/inode.c:312: error: 'pgrp' may be used uninitialized in this
> > function
> > make[2]: *** [fs/autofs4/inode.o] Error 1
> > make[1]: *** [fs/autofs4] Error 2
> > make: *** [fs] Error 2
> > make: *** Waiting for unfinished jobs....
> > 
> > This is due to the use of pgrp_set being used to indicate pgrp has
> > has been set rather than initializing pgrp itself.
> > 
> 
> Yes, that code seems to be explicitly designed to trigger a gcc warning ;)
> 
> What is a "strict build environment"?  Someone's using -Werror for the
> entire kernel?  That must make for a miserable life.

Yes, TBH I was a bit surprised myself.
It resulted from a RHEL-6.6 patch submission.

I didn't notice it and ended up missing an internal (RedHat) patch
submission deadline as my original interest in these was the result of
an upstream discussion and I stupidly relied on my upstream testing.

It might just be that our internal up and coming file system tree is
specifically more fussy but never the less I got caught out.

Ian

