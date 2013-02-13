Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135Ab3BMREe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:04:34 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38647 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760039Ab3BMREd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:04:33 -0500
Message-ID: <511BC79C.6050407@arm.com>
Date: Wed, 13 Feb 2013 17:04:28 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH] virt_mmio: fix signature checking for BE guests
References: <1360765538-18097-1-git-send-email-marc.zyngier@arm.com> <1360768102.4045.107.camel@hornet> <511BB134.30003@arm.com> <20130213165356.GA23193@redhat.com>
In-Reply-To: <20130213165356.GA23193@redhat.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Feb 2013 17:04:29.0827 (UTC) FILETIME=[2FCE7D30:01CE0A0C]
X-MC-Unique: 113021317043113701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/02/13 16:53, Michael S. Tsirkin wrote:
> On Wed, Feb 13, 2013 at 03:28:52PM +0000, Marc Zyngier wrote:
>> On 13/02/13 15:08, Pawel Moll wrote:
>>> On Wed, 2013-02-13 at 14:25 +0000, Marc Zyngier wrote:
>>>> Using readl() to read the magic value and then memcmp() to check it
>>>> fails on BE, as bytes will be the other way around (by virtue of
>>>> the registers to follow the endianess of the guest).
>>>
>>> Hm. Interesting. I missed the fact that readl() as a "PCI operation"
>>> will always assume LE values...
>>>
>>>> Fix it by encoding the magic as an integer instead of a string.
>>>> So I'm not completely sure this is the right fix, 
>>>
>>> It seems right, however...
>>>
>>>> - Using __raw_readl() instead. Is that a generic enough API?
>>>>
>>> ... this implies that either the spec is wrong (as it should say: the
>>> device registers are always LE, in the PCI spirit) or all readl()s & co.
>>> should be replaced with __raw equivalents.
>>
>> Well, the spec clearly says that the registers reflect the endianess of
>> the guest, and it makes sense: when performing the MMIO access, KVM
>> needs to convert between host and guest endianess.
>>
>>> Having said that, does the change make everything else work with a BE
>>> guest? (I assume we're talking about the guest being BE, right? ;-) If
>>> so it means that the host is not following the current spec and it
>>> treats all the registers as LE.
>>
>> Yes, I only care about a BE guest. And no, not much is actually working
>> (kvmtool is not happy about the guest addresses it finds in the
>> virtio-ring). Need to dive into it and understand what needs to be fixed...
> 
> Does it work for qemu? I know people were using virtio on BE there.

No idea, haven't tried yet, and my guest "platform" isn't supported by
QEMU. Is someone actually using BE guests on LE hosts? That would be
very interesting to compare things...

	M.
-- 
Jazz is not dead. It just smells funny...

