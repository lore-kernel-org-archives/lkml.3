Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaHVQPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:15:10 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56455 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaHVQPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:15:07 -0400
Date: Fri, 22 Aug 2014 19:15:02 +0300
From: Dan Aloni <dan@kernelim.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user
 space"
Message-ID: <20140822161502.GA30392@gmail.com>
References: <cover.1403632276.git.bcrl@kvack.org>
 <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
 <20140819163733.GA10132@gmail.com>
 <20140819165404.GD13858@kvack.org>
 <20140819171426.GA11811@gmail.com>
 <20140820004651.GJ13858@kvack.org>
 <20140822160111.GD20391@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822160111.GD20391@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 12:01:11PM -0400, Benjamin LaHaise wrote:
> On Tue, Aug 19, 2014 at 08:46:51PM -0400, Benjamin LaHaise wrote:
> > You can trigger the behaviour with fio by using userspace event reaping.  
> > Adding a test case for that behaviour to libaio would be a good idea.
> 
> > I thought about how to fix this, and it isn't actually that hard.  Move 
> > the put_reqs_available() call back into event consumption, and then add 
> > code in the submit path to call put_reqs_available() if the system runs 
> > out of events by noticing that there is free space in the event ring.  
> > Something along the lines below should do it (please note, this is 
> > completely untested!).  I'll test and polish this off tomorrow, as it's 
> > getting a bit late here.
> 
> Dan, does this patch work for you?  It seems to pass your test program 
> when I run it in a vm...

Sorry, I was waiting for a new patch from your direction, I should
have replied earlier. What bothered me about the patch you sent is that
completed_events is added as a new field but nothing assigns to it, so I 
wonder how it can be effective.

-- 
Dan Aloni
