Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbaAHHOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:14:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaAHHOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:14:37 -0500
Message-ID: <52CCFADB.6080909@suse.de>
Date: Wed, 08 Jan 2014 08:14:35 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "Darrick J. Wong" <darrick.wong@oracle.com>, chuck.lever@oracle.com,
        Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: status of block-integrity
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de>	<yq1wqigzvc1.fsf@sermon.lab.mkp.net>	<20140107013646.GB10297@birch.djwong.org> <52CBAA1B.7000509@suse.de> <yq1a9f7wjqr.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1a9f7wjqr.fsf@sermon.lab.mkp.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 10:43 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
> 
> Hannes> Plus (as hch rightly pointed out) as there is no defined
> Hannes> userland interface the question is why we bother with all the
> Hannes> DIX stuff in the block layer.  
> 
> Because it catches problems in the path between block layer and HBA
> ASIC? FWIW, we find more issues there than we do between initiator and
> target.
> 
But how should it do that exactly?
As there is no user (apart from oracleasm) no-one can attach
protection information to any data, so even the most dedicated admin
cannot exercise this path, let alone find issues here.

> API issues aside, another reason adoption has been slow is that very few
> applications truly care about this stuff. The current approach in which
> data is protected when the I/O is submitted by the filesystem is good
> enough for most things. Saves the filesystem people the trouble of
> dealing with it too.
> 
> In reality there are only a handful of applications that would actually
> benefit from an explicit userland API. Mostly in the database
> department. All the potential consumers of an interface I talked to
> wanted to use aio so that's why we've focused our efforts there.
> 
aio is perfectly fine; all I care is to have _any_ way of feeding
protection information into the kernel.

> Both Darrick and I have been busy with other projects the last little
> while. I'll start looking at this again when I'm done with copy
> offload...
> 
Speaking of which, are there any patches?
Doug Gilbert and I are currently discussing LID4 / ROD Token copy
for sg3_utils and the block layer, so any patches would be very
helpful here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
