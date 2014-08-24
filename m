Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaHXSLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 14:11:43 -0400
Received: from kanga.kvack.org ([205.233.56.17]:39949 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbaHXSLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 14:11:41 -0400
Date: Sun, 24 Aug 2014 14:11:40 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Aloni <dan@kernelim.com>, "security@kernel.org" <security@kernel.org>,
        linux-aio@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user space"
Message-ID: <20140824181140.GD4376@kvack.org>
References: <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org> <20140819163733.GA10132@gmail.com> <20140819165404.GD13858@kvack.org> <20140819171426.GA11811@gmail.com> <20140820004651.GJ13858@kvack.org> <20140822160111.GD20391@kvack.org> <20140822161502.GA30392@gmail.com> <20140822162630.GF20391@kvack.org> <20140822185110.GA2333@gmail.com> <CA+55aFzZbRkEh_MbB-XmurVP-4seMP3z9tbq+YQOhkjtDNTzfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzZbRkEh_MbB-XmurVP-4seMP3z9tbq+YQOhkjtDNTzfg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 02:43:56PM -0700, Linus Torvalds wrote:
> Ugh.
> 
> Ben, at this point my gut feel is that we should just revert the
> original "fix", and you should take a much deeper look at this all.
> The original "fix" was more broken then the leak it purported to fix,
> and now the patch to fix your fix has gone through two iterations and
> *still* Dan is finding bugs in it.  I'm getting the feeling that this
> code needs more thinking than you are actually putting into it.

That's why I had't sent it out as an official [PATCH] just yet.  I think 
things worked out okay since the untested patch I sent out pointed Dan in 
the right direction and he was able to put some effort into it while I 
didn't have to immediate time to do so.  I just put in a few hours to 
polish off the final details on this fix now, and it should be coming your 
way as soon as I get an ack back from Dan.  Hopefully Kent can review it 
as well, since I had to modify the approach to try to retain the advantages 
of his batched reqs_available handling and avoid bouncing the cacheline 
ctx->completion_lock is on during io_submit().  Cheers,

		-ben

>                 Linus

-- 
"Thought is the essence of where you are now."
