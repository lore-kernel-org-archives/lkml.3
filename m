Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaB0IVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:21:48 -0500
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:32998 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157AbaB0IVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:21:47 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 03:21:46 EST
Message-ID: <530EF591.5000504@overkiz.com>
Date: Thu, 27 Feb 2014 09:21:37 +0100
From: Boris BREZILLON <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org
CC: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk:at91: Fix memory leak in of_at91_clk_master_setup()
References: <1392124507-14463-1-git-send-email-standby24x7@gmail.com> <52FA2338.3030707@overkiz.com> <52FF9EFC.2060707@overkiz.com> <20140227020226.12081.28850@quantum>
In-Reply-To: <20140227020226.12081.28850@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17735175332766185500
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/2014 03:02, Mike Turquette wrote:
> Quoting Boris BREZILLON (2014-02-15 09:08:12)
>> Hi Mike,
>>
>> Could you take this patch for the next 3.14 release ?
> Taken in for the next batch of fixes.
Thanks.
>
> Regards,
> Mike
>
>> Best Regards,
>>
>> Boris
>>
>> On 11/02/2014 14:18, Boris BREZILLON wrote:
>>> On 11/02/2014 14:15, Masanari Iida wrote:
>>>> cppcheck detected following error
>>>> [clk-master.c:245]: (error) Memory leak: characteristics
>>>>
>>>> The original code forgot to free characteristics when
>>>> irq_of_parse_and_map() failed.
>>>>
>>>> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
>>> Acked-by Boris BREZILLON <b.brezillon@overkiz.com>
>>>
>>> Thanks for fixing this.
>>>
>>> Best Regards,
>>>
>>> Boris
>>>> ---
>>>>    drivers/clk/at91/clk-master.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/clk/at91/clk-master.c
>>>> b/drivers/clk/at91/clk-master.c
>>>> index bd313f7..c1af80b 100644
>>>> --- a/drivers/clk/at91/clk-master.c
>>>> +++ b/drivers/clk/at91/clk-master.c
>>>> @@ -242,7 +242,7 @@ of_at91_clk_master_setup(struct device_node *np,
>>>> struct at91_pmc *pmc,
>>>>          irq = irq_of_parse_and_map(np, 0);
>>>>        if (!irq)
>>>> -        return;
>>>> +        goto out_free_characteristics;
>>>>          clk = at91_clk_register_master(pmc, irq, name, num_parents,
>>>>                           parent_names, layout,

