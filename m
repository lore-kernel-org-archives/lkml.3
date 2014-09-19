Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbaISTM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:12:58 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37020 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbaISTM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:12:57 -0400
Message-ID: <541C8047.80705@kernel.dk>
Date: Fri, 19 Sep 2014 13:13:11 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq usage
 count
References: <20140919113815.GA10791@lst.de>
In-Reply-To: <20140919113815.GA10791@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 05:38 AM, Christoph Hellwig wrote:
> Hi Jens, hi Tejun,
> 
> I've seen multi-second boot stalls in one of my KVM setups during
> the initial scsi scan:
> 
> [    0.949892] scsi host0: Virtio SCSI HBA
> [    1.007864] scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    1.1. PQ: 0 ANSI: 5
> [    1.021299] scsi 0:0:1:0: Direct-Access     QEMU     QEMU HARDDISK    1.1. PQ: 0 ANSI: 5
> [    1.520356] tsc: Refined TSC clocksource calibration: 2491.910 MHz
> 
> <stall>
> 
> [   16.186549] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [   16.190478] sd 0:0:1:0: Attached scsi generic sg1 type 0
> [   16.194099] osd: LOADED open-osd 0.2.1
> [   16.203202] sd 0:0:0:0: [sda] 31457280 512-byte logical blocks: (16.1 GB/15.0 GiB)
> [   16.208478] sd 0:0:0:0: [sda] Write Protect is off
> [   16.211439] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   16.218771] sd 0:0:1:0: [sdb] 31457280 512-byte logical blocks: (16.1 GB/15.0 GiB)
> [   16.223264] sd 0:0:1:0: [sdb] Write Protect is off
> [   16.225682] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> 
> 
> I've tracked this down to "blk-mq: use percpu_ref for mq usage count" in
> a rather painful way as that one introduced enough other regressions
> to mess up bisect.
> 
> If I revert the following commits:
> 
> dd840087086f3b93ac20f7472b4fca59aff7b79f
> cddd5d17642cc6881352732693c2ae6930e9ce65
> add703fda981b9719d37f371498b9f129acbd997
> 
> which are the above mentioned commit and two fixes to it the problem goes
> away.

Thanks for bisecting this, I ran into something that I think is the same
issue about a week ago. Tejun, any ideas before I dig into this one?

-- 
Jens Axboe

