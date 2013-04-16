Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3DPM66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:58:58 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:38415 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3DPM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:58:57 -0400
Message-ID: <516D4AF3.5060205@gmail.com>
Date: Tue, 16 Apr 2013 07:58:27 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Colin Cross <ccross@android.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [RFC PATCH 1/3] pstore-ram: use write-combine mappings
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com> <CAMbhsRSvQPbzJ7Nt=OSSYE_A1e+eaUjO7XY+qRppJ5_gfWmW4A@mail.gmail.com> <51656992.60203@gmail.com> <CAMbhsRS1hnBRoomoiNijrXZB-938d2RSs1cu9EdSfmXD3xpSQg@mail.gmail.com> <516C9454.4060009@gmail.com> <CAMbhsRRT7tOBHppvjJEW5wRtVaUhwxr8=YQY=Sy0VAFeBg1JmQ@mail.gmail.com> <20130416084418.GA30756@mudshark.cambridge.arm.com>
In-Reply-To: <20130416084418.GA30756@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 03:44 AM, Will Deacon wrote:
> On Tue, Apr 16, 2013 at 01:43:09AM +0100, Colin Cross wrote:
>> On Mon, Apr 15, 2013 at 4:59 PM, Rob Herring <robherring2@gmail.com> wrote:
>>> Exclusive accesses still have further restrictions. From section 3.4.5:
>>>
>>> • It is IMPLEMENTATION DEFINED whether LDREX and STREX operations can be
>>> performed to a memory region
>>>    with the Device or Strongly-ordered memory attribute. Unless the
>>> implementation documentation explicitly
>>>   states that LDREX and STREX operations to a memory region with the
>>> Device or Strongly-ordered attribute are
>>>  permitted, the effect of such operations is UNPREDICTABLE.
>>>
>>>
>>> Given that it is implementation defined, I don't see how Linux can rely
>>> on that behavior.
>>
>> I see, the problem is that while noncached and writecombined appear to
>> be similar mappings, noncached is mapped in PRRR to strongly-ordered,
>> while writecombined is mapped to unbufferable normal memory.
>>
>> I think adding a wmb() to persistent_ram_write is going to be
>> expensive on cpus with outer caches like the L2X0, where wmb() will
>> result in a spinlock.  Is there a real SoC where this doesn't work?
> 
> A real SoC where exclusives don't work to memory not mapped as normal? Take
> your pick...

This patch doesn't actually fix problems for me. Exclusives to DDR work
for any memory type for me as the DDR controller has an exclusive
monitor. It takes write-thru cache mapping to get internal RAM to work.

Rob

