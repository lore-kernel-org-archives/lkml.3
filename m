Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaCNJa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:30:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601AbaCNJay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:54 -0400
Message-ID: <5322CC4D.8040509@suse.de>
Date: Fri, 14 Mar 2014 10:30:53 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de> <20140312102849.GA26509@infradead.org> <20140313161347.GA6598@redhat.com> <20140314092519.GA10139@infradead.org>
In-Reply-To: <20140314092519.GA10139@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 10:25 AM, Christoph Hellwig wrote:
> On Thu, Mar 13, 2014 at 12:13:47PM -0400, Mike Snitzer wrote:
>> Pretty ironic that in the same email that you ask someone to "Let's make
>> this a little less personal." you start by asserting upstream
>> dm-multipath sees very little testing -- and use your commit that
>> recently broke dm-multipath as the basis.  Anyway, please exapnd on what
>> you feel is broken with upstream dm-multipath.
> 
> Getting a little upset, eh?  I didn't say it's broken, I said it gets
> very little testing.  The regression from me was found like so many
> before only after it was backported o some enterprise kernel.
> 
> I think the problem here is two-fold:
>  a) the hardware you use with dm-multipath isn't widely available.
>  b) it uses a very special code path in the block layer no one else uses
> 
> a) might be fixable by having some RDAC or similar emulation in qemu if
> someone wants to spend the effort.
> b) is a bit harder, but we should think hard about it when rewriting the
> multipath code to support blk-mq.  Talking about which I think trying to
> use dm-multipath on any blk-mq device will go horribly crash and boom at
> the moment.
> 
That was actually one of my plans, move dm-multipath over to use
blk-mq. But then I'd need to discuss with Jens et al how to best
achieve this; the current static hctx allocation doesn't play well
with multipaths dynamic path management.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
