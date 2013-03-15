Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3COFWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:22:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38568 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3COFWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:22:48 -0400
Message-ID: <5142B027.4040403@wwwdotorg.org>
Date: Thu, 14 Mar 2013 23:22:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 1/1] clk: Add notifier support in clk_prepare_enable/clk_disable_unprepare
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com>  <20130312134032.GU4977@n2100.arm.linux.org.uk>  <1363139273.21694.11.camel@bilhuang-vm1> <514003B6.8020904@wwwdotorg.org>  <1363151317.3311.9.camel@bilhuang-vm1> <51400D9D.9060305@wwwdotorg.org>  <1363153204.3311.14.camel@bilhuang-vm1> <5140C12A.4060900@wwwdotorg.org>  <1363227311.3311.30.camel@bilhuang-vm1>  <20130314092132.GE18519@tbergstrom-lnx.Nvidia.com>  <1363253287.3311.32.camel@bilhuang-vm1> <51420EBB.7080503@wwwdotorg.org> <1363310454.3311.44.camel@bilhuang-vm1>
In-Reply-To: <1363310454.3311.44.camel@bilhuang-vm1>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 07:20 PM, Bill Huang wrote:
> On Fri, 2013-03-15 at 01:54 +0800, Stephen Warren wrote:
>> On 03/14/2013 03:28 AM, Bill Huang wrote:
>>> On Thu, 2013-03-14 at 17:21 +0800, Peter De Schrijver wrote:
>>>> On Thu, Mar 14, 2013 at 03:15:11AM +0100, Bill Huang wrote:
>>>>
>>>>> I don't think deferring will work either, considering the usage of DVFS,
>>>>> device voltage is tightly coupled with frequency, when clock rate is
>>>>> about to increase, we have to boost voltage first and we can lower the
>>>>> voltage after the clock rate has decreased. All the above sequence have
>>>>> to be guaranteed or you might crash, so deferring not only make thing
>>>>> complicated in controlling the order but also hurt performance.
>>>>
>>>> But we could use notifiers in clk_prepare/clk_unprepare to set the voltage no?
>>>> As clk_prepare/clk_unprepare have to be called before clk_enable or after
>>>> clk_disable, the voltage can be raised to a safe level, before the clock
>>>> becomes active.
>>>
>>> Thanks Peter, actually I'm just about to propose my v2 RFC which add
>>> notifier in clk_prepare/clk_unprepare.
>>
>> Can't clk_set_rate() be called while the clock is prepared, or even
>> enabled? I don't see how your proposal would work.
>
> I think it works with just a little sacrifice on saving more power but
> that's related minor. Taking clk_prepare as an indicator on that clock
> will be enabled later, so we can raise the voltage to a safe level
> (according to the current rate or maybe default rate when clk_prepare is
> called, some time late when clk_set_rate() is called we can adjust again
> according to the requested rate change)

Is clk_set_rate() only legal to call in non-atomic contexts then? The
header file doesn't say, although I guess since many other functions
explicitly say they can't, then by omission it can...
