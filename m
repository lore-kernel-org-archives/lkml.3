Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbaHFRK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:10:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50468 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878AbaHFRJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:09:52 -0400
Message-ID: <53E26155.1020107@ti.com>
Date: Wed, 6 Aug 2014 13:09:41 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: keystone: add a pci quirk to limit mrrs
References: <1407338300-9146-1-git-send-email-m-karicheri2@ti.com> <20140806163021.GB19914@obsidianresearch.com> <53E25E24.8070506@ti.com> <20140806165837.GC19914@obsidianresearch.com>
In-Reply-To: <20140806165837.GC19914@obsidianresearch.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 12:58 PM, Jason Gunthorpe wrote:
> On Wed, Aug 06, 2014 at 12:56:04PM -0400, Murali Karicheri wrote:
>> On 08/06/2014 12:30 PM, Jason Gunthorpe wrote:
>>> On Wed, Aug 06, 2014 at 11:18:20AM -0400, Murali Karicheri wrote:
>>>> Keystone PCI controller has a limitation that memory read request
>>>> size must not exceed 256 bytes. This is a hardware limitation and
>>>> add a quirk to force this limit on all downstream devices by
>>>> updating mrrs.
>>>
>>> Does this still work if the tuning is enabled, or does the tuning run
>>> after this?
>>
>> Yes it works with tuning enabled. Tuning happens afterwards. The
>> 'limiting mrrs to 256' below is from my patch.
>
> That seems backwards to me...
Rational? The tuning is reading mrrs and set mps to less than or equal 
to mrss. So adding this before make sure mrrs used is below keystones's 
limit.

Murali
>
> Jason

