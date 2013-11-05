Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3KEPBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:01:54 -0500
Received: from smtp.citrix.com ([66.165.176.89]:20396 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab3KEPBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:01:53 -0500
X-IronPort-AV: E=Sophos;i="4.93,640,1378857600"; 
   d="scan'208";a="70732935"
Message-ID: <5279085E.7070703@citrix.com>
Date: Tue, 5 Nov 2013 16:01:50 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>, Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH] grant-table: don't set m2p override if kmap_ops is not
 set
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com> <5278E64C.40200@citrix.com> <527904EC.9090402@citrix.com> <20131105145607.GB25836@phenom.dumpdata.com>
In-Reply-To: <20131105145607.GB25836@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 15:56, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 05, 2013 at 03:47:08PM +0100, Roger Pau Monné wrote:
>> On 05/11/13 13:36, David Vrabel wrote:
>>> On 05/11/13 11:24, Roger Pau Monne wrote:
>>>> IMHO there's no reason to set a m2p override if the mapping is done in
>>>> kernel space, so only set the m2p override when kmap_ops is set.
>>>
>>> Can you provide a more detailed reasoning about why this is safe?
>>
>> To tell the truth, I don't understand why we need to use the m2p
>> override for kernel space only mappings, my understanding is that this
>> m2p override is needed for user space mappings only (where we actually
>> end up doing two mappings, one in kernel space and one in user space).
>> For kernel space I don't see why we need to do anything else than
>> setting the right p2m translation.
> 
> We needed the m2p when doing DMA operations. As the driver would
> want the bus address (so p2m) and then when unmapping the DMA we
> only get the bus address  - so we needed to do a m2p lookup.

OK, we need a m2p (that we already have in machine_to_phys_mapping),
what I don't understand is why we need the m2p override.

With this patch the m2p is correctly provided by mfn_to_pfn_no_overrides
just by using the machine_to_phys_mapping array, why we need to add an
override?
