Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaIJIGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:06:09 -0400
Received: from relay1.sgi.com ([192.48.180.66]:34848 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaIJIGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:06:02 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 04:06:01 EDT
Message-ID: <541004B6.8070800@sgi.com>
Date: Wed, 10 Sep 2014 02:58:46 -0500
From: Gary Kroening <gfk@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>, Nathan Zimmer <nzimmer@sgi.com>,
        jroedel@suse.de
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] iommu/vt-d: Use the SIRTP when enabling remapping
References: <1410297096-54096-1-git-send-email-nzimmer@sgi.com> <540FF614.8000003@siemens.com>
In-Reply-To: <540FF614.8000003@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/2014 1:56 AM, Jan Kiszka wrote:
> On 2014-09-09 23:11, Nathan Zimmer wrote:
>> The previous change (iommu/vt-d: Don't store SIRTP request) to this area
>> caused a crash in our simulator. In particular is seems that by the time a
>> UART interrupt is sent through the system, we don't see interrupt remapping
>> to be enabled.  So the interrupt does not get translated to a logical
>> interrupt and crashes.
>>
>> OR'ing the SIRTP request to make sure it is seen but hopefully not sticky.
>> This seems like a clean fix, at least on our simulator; if you don't agree,
>> our simulator guy will take a closer look at our iommu model.
>
> Check the VT-d spec (6.7, Set Interrupt Remapping Table Pointer
> Operation): "Software must always follow the interrupt-remapping table
> pointer set operation with a global invalidate of the IEC to ensure
> hardware references the new structures *before* enabling interrupt
> remapping." There is also (command register description): "If multiple
> control fields in this register need to be modified, software must
> serialize the modifications through multiple writes to this register."
> This, in combination with the command registers description of bits 24
> and 25 strongly suggests that your model is broken.

Thanks, Jan. I'll read up on it. Still working out some kinks with
the relatively new IOMMU/interrupt-remapping logic which we added over
the last 18 months or so. Sorry for any distraction, and thanks for the
help/info.
Gary

>
>>
>> Found testing on our simulator, not real hardware.
>
> Funnily, the original issue was found by the QEMU model of VT-d that
> used to take the last cited sentence very strictly (I asked to remove it
> due to the preexisting Linux versions).
>
> Jan
>

