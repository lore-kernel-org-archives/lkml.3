Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaE2DpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:45:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:14776 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751217AbaE2Do6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:44:58 -0400
X-IronPort-AV: E=Sophos;i="4.98,932,1392134400"; 
   d="scan'208";a="31165308"
Message-ID: <5386AABD.5070708@cn.fujitsu.com>
Date: Thu, 29 May 2014 11:34:21 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: xfs: possible deadlock warning
References: <538571D4.70904@cn.fujitsu.com> <20140528060050.GK8554@dastard>
In-Reply-To: <20140528060050.GK8554@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 05/28/2014 02:00 PM, Dave Chinner wrote:

> On Wed, May 28, 2014 at 01:19:16PM +0800, Gu Zheng wrote:
>> Hi all,
>> When running the latest Linus' tree, the following possible deadlock warning occurs.
> 
> false positive. There isn't a deadlock between inode locks on
> different filesystems. i.e. there is no dependency between shmem
> inodes and xfs inodes, nor on their security contexts.  Nor can you
> take a page fault on a directory inode, which is the XFS inode lock
> class it's complaining about.

If it's really a noisy, can we avoid this?
 
Thanks,
Gu

> 
> Fundamentally, the problem here is shmem instantiating a new inode
> with the mmap_sem held. That's just plain wrong...

Agree, it's better to prepare the file before going into the protection region. 

> 
> 
> Cheers,
> 
> Dave.


