Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbaCNJw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:52:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbaCNJw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:52:56 -0400
Message-ID: <5322D177.8050408@suse.de>
Date: Fri, 14 Mar 2014 10:52:55 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de> <20140312102849.GA26509@infradead.org> <20140313161347.GA6598@redhat.com> <20140314092519.GA10139@infradead.org> <20140314093458.GA19451@infradead.org>
In-Reply-To: <20140314093458.GA19451@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 10:34 AM, Christoph Hellwig wrote:
> On Fri, Mar 14, 2014 at 02:25:19AM -0700, Christoph Hellwig wrote:
>> b) is a bit harder, but we should think hard about it when rewriting the
>> multipath code to support blk-mq.  Talking about which I think trying to
>> use dm-multipath on any blk-mq device will go horribly crash and boom at
>> the moment.
> 
> Talking abnout crashing and burning.. Hannes, did you run this patch
> past dm-devel and linux-scsi yet?  Don't quite like it but the problem
> seems real..
> 
No, I haven't. This issue is only exhibited if you try to run
multipath on a non-SCSI device (in this case it was cciss).
But then that project got abandoned, and there never was a machine
with a multipathed cciss controller.

Same issue with DASD; you _could_ potentially run multipath on DASD,
but all recent mainframes have a feature called 'hyperpav', which
essentially implements multipath support within the DASD driver. So
running multipath here won't buy you anything.
(Plus the DASD driver will only _ever_ return an I/O error
after is has had a response from the storage array.
Making it truly pointless to run multipathing ...)
The only valid use case would be xDR. But then RH apparently has
support for xDR even without that patch (otherwise they would have
asked for it, being the good upstream citizen as they claim to be,
right?) so it looks as if it's not needed there, neither.

So this patch hasn't had any application in the real world and
I haven't pursued with it upstream.

But if Mike feels it'll be a good idea nevertheless I can easily
send an updated version.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
