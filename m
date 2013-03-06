Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3CFMnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 07:43:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4934 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3CFMnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 07:43:08 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=iYCWPOAv_q0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=FMSsiTdz_JcA:10 a=P8XRzqGBjsym-llFQ4YA:9 a=PUjeQqilurYA:10 a=SLBasNWEgStexTbL:21 a=J8efZh0Sj0sYROzq:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362573785.31874.36.camel@gandalf.local.home>
Subject: Re: snapshot error on non allocated buffer?
From: Steven Rostedt <rostedt@goodmis.org>
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 06 Mar 2013 07:43:05 -0500
In-Reply-To: <51372E5A.2070504@hitachi.com>
References: <1362498608.31874.28.camel@gandalf.local.home>
	 <51372E5A.2070504@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 20:54 +0900, Hiraku Toyooka wrote:
> Hi Steven,
> 
> (03/06/2013 12:50 AM), Steven Rostedt wrote:
> > Hi Hiraku,
> >
> > I'm doing a lot of reconstruction of ftrace's buffering, and I'm also
> > modifying a lot of the snapshot feature to work with the new stuff
> > that's coming.
> >
> 
> Many thanks. I'm trying your multi-buffer patches.

And I have many more to come :-)

> 
> > I'm looking at the -EINVAL when you write something other than '0' or
> > '1' into the snapshot file when the snapshot is not allocated. I'm
> > thinking that it should just return as if it succeeded. I don't
> > understand why it should return -EINVAL?
> >
> 
> I thought that it might be a little strange if the clear operation
> succeeded in spite of the non-allocated buffer.
> (Actually, I simply implemented as you said, though.)

Yeah, I may have been the one to bring it up, but I was wrong. After
playing with it, it doesn't make sense.

> 
> But I don't have trouble even if it succeeds, so I'll modify the I/F
> to make it return successfully.
> 
> > Now if you want to know if the snapshot is allocated or not, I have a
> > patch that shows how to use the snapshot feature when the snapshot is
> > empty, and also give the status of the snapshot itself:
> >
> > [root] # cat /debug/tracing/snapshot
> > # tracer: nop
> > #
> > #
> > # * Snapshot is freed *
> > #
> > # Snapshot commands:
> > # echo 0 > snapshot : Clears and frees snapshot buffer
> > # echo 1 > snapshot : Allocates snapshot buffer, if not already
> > allocated.
> > #                      Takes a snapshot of the main buffer.
> > # echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
> > #                      (Doesn't have to be '2' works with any number
> > that
> > #                       is not a '0' or '1')
> >
> > [root] # echo 1 > /debug/tracing/snapshot
> > [root] # echo 2 > /debug/tracing/snapshot
> > [root] # cat /debug/tracing/snapshot
> > # tracer: nop
> > #
> > #
> > # * Snapshot is allocated *
> > #
> > # Snapshot commands:
> > # echo 0 > snapshot : Clears and frees snapshot buffer
> > # echo 1 > snapshot : Allocates snapshot buffer, if not already
> > allocated.
> > #                      Takes a snapshot of the main buffer.
> > # echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
> > #                      (Doesn't have to be '2' works with any number
> > that
> > #                       is not a '0' or '1')
> >
> 
> This seems good for me and also users.
> 
> >
> > As this is a new feature for 3.9, and we are still in -rc1, I think this
> > might be a good thing to add now. As well as not returning -EINVAL on
> > writing to the file when the snapshot buffer isn't allocated.
> >
> > What do you think?
> >
> 
> I think it's OK.
> I'll send a patch to make the file not return -EINVAL. Does it need to
> be based on 3.9-rc1 or tip tree?

I already have a patch. I'll send it out later today, and perhaps you
can give me your "Acked-by".

Thanks,

-- Steve


