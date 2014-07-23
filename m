Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbaGWTrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:47:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21397 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665AbaGWTrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:47:08 -0400
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140625103445.GA12943@avagotech.com>
	<yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
	<CAK=zhgoQt5J=jh4jShAy5rBXNz34sN-tqf=uZDkY4zQJ9XhM5g@mail.gmail.com>
	<yq18unklvda.fsf@sermon.lab.mkp.net>
	<CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
Date: Wed, 23 Jul 2014 15:46:26 -0400
In-Reply-To: <CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
	(Sreekanth Reddy's message of "Wed, 23 Jul 2014 23:07:37 +0530")
Message-ID: <yq1r41bkgdp.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth,

Sreekanth> 2. As per MPI Spec, each set of 8 reply descriptor post
Sreekanth> queues must have the same value for the upper 32-bits of
Sreekanth> their memory address. So allocated set of eight queues in a
Sreekanth> single pool and added a new function is_MSB_are_same() to
Sreekanth> check whether higher 32 bits of this pool memory address are
Sreekanth> same or not. If this functions returns zero then we are
Sreekanth> saving these pools in the bad_reply_post_pool list. then
Sreekanth> releasing these pools once we get the required memory pools.

Why don't you just set pci_set_consistent_dma_mask() to DMA_BIT_MASK(32)
before you allocate the queue entries?

-- 
Martin K. Petersen	Oracle Linux Engineering
