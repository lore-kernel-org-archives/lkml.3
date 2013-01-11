Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3AKXjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 18:39:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47553 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3AKXjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 18:39:24 -0500
Message-ID: <50F0A2A8.3080401@wwwdotorg.org>
Date: Fri, 11 Jan 2013 16:39:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Laxman Dewangan <ldewangan@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 3/3] ARM: tegra: dts: seaboard: enable keyboard
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com> <1357911185-11048-3-git-send-email-ldewangan@nvidia.com> <50F09BC7.90607@wwwdotorg.org> <20130111232438.GN23505@n2100.arm.linux.org.uk> <50F09FCB.70809@wwwdotorg.org> <20130111233615.GO23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130111233615.GO23505@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 04:36 PM, Russell King - ARM Linux wrote:
> On Fri, Jan 11, 2013 at 04:27:07PM -0700, Stephen Warren wrote:
>> On 01/11/2013 04:24 PM, Russell King - ARM Linux wrote:
>>> On Fri, Jan 11, 2013 at 04:09:59PM -0700, Stephen Warren wrote:
>>>> On 01/11/2013 06:33 AM, Laxman Dewangan wrote:
>>>>> 	kbc->clk = clk_get(&pdev->dev, NULL);
>>>>> 	if (IS_ERR(kbc->clk)) {
>>>>> 		dev_err(&pdev->dev, "failed to get keyboard clock\n");
>>>>> 		err = PTR_ERR(kbc->clk);
>>>>> 		goto err_iounmap;
>>>>> 	}
>>>>
>>>> Should that check be if (!kbc-clk) instead? Or does the common clock
>>>> framework require if (IS_ERR_OR_NULL(kbc->clk)); hopefully not since
>>>> IS_ERR_OR_NULL shouldn't be used any more.
>>>
>>> /**
>>>  * clk_get - lookup and obtain a reference to a clock producer.
>>>  * @dev: device for clock "consumer"
>>>  * @id: clock consumer ID
>>>  *
>>>  * Returns a struct clk corresponding to the clock producer, or
>>>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>  * valid IS_ERR() condition containing errno.  ...
>>>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>> Or, put another way:
>>>
>>> 	If (!IS_ERR(clk))
>>> 		The_Clock_Is_Valid();
>>> 	Else
>>> 		The_Clock_Is_Invalid();
>>> 		The_Error = PTR_ERR(clk);
>>
>> OK, but that doesn't appear to be what happened in practice.
> 
> It's what I've been saying each time I see an abuse, the problem is
> people don't care to read the documentation provided let alone
> understand the interfaces.
> 
> That's precisely why IS_ERR_OR_NULL() is to be removed.  One less
> thing for someone to throw a dart at as a selection method to use.
> Or maybe roll a dice.  Or whatever way they do seem to choose.
> (Whatever that is, it's not based on any sound engineering practice
> I can make out.)

For the record, I did mention that IS_ERR_OR_NULL() should not be the
solution here. And the point of my email to Laxman was that he should go
figure out the answer to my question, which would entail reading the
documentation/code/...
