Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3KEOrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:47:12 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:56302 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3KEOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:47:11 -0500
X-IronPort-AV: E=Sophos;i="4.93,640,1378857600"; 
   d="scan'208";a="68164225"
Message-ID: <527904EC.9090402@citrix.com>
Date: Tue, 5 Nov 2013 15:47:08 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Matt Wilson <msw@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] grant-table: don't set m2p override if kmap_ops is not
 set
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com> <5278E64C.40200@citrix.com>
In-Reply-To: <5278E64C.40200@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 13:36, David Vrabel wrote:
> On 05/11/13 11:24, Roger Pau Monne wrote:
>> IMHO there's no reason to set a m2p override if the mapping is done in
>> kernel space, so only set the m2p override when kmap_ops is set.
> 
> Can you provide a more detailed reasoning about why this is safe?

To tell the truth, I don't understand why we need to use the m2p
override for kernel space only mappings, my understanding is that this
m2p override is needed for user space mappings only (where we actually
end up doing two mappings, one in kernel space and one in user space).
For kernel space I don't see why we need to do anything else than
setting the right p2m translation.

> Did you consider other ways of improving scalability?  e.g., a
> per-bucket read-write lock.

Not really, the main focus of this patch is to optimize kernel space
only mappings (like the ones done in blkback), so why go down this road
when we can actually remove the need for a lock at all in this case?
