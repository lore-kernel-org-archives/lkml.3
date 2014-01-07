Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbaAGI2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:28:52 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49252 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaAGI2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:28:51 -0500
Message-ID: <52CBBABD.50902@gmail.com>
Date: Tue, 07 Jan 2014 16:28:45 +0800
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <mkp@mkp.net>, Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: status of block-integrity
References: <20131222192128.GA28532@infradead.org> <yq11u134rmt.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq11u134rmt.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 09:35 PM, Martin K. Petersen wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> Christoph> We have the block integrity code to support DIF/DIX in the
> Christoph> the tree for about 5 and a half years, and we still don't
> Christoph> have a single consumer of it.
>
> What do you mean? If you have a DIX-capable HBA (lpfc, qla2xxx, zfcp)
> then integrity protection is active from the block layer down. The only
> code that's not currently being exercised are the tag interleaving
> functions.  I was hoping the FS people would use them for back pointers
> but nobody seemed to bite.
>
>
> Christoph> Given that we'll have a lot of work to do in this area with
> Christoph> block multiqueue I think it's time to either kill it off for
> Christoph> good or make sure we can actually use and test it.
>
> I don't understand why multiqueue would require a lot of work? It's just
> an extra scatterlist per request.
>
> And obviously, if there's anything that needs to be done in this area
> I'll be happy to do so...
>

One of the major knocks on linux file systems (except for btrfs) that I hear is 
the lack of full data path checksums. DIF/DIX + xfs or ext4 done right will give 
us another answer here.  I don't think it will be common, it is a request that 
comes in for very large storage customers most commonly.

We do have devices that support this and are working to get more vendor testing 
done, so I would hate to see us throw out the code instead of fixing it up for 
the end users that see value here.

I think that we can get this working & agree with the call to continue this 
discussion (here and at LSF :))

Ric

