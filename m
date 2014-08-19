Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaHSROf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:14:35 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36385 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaHSROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:14:33 -0400
Date: Tue, 19 Aug 2014 20:14:26 +0300
From: Dan Aloni <dan@kernelim.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user
 space"
Message-ID: <20140819171426.GA11811@gmail.com>
References: <cover.1403632276.git.bcrl@kvack.org>
 <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
 <20140819163733.GA10132@gmail.com>
 <20140819165404.GD13858@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819165404.GD13858@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 12:54:04PM -0400, Benjamin LaHaise wrote:
> On Tue, Aug 19, 2014 at 07:37:33PM +0300, Dan Aloni wrote:
> > Some testing I've done today indicates that the original commit broke
> > AIO with regard to users that overflow the maximum number of request
> > per IO context (where -EAGAIN is returned).
> > 
> > In fact, it did worse - the attached C program can easily overrun the
> > ring buffer that is responsible for managing the completed requests,
> > and caused notification about their completion never to be returned.
> 
> Argh, that would be a problem.
> 
> ...
> > This reverts commit b34e0e1319b31202eb142dcd9688cf7145a30bf6.
> 
> Reverting isn't okay, as that reintroduces another regression.  We need 
> to come up with a fix for this issue that doesn't reintroduce the other 
> regression for events reaped in user space.  Let me have a look and see 
> what I can come up with...

About the original regression you mention, is there a program you can
indicate that reproduces it? On my setups, the regression testing in 
libaio was not able to detect the current regression too.


-- 
Dan Aloni
