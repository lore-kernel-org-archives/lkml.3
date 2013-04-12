Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3DLJqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:46:21 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:38927 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3DLJqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:46:19 -0400
Message-ID: <5167D7E4.9030206@free-electrons.com>
Date: Fri, 12 Apr 2013 11:46:12 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] clk: Add device tree binding to clk-fixed-factor
References: <1365608443-30350-1-git-send-email-christian.ruppert@abilis.com> <51658BA9.7030508@free-electrons.com> <20130410162747.GG32603@ab42.lan> <20130411091952.GF8400@ab42.lan> <5166E41F.7060100@free-electrons.com> <20130412065417.GA29291@ab42.lan> <5167CE33.9010403@free-electrons.com> <20130412091234.GC29291@ab42.lan>
In-Reply-To: <20130412091234.GC29291@ab42.lan>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 11:12 AM, Christian Ruppert wrote:
> On Fri, Apr 12, 2013 at 11:04:51AM +0200, Gregory CLEMENT wrote:
>> On 04/12/2013 08:54 AM, Christian Ruppert wrote:
>>> On Thu, Apr 11, 2013 at 06:26:07PM +0200, Gregory CLEMENT wrote:
>>>> On 04/11/2013 11:19 AM, Christian Ruppert wrote:
>>>>> Hi Gregory,
>>>>>
>>>>> Since there doesn't seem to be anyone opposing this feature I just
>>>>> checked your patch and after adding the CLK_OF_DECLARE macro in the end
>>>>> it works well for us. Tell me if you would like to rebase and resubmit
>>>>> your patch or if I should follow up on our own.
>>>>
>>>> I can rebase and resubmit my patch, it's pretty straightforward.
>>>> The problem was the lack of user in the kernel. And by user I mean
>>>> a driver using these functions. Usually a new function enter in the
>>>> kernel only if there are users for it inside the kernel so if you plan
>>>> to submit a driver using this piece of code, then I see no reason
>>>> to not get it.
>>>
>>> If you add the line
>>>
>>> CLK_OF_DECLARE(fixed_factor_clk, "fixed-factor-clkdiv", 
>>
>> Why did you add the div suffix?
>>
>> There is nothing in the function which prevent to have "mul" greater than
>> "div" and hence having a multiplicative factor.
>>
>> I think that this suffix is misleading.
> 
> You are right, let's remove it.

Great, I am going to send the patch in a couple of minutes.
That means that you will have to ammend your file
arch/arc/boot/dts/abilis_tb10x.dtsi

and for the clock named cpu_clk and ahb_clk you will have to rename
fixed-factor-clkdiv to fixed-factor-clock

Thanks,

> 
>> [...]
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
