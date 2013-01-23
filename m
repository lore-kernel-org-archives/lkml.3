Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3AWKU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:20:56 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:56637 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3AWKUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:20:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=_BR49Og4MRPB9SfDEwnD3OoKwFWiCsTKNfpYFSyp25Q@mail.gmail.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==FoW5Sh5KFt9iO+_04dEbwsQHJX3rsTWNqFiZqTbPn6A@mail.gmail.com>
	<1358846546.12502.57.camel@smile>
	<CAKohpo=m-s4+q+4v2v+8nzC32FRzJAb58no2hZLV_5QqTj4wig@mail.gmail.com>
	<1358932355.12502.68.camel@smile>
	<CAKohpo=BHGukSQJJGUS=H++qzxME3aEEQZR8QiyHPU8LabHsSw@mail.gmail.com>
	<CAHp75VeNe1Z9CqYXVjV6am_vg=5XF=vx1i47h71xRdTvT6hSGA@mail.gmail.com>
	<CAKohpo=_BR49Og4MRPB9SfDEwnD3OoKwFWiCsTKNfpYFSyp25Q@mail.gmail.com>
Date: Wed, 23 Jan 2013 12:20:52 +0200
Message-ID: <CAHp75VdBB1mk0PaG1z9JR0PmQPS5gtgnXSs7_SoBY7TLNp9ZtQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 11:51 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 23 January 2013 15:06, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>> On Wed, Jan 23, 2013 at 11:22 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

>>> Second to solve your problem, you can add another field here: total_len.
>>> I know it will consume 4 bytes per desc but i think that's the drawback we need
>>> to accept.
>>
>> I found already better solution I guess.
>
> Wow!!
>
>> I introduced two functions to get amount of sent bytes like
>>
>> u32 calc_sent(u32 ctlhi, u32 ctllo)
>> {
>>  return f1(ctlhi) * f2(ctllo);
>> }
>>
>> u32 get_sent(dwc)
>> {
>>  return calc_sent(read(CTL_HI), read(CTL_LO));
>> }
>>
>> And usage like
>>
>> /* initial residue */
>> desc->len - calc_sent(desc->lli.ctlhi, desc->lli.ctllo).
>>
>> What do you think?
>
> You plan to use it for
> - the first descriptor in a list as others already have length embedded in them?
> - And the descriptor currently getting used, by reading its ctlhi/lo
> from registers
>   instead of lli.*** ?

Roughly, yes.

> Looks good. but still keeping len of individual descriptors in all
> descriptors leaving
> the first one is not the code i would like to keep :)

What about to calc len every time from lli.* instead of keeping it in
the len field of the descriptor?
It's logically looks better, but requires more resources.

-- 
With Best Regards,
Andy Shevchenko
