Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaCLKuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:50:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbaCLKuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:50:14 -0400
Message-ID: <53203BE5.402@suse.de>
Date: Wed, 12 Mar 2014 11:50:13 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mike Snitzer <snitzer@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        msnitzer <msnitzer@redhat.com>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de> <20140312102849.GA26509@infradead.org>
In-Reply-To: <20140312102849.GA26509@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 11:28 AM, Christoph Hellwig wrote:
> On Sat, Mar 08, 2014 at 08:51:18PM +0100, Hannes Reinecke wrote:
>> Hey, calm down.
>> I've made the fix just two days ago. And was quite surprised that
>> I've been the first hitting that; should've crashed for everybody
>> using dm-multipath.
>> And given the pushback I've gotten recently from patches I would
>> have thought that it would work for most users; sure the author
>> would've done due diligence on the original patchset ...
> 
> There's very little testing of dm-multipath for upstream work, as I've
> seen tons of avoidable breakage.  Doesn't help that it uses a special
> code path that one else uses.
> 
>> BTW, it not _my_ decision to sit on tons of SUSE specific patches.
>> I really try to get things upstream. But I cannot do more than
>> sending patches upstream, answer patiently any questions, and redo
>> the patchset.
>> Which I did. Frequently, But, alas, it's up to the maintainer to
>> apply them. And I can only ask and hope. The usual story...
> 
> Let's make this a little less personal.  Fact is that the SuSE trees
> have tons of patches in there that never have even been sent upstream.
> There's also tons that have been posted once or twice.  While I feel
> your frustration with the SCSI process fully and we'll need to work on
> that somehow, how about you do another round of dumping the DM patches
> on the dm-devel list and Mike?
> 
> I'll ping some of the other worst offenders as time permits.
> 

Ok, down to the grubby details:

>From the device-mapper side we have these patches which are not
included upstream:

dm-mpath-accept-failed-paths:
  -> has been posted to dm-devel, and Mike Snitzer promised
     to review/check it.

dm-multipath-Improve-logging.patch
-> Already sent as part of the 'noqueue' patchset

dm-mpath-no-activate-for-offlined-paths
-> bugfix to 'dm-mpath-accept-failed-paths'

dm-table-switch-to-readonly:
-> Catch 'EROFS' errors during table creation and set
   the 'read-only' flag on the device-mapper device
   accordingly. Should be sent upstream, correct.

dm-mpath-no-partitions-feature
-> This adds a new feature 'no_partitions' to dm-multipath
   devices, which then cause 'kpartx' to _not_ create
   partitions on that device. That is required for
   virtual images, which you just want to pass to
   the guest as-is.
   Patch has been discussed at dm-devel, but got
   rejected/ignored on the grounds that there should be
   a different way of doing so. I'll happily restart
   discussion here ...

dm-initialize-flush_rq.patch:
-> Has been discussed already, will be refreshed with
   the patch from Mike.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
