Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3AOJIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 04:08:09 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34541 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3AOJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 04:08:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh2x=mzcxT=8=RS1Fa_Vn3Frixj9BNEeYGQ0NH+00YV1i-VHw@mail.gmail.com>
References: <1358173253-680-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==d46_R2btWmi1KnmY-TfAGRxHrwSzT6NFVFP-Hp0-0Kw@mail.gmail.com>
	<CAHp75VdF7twFTFJvUgRZW+jk6cSc_y_DSc4VcCvjBcTYYJGhRQ@mail.gmail.com>
	<CAOh2x=mzcxT=8=RS1Fa_Vn3Frixj9BNEeYGQ0NH+00YV1i-VHw@mail.gmail.com>
Date: Tue, 15 Jan 2013 11:08:04 +0200
Message-ID: <CAHp75VegokmDnXTPHYE=kKzwAgiuD9ySg4wRxxZFGkuXdQoStw@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: don't exceed AHB master number in dwc_get_data_width
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:01 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On Tue, Jan 15, 2013 at 12:35 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>>> The details of the patch are fine, but i didn't get how do you get
>>> master 1 selected
>>> on a system where you have only 1 master?
>>
>> min_t(..., nr_masters - 1, m) defines this. m is returned value with
>> default settings, let's say 1. In that case if nr_masters is also 1
>> the min_t(..., 1-1, 1) returns 0.
>>
>> The value of nr_masters itself is come from autoconfig or platform data.
>
> :)
> You didn't get me. How this code would work is pretty easy to understand.
> What i wanted to know is, the master information is coming from slave drivers
> and they must select master zero always. How would master 1 be selected ever
> in this driver.

You forgot the mem2mem type of transfers where we have no information
about masters except default settings. Otherwise there is the case of
custom slave config absence when we supply only request line via
slave_id.

In the rest you are right.

-- 
With Best Regards,
Andy Shevchenko
