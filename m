Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaHSQyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:54:09 -0400
Received: from kanga.kvack.org ([205.233.56.17]:41950 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbaHSQyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:54:07 -0400
Date: Tue, 19 Aug 2014 12:54:04 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Dan Aloni <dan@kernelim.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user space"
Message-ID: <20140819165404.GD13858@kvack.org>
References: <cover.1403632276.git.bcrl@kvack.org> <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org> <20140819163733.GA10132@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819163733.GA10132@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 07:37:33PM +0300, Dan Aloni wrote:
> Some testing I've done today indicates that the original commit broke
> AIO with regard to users that overflow the maximum number of request
> per IO context (where -EAGAIN is returned).
> 
> In fact, it did worse - the attached C program can easily overrun the
> ring buffer that is responsible for managing the completed requests,
> and caused notification about their completion never to be returned.

Argh, that would be a problem.

...
> This reverts commit b34e0e1319b31202eb142dcd9688cf7145a30bf6.

Reverting isn't okay, as that reintroduces another regression.  We need 
to come up with a fix for this issue that doesn't reintroduce the other 
regression for events reaped in user space.  Let me have a look and see 
what I can come up with...

		-ben
-- 
"Thought is the essence of where you are now."
