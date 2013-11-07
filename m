Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3KGTcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:32:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:59983 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab3KGTbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:31:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="386159976"
Message-ID: <527BEA91.6050603@linux.intel.com>
Date: Thu, 07 Nov 2013 11:31:29 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Corrupted low memory in v3.9+
References: <CAOesGMgV2UsBffPveaE+j1s-mDZ+cQvvQGLGAXjWSAv+a_56Fw@mail.gmail.com>	<52603CD6.6080507@linux.intel.com>	<CAOesGMjgvPWpZssrepDszTr0EexHtDXznWA4XYoZ6O_U=XJGAg@mail.gmail.com> <CAOesGMgiUbJF01+BPBDgJT3J-Sn6ewE04aMyCTYrwjKwY4S2SQ@mail.gmail.com>
In-Reply-To: <CAOesGMgiUbJF01+BPBDgJT3J-Sn6ewE04aMyCTYrwjKwY4S2SQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 11:02 AM, Olof Johansson wrote:
>> [    0.000000] reserving inaccessible SNB gfx pages
>> [    0.000000] memblock_reserve: [0x00000000000000-0x00000000100000]

This is on a Sandy Bridge system, which I guess I managed to miss the
first time.  Unfortunately low memory corruption is expected with SNB
graphics... this is why we unconditionally reserve all low memory on SNB.

>> setup_arch+0xa2d/0xa41
>> [...]
>>
>> Unfortunately x86 doesn't keep the memblock structures around, so
>> there's no way to verify after booting in debugfs, but based on the
>> above it should have been reserved properly.
> 
> *prod*
> 
> So, got a preference on solution for this? The warning seems harmless
> but still annoying to get used to ignoring false positives, etc.
> 
> Disable the low memory checker by default? Hide it behind a debug
> option (runtime or build time)?
> 

I'm inclined to say disable it by default, but I'll let Ingo comment.
These days we default to reserving all of low memory other than the
trampoline (which we really can't avoid); leaving it in as a debug
option seems reasonable, but it is really questionable to me how much it
is useful to a general user.

	-hpa


