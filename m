Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3I0VZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:25:21 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:44424 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3I0VZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:25:19 -0400
Message-ID: <5245F7BA.6080101@gmail.com>
Date: Fri, 27 Sep 2013 23:25:14 +0200
From: Vojtech Bocek <vbocek@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: About atags_proc buffer size
References: <5245E9C9.9030509@gmail.com> <20130927204743.GK12758@n2100.arm.linux.org.uk> <5245F3F9.5040004@gmail.com> <20130927211537.GN12758@n2100.arm.linux.org.uk>
In-Reply-To: <20130927211537.GN12758@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay then, I suppose there is no nice way around that, or at least none
that I can find. I'll just make that initial buffer 12kb big on my kernel
for that device and be done with it.

Anyway, thanks for the information and help, it is much appreciated.

On 27.9.2013 23:15, Russell King - ARM Linux wrote:

> On Fri, Sep 27, 2013 at 11:09:13PM +0200, Vojtech Bocek wrote:
>> It only needs to survive until init_atags_procfs is called, because it is
>> copied to another buffer for procfs entry. Can I be sure it survives until
>> that? My guess is that it is likely to survive, but not certain.
>>
>> I suppose it is possible to somehow protect that bit of ram until it is
>> read by init_atags_procfs, but I wonder if you even want to do that in
>> mainline - if majority of devices doesn't use such big tag lists, then
>> it is probably that device's vendor problem. I've met this problem on two
>> devices so far though, both of them Android phones, one is the HTC One
>> (that is MSM APQ8064 SoC) and I unfortunately can't remember the first
>> one - I discarded it as usual Android kernel's mess.
> 
> We've been through several early allocators - particularly one which
> allocates from the bottom of memory upwards, which would overwrite the
> ATAGs long before init_atags_procfs gets called.
> 
> If we rely on the behaviour of the current early allocator not to
> touch that, and it changes in the future, that's going to be rather
> too fragile.


