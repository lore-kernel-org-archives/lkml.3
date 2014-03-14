Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaCNLgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:36:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39274 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbaCNLgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:36:14 -0400
Message-ID: <5322E9CC.9060602@gmail.com>
Date: Fri, 14 Mar 2014 12:36:44 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ARM: dts: berlin2q: add the Marvell Armada 1500
 pro
References: <1394719607-25018-1-git-send-email-antoine.tenart@free-electrons.com> <1394719607-25018-2-git-send-email-antoine.tenart@free-electrons.com> <5322CC8B.6010905@gmail.com> <20140314113202.GB3106@piout.net>
In-Reply-To: <20140314113202.GB3106@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 12:32 PM, Alexandre Belloni wrote:
> On 14/03/2014 at 10:31:55 +0100, Sebastian Hesselbarth wrote :
>> On 03/13/2014 03:06 PM, Antoine Ténart wrote:
>>> +		local-timer@ad0600 {
>>> +			compatible = "arm,cortex-a9-twd-timer";
>>> +			reg = <0xad0600 0x20>;
>>> +			clocks = <&sysclk>;
>>
>> If I understand Jisheng correctly, this should be cpuclk/3. When
>> removing the clocks {} container above, please also take care of
>> it.
>>
>
> You understood correctly
>
>> You can do
>>
>> cpuclk: cpu-clock {
>> 	compatible = "fixed-clock";
>> 	#clock-cells = <0>;
>> 	clock-frequency = <1200000000>; /* <- put correct freq here */
>> };
>>
>> sysclk: system-clock {
>> 	compatible = "fixed-factor-clock";
>> 	#clock-cells = <0>;
>> 	clocks = <&cpuclk>;
>> 	clock-multi = <1>;
>> 	clock-div = <3>;
>> };
>>
>> Hopefully, we'll have proper clock drivers soon so we can just replace
>> referenced "fixed-*" clocks.
>>
>
> I'm working on that, do you have some code that you can share right now ?

No, nothing specific. You can have a look at drivers/clk/mvebu/ and see
how we deal with it on mvebu. For now, you can stick with bg2q and I'll
see how we extend that drivers for bg2/bg2cd then.

BTW: We really enjoy having a mvebu subfolder in drivers/clk as it makes
things easier. If you prepare any clk drivers for berlin, I'd suggest to
put them in drivers/clk/berlin from the beginning.

Sebastian

