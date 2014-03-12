Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaCLLHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:07:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbaCLLHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:07:45 -0400
Message-ID: <53203FF3.8060105@suse.de>
Date: Wed, 12 Mar 2014 12:07:31 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mike Snitzer <snitzer@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        msnitzer <msnitzer@redhat.com>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de> <20140312102849.GA26509@infradead.org> <53203BE5.402@suse.de> <20140312105527.GA21511@infradead.org>
In-Reply-To: <20140312105527.GA21511@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 11:55 AM, Christoph Hellwig wrote:
> On Wed, Mar 12, 2014 at 11:50:13AM +0100, Hannes Reinecke wrote:
>> >From the device-mapper side we have these patches which are not
>> included upstream:
> 
> Another one on the dm side that seems useful is:
> 
> dm-emulate-blkrrpart-ioctl:
>   Partitions on device-mapper devices are managed by kpartx (if at
>   all). So if we were just to send out a 'change' event if someone
>   called BLKRRPART on these devices, kpartx will be triggered via udev
>   and can manage the partitions accordingly.
> 
Which I've omitted for a reason; looks like these kind of things it
handled in userspace nowadays.
It will also cause 'parted' to emit 'change' events when you just
display a device. Which is _not_ want we want.
So this patch will be pulled, even from SUSE.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
