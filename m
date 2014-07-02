Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaGBLCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:02:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:44335 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaGBLCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:02:50 -0400
Message-ID: <53B3E6B4.2040907@windriver.com>
Date: Wed, 2 Jul 2014 19:02:12 +0800
From: "Yang,Wei" <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <mroberto@cpti.cetuc.puc-rio.br>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1] ARM:sa1100: Remove a redundant spin lock
References: <1404200488-7809-1-git-send-email-Wei.Yang@windriver.com> <53B3CEAC.9080609@windriver.com> <20140702101925.GE32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140702101925.GE32514@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 06:19 PM, Russell King - ARM Linux wrote:
> On Wed, Jul 02, 2014 at 05:19:40PM +0800, Yang,Wei wrote:
>> Hi Guys,
>>
>> What about this patch?
> The only concern on the face of it is that it removes mutual exclusion
> from the pci config write path, where a read-modifiy-write operation is
> performed.
>
> However, the PCI code already gives that guarantee (drivers/pci/access.c)
> so this should be safe.
>
> As this is fairly old code, it would be useful to know what the motivation
> is behind this change.  Is it purely clean up, or is it something that
> you've tested, or is this a change that you require for something else?
>
> Thanks.
>
Hmm, I fixed a bug of pci config read/write of an ARM board, but 
unfortunately, so far ML does not support it. So
I cannot send the fix, but I grepped the pci source code of ARM 
architecure, I found that the pci code of a few boards always
define a static spin lock to excluse the pci config read/write path. I 
just intended to clean up them. If you agree the change,
I want to send v2 to also remove this mutual exclusion for something 
else board which also used the mutual exclusion.

Thanks
Wei
