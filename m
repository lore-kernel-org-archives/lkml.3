Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3CALVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:21:11 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45964 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3CALVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:21:10 -0500
Message-ID: <51308F22.7040303@arm.com>
Date: Fri, 01 Mar 2013 11:21:06 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Pawel Moll <Pawel.Moll@arm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio-spec: Define virtio-mmio registers as LE
References: <87wqubkalj.fsf@rustcorp.com.au>  <1360839247-9131-1-git-send-email-pawel.moll@arm.com>  <513085EA.8070007@arm.com> <1362135005.3052.26.camel@hornet>
In-Reply-To: <1362135005.3052.26.camel@hornet>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 01 Mar 2013 11:21:08.0089 (UTC) FILETIME=[DED2BE90:01CE166E]
X-MC-Unique: 113030111210802601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/13 10:50, Pawel Moll wrote:
> On Fri, 2013-03-01 at 10:41 +0000, Marc Zyngier wrote:
>> On 14/02/13 10:54, Pawel Moll wrote:
>>> To solve the never-ending confusions between hosts and guests
>>> of different endianess, define all virtio-mmio registers as LE.
>>>
>>> This change should be safe at this stage, because no known
>>> working mixed-endian system exists so there is virtually no
>>> risk of breaking compatibility.
>>>
>>> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
>>
>> Shouldn't we exclude the config space? PCI defines it as guest-endian,
>> and the above tends to indicate that it should be LE with MMIO.
> 
> The spec says: "Device-specific configuration space starts at an offset
> 0x100 and is accessed with byte alignment. Its meaning and size depends
> on the device and the driver."
> 
> I would hope that "accessed with byte alignment" is enough of a clue in
> this subject, but if you think otherwise I can add a sentence stating
> this explicitly.

Well, it was unclear enough for me to get confused... ;-) It would make
sense to have a wording similar to the one in the PCI section.

> Having said that, Rusty was contemplating enforcing LE config space in
> the new PCI layout...

I wouldn't complain about that, and would like to see a similar thing on
MMIO.

	M.
-- 
Jazz is not dead. It just smells funny...

