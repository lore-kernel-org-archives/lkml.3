Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3AaVSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:18:25 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:37252 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3AaVSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:18:23 -0500
Date: Thu, 31 Jan 2013 22:18:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] rwsem-spinlock: let rwsem write lock stealable
Message-ID: <20130131211818.GA13195@gmail.com>
References: <1359537244-20588-1-git-send-email-yuanhan.liu@linux.intel.com>
 <CANN689GwGh2sHwoP66JjoXs2ZMQAXbVpA0MHQahWq5M+baNfSQ@mail.gmail.com>
 <20130131124004.GA12678@yliu-dev.sh.intel.com>
 <20130131131228.GB6627@gmail.com>
 <20130131143626.GB12678@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20130131143626.GB12678@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> On Thu, Jan 31, 2013 at 02:12:28PM +0100, Ingo Molnar wrote:
> > 
> > * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > 
> > > BTW, mind to tell a nice test case for mmap_sem?
> > 
> > this one was write-hitting on mmap_sem pretty hard, last I 
> > checked:
> > 
> >   http://people.redhat.com/mingo/threaded-mmap-stresstest/
> 
> Thanks!
> 
> Is there any pass condition? I tested a while, at least I 
> found no oops or any noisy from dmesg output. Is that OK?

Yeah, not crashing and not hanging is the expected behavior.

> Well, sometimes, it will quit peacefully. Sometimes it will 
> not. ps -eo 'pid, state,wchan,comm' shows that it is sleeping 
> at futex_wait_queue_me().
> 
> NOTE: this happens both with or w/o this patch. Thus it may 
> not an issue introduced by this patch?

hm, that's unexpected - it's expected to loop infinitely. I have 
a newer version (attached) - is that exiting too?

Maybe this triggers spuriously:

        if (!info->si_addr)
                raise(SIGABRT); /* Allow GDB backtrace */

although then you should see the SIGABRT as an irregular exit 
IIRC.

Thanks,

	Ingo

--UlVJffcvxoiEqYs2
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="threaded-mmap-stresstest.tar.gz"
Content-Transfer-Encoding: base64

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
Xw/9D9m3ldsAUAAA

--UlVJffcvxoiEqYs2--
