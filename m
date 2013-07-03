Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3GCMbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:31:18 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64266 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3GCMbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:31:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHy1fFdU1zGcxMsoeYnz8tb-JktSYBScc+Soqge8Q-++Rw@mail.gmail.com>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
	<1372072858-6559-3-git-send-email-yadi.brar@samsung.com>
	<CAK9yfHy1fFdU1zGcxMsoeYnz8tb-JktSYBScc+Soqge8Q-++Rw@mail.gmail.com>
Date: Wed, 3 Jul 2013 18:01:17 +0530
Message-ID: <CAKew6eWsyNKEUtOKQOfa7DpsQfU=N4YYrtyRY+9EeEQz6v5EZw@mail.gmail.com>
Subject: Re: [PATCH 2/4] regulator: s2mps11: Implement set_voltage_time_sel()
 ops for bucks
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org,
        sbkim73@samsung.com, broonie@kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, rob.herring@calxeda.com,
        grant.likely@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 5:25 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 24 June 2013 16:50, Yadwinder Singh Brar <yadi.brar@samsung.com> wrote:
>> Currently driver uses local struct s2mps11_info to store ramp rate for bucks
>> whic its getting through platform data, so instead of using regulator
>> constraints it should use s2mps11_info to calculate ramp delay.
>>
>> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> [snip]
>> +
>> +       switch (rdev->desc->id) {
>> +       case S2MPS11_BUCK2:
>> +               if (!s2mps11->buck2_ramp)
>> +                       return 0;
>> +               ramp_delay = s2mps11->ramp_delay2;
>> +               break;
>> +       case S2MPS11_BUCK3:
>> +               if (!s2mps11->buck3_ramp)
>> +                       return 0;
>> +               ramp_delay = s2mps11->ramp_delay34;
>> +               break;
>> +       case S2MPS11_BUCK4:
>> +               if (!s2mps11->buck4_ramp)
>> +                       return 0;
>> +               ramp_delay = s2mps11->ramp_delay34;
>> +               break;
>> +       case S2MPS11_BUCK5:
>> +               ramp_delay = s2mps11->ramp_delay5;
>> +               break;
>> +       case S2MPS11_BUCK6:
>> +               if (!s2mps11->buck6_ramp)
>> +                       return 0;
>> +       case S2MPS11_BUCK1:
>
> nit: Why not have this at the beginning?
>

Nothing special. Instead of putting "case S2MPS11_BUCK6" at beginning,
I preferred to put S2MPS11_BUCK1 here.

>> +               ramp_delay = s2mps11->ramp_delay16;
>> +               break;
>> +       case S2MPS11_BUCK7:
>> +       case S2MPS11_BUCK8:
>> +       case S2MPS11_BUCK10:
>> +               ramp_delay = s2mps11->ramp_delay7810;
>> +               break;
>> +       case S2MPS11_BUCK9:
>> +               ramp_delay = s2mps11->ramp_delay9;
>> +       }
>
> How about adding a break statement above?
>

hmm .. I can't see any worth of it.
Is it required according to linux coding convention ?


Regards,
Yadwinder

--
> With warm regards,
> Sachin
