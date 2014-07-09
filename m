Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaGIQjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:39:48 -0400
Received: from smtp.infotech.no ([82.134.31.41]:49713 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbaGIQjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:39:47 -0400
Message-ID: <53BD7041.5010300@interlog.com>
Date: Wed, 09 Jul 2014 12:39:29 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: scsi-mq V2
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org>
In-Reply-To: <20140708144829.GA5539@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-07-08 10:48 AM, Christoph Hellwig wrote:
> On Wed, Jun 25, 2014 at 06:51:47PM +0200, Christoph Hellwig wrote:
>> Changes from V1:
>>   - rebased on top of the core-for-3.17 branch, most notable the
>>     scsi logging changes
>>   - fixed handling of cmd_list to prevent crashes for some heavy
>>     workloads
>>   - fixed incorrect handling of !target->can_queue
>>   - avoid scheduling a workqueue on I/O completions when no queues
>>     are congested
>>
>> In addition to the patches in this thread there also is a git available at:
>>
>> 	git://git.infradead.org/users/hch/scsi.git scsi-mq.2
>
>
> I've pushed out a new scsi-mq.3 branch, which has been rebased on the
> latest core-for-3.17 tree + the "RFC: clean up command setup" series
> from June 29th.  Robert Elliot found a problem with not fully zeroed
> out UNMAP CDBs, which is fixed by the saner discard handling in that
> series.
>
> There is a new patch to factor the code from the above series for
> blk-mq use, which I've attached below.  Besides that the only changes
> are minor merge fixups in the main blk-mq usage patch.

Be warned: both Rob Elliott and I can easily break
the scsi-mq.3 branch. It seems as though a regression
has slipped in. I notice that Christoph has added a
new branch called "scsi-mq.3-no-rebase".

For those interested, watch this space.

Doug Gilbert

