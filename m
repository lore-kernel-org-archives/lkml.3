Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaHGS54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 14:57:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:46048 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaHGS5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 14:57:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,819,1400050800"; 
   d="scan'208";a="584928677"
Message-ID: <1407437630.2869.7.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH 3/4] brd: Fix all partitions BUGs
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Thu, 07 Aug 2014 12:53:50 -0600
In-Reply-To: <53E2127B.1020805@plexistor.com>
References: <53E21125.9080308@plexistor.com>
	 <53E2127B.1020805@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 14:33 +0300, Boaz Harrosh wrote:
> This patch fixes up brd's partitions scheme, now enjoying all worlds.
> 
> The MAIN fix here is that currently if one fdisks some partitions,
> a BAD bug will make all partitions point to the same start-end sector
> ie: 0 - brd_size And an mkfs of any partition would trash the partition
> table and the other partition.
> 
> Another fix is that "mount -U uuid" did not work, because of the
> GENHD_FL_SUPPRESS_PARTITION_INFO flag.
> 
> So NOW the logic goes like this:
> * max_part - Just says how many minors to reserve between devices
>   But in any way, there can be as many partition as requested.
>   If minors between devices ends, then dynamic 259-major ids will
>   be allocated on the fly.
>   The default is now max_part=1, which means all partitions devt
>   will be from the dynamic major-range.
>   (If persistent partition minors is needed use max_part=)
> 
> * Creation of new devices on the fly still/always work:
>   mknod /path/devnod b 1 X
>   fdisk -l /path/devnod
>   Will create a new device if (X / max_part) was not already
>   created before. (Just as before)
> 
>   partitions on the dynamically created device will work as well
>   Same logic applies with minors as with the pre-created ones.
> 
> TODO: dynamic grow of device size, maybe through sysfs. So each
>       device can have it's own size.
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>


Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>


