Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaIVSke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:40:34 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55596 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbaIVSkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:40:33 -0400
Message-ID: <54206D0F.1010506@interlog.com>
Date: Mon, 22 Sep 2014 14:40:15 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Elliott, Robert (Server Storage)" <elliott@hp.com>
Subject: Re: two more fixes for block/for-linus
References: <1411394371-16254-1-git-send-email-hch@lst.de> <54202CF9.7050303@kernel.dk>
In-Reply-To: <54202CF9.7050303@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-09-22 10:06 AM, Jens Axboe wrote:
> On 2014-09-22 07:59, Christoph Hellwig wrote:
>> Fix two regressions with the timer/blk_mq_start_request changes found
>> when using scsi-mq on an ATA device.
>>
>> Note that given how late we are in the cycle I wonder if we really should
>> push the changes in block/for-linus to Linus in this cycle.  The race
>> part of the timer fixes is extremly narrow, and the reserved request
>> part of it requires an out of tree driver update to trigger it, so it
>> doesn't sound super criticial.
>
> I was planning on pushing it out today, I've run a lot of testing on it
> internally last week. Ho hum, let me think about it...

With these patches applied (actually a resync an hour
ago with the for-linus tree which includes them), the
freeze-during-boot-up problem that I have been seeing
with an old SATA boot disk (perhaps 1.5 Gbps) for
the last two weeks, has gone away.

That SATA disk is connected to the motherboard (Gigabyte
Z97M-D3H/Z97M-D3H, BIOS F5 05/30/2014) and has a standard
AHCI interface as far as I can tell. dmesg confirms that.


Please add "Tested-by: Douglas Gilbert <dgilbert@interlog.com>"
to Christoph's "two more fixes for block/for-linus" series.

Doug Gilbert



