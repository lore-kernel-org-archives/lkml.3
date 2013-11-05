Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3KEQEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:04:22 -0500
Received: from smtp.citrix.com ([66.165.176.89]:58347 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab3KEQEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:04:20 -0500
X-IronPort-AV: E=Sophos;i="4.93,640,1378857600"; 
   d="scan'208";a="70768381"
Message-ID: <527916EE.6060104@citrix.com>
Date: Tue, 5 Nov 2013 17:03:58 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, David Vrabel <david.vrabel@citrix.com>,
        Matt Wilson <msw@amazon.com>, <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] grant-table: don't set m2p override if kmap_ops
 is not set
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>	 <5278E64C.40200@citrix.com> <527904EC.9090402@citrix.com>	 <20131105145607.GB25836@phenom.dumpdata.com> <5279085E.7070703@citrix.com> <1383664090.13961.88.camel@kazak.uk.xensource.com>
In-Reply-To: <1383664090.13961.88.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 16:08, Ian Campbell wrote:
> On Tue, 2013-11-05 at 16:01 +0100, Roger Pau Monné wrote:
>> On 05/11/13 15:56, Konrad Rzeszutek Wilk wrote:
>>> On Tue, Nov 05, 2013 at 03:47:08PM +0100, Roger Pau Monné wrote:
>>>> On 05/11/13 13:36, David Vrabel wrote:
>>>>> On 05/11/13 11:24, Roger Pau Monne wrote:
>>>>>> IMHO there's no reason to set a m2p override if the mapping is done in
>>>>>> kernel space, so only set the m2p override when kmap_ops is set.
>>>>>
>>>>> Can you provide a more detailed reasoning about why this is safe?
>>>>
>>>> To tell the truth, I don't understand why we need to use the m2p
>>>> override for kernel space only mappings, my understanding is that this
>>>> m2p override is needed for user space mappings only (where we actually
>>>> end up doing two mappings, one in kernel space and one in user space).
>>>> For kernel space I don't see why we need to do anything else than
>>>> setting the right p2m translation.
>>>
>>> We needed the m2p when doing DMA operations. As the driver would
>>> want the bus address (so p2m) and then when unmapping the DMA we
>>> only get the bus address  - so we needed to do a m2p lookup.
>>
>> OK, we need a m2p (that we already have in machine_to_phys_mapping),
>> what I don't understand is why we need the m2p override.
> 
> The m2p is a host global table.
> 
> For a foreign page grant mapped into the current domain the m2p will
> give you the foreign (owner) domain's p from the m, not the local one.

Yes, you are completely right, then I have to figure out why blkback
works fine with this patch applied (or at least it seems to work fine).

