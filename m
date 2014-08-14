Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaHNPeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:34:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:29345 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbaHNPeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:34:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,863,1400050800"; 
   d="scan'208";a="584896479"
Date: Thu, 14 Aug 2014 09:33:38 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Jens Axboe <axboe@fb.com>
cc: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v11] NVMe: Convert to blk-mq
In-Reply-To: <53ECD125.3080701@fb.com>
Message-ID: <alpine.LRH.2.03.1408140920520.14603@AMR>
References: <1406365643-27020-1-git-send-email-m@bjorling.me> <1406365643-27020-2-git-send-email-m@bjorling.me> <CAOu_J6mW-2e2Jgm+khodLPah_-RZrD599SmSH+Mszd0AjterrQ@mail.gmail.com> <alpine.LRH.2.03.1408131519590.14603@AMR> <53EC7273.5060303@bjorling.me>
 <53ECD125.3080701@fb.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-799657267-1408030421=:14603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-799657267-1408030421=:14603
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 14 Aug 2014, Jens Axboe wrote:
> On 08/14/2014 02:25 AM, Matias Bjørling wrote:
>> The result is set to BLK_MQ_RQ_QUEUE_ERROR, or am I mistaken?
>
> Looks OK to me, looking at the code, 'result' is initialized to
> BLK_MQ_RQ_QUEUE_BUSY though. Which looks correct, we don't want to error
> on a suspended queue.

My mistake missing how the result was initialized.

> nr_tags must be uninitialized or screwed up somehow, otherwise I don't
> see how that kmalloc() could warn on being too large. Keith, are you
> running with slab debugging? Matias, might be worth trying.

I'm not running with slab debugging. If it's any clue at all, blk-mq is
using 16 of the 31 allocated h/w queues (which is okay as we discussed
earlier), and the oops happens when clearing the first unused queue.

I'll have time to mess with this more today, so I can either help find
the problem or apply a patch if one becomes available.
--8323328-799657267-1408030421=:14603--
