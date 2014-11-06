Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaKFGjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 01:39:52 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:36895 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaKFGjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 01:39:49 -0500
X-Original-SENDERIP: 10.177.242.33
X-Original-MAILFROM: hugh.kang@lge.com
Message-ID: <545B17B3.4060901@lge.com>
Date: Thu, 06 Nov 2014 15:39:47 +0900
From: Hugh Kang <hugh.kang@lge.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        jonghoon.park@lge.com
Subject: Re: [PATCH] regulator: adding disable options for regulator-always-on
 and regulator-boots-on
References: <1414978003-20437-1-git-send-email-hugh.kang@lge.com> <20141103120313.GC3815@sirena.org.uk> <54588C3B.9070605@lge.com> <20141104195640.GW3815@sirena.org.uk>
In-Reply-To: <20141104195640.GW3815@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014년 11월 05일 04:56, Mark Brown wrote:
> On Tue, Nov 04, 2014 at 05:20:11PM +0900, Hugh Kang wrote:
>
> Please fix your mailer to word wrap within paragraphs.
>
>> I understand that I could make Rev.B with b.dtsi due to LDOs option is
>> different. However, aim to use device tree is that making easy steps.
>> Refer to dts option, if you set to be set status disabled option, the
>> driver dose not probe when the system boot up. Even though, the system
>> has different board revision exist. So dts have to be no corrupts any
>> overlap situation.
> Right, nothing is going to be perfect but equally if we use this sort of
> override property to do things it then becomes harder to read the DT for
> the system since you can't trust that a property you see in one file
> won't be overridden by another file somewhere else.  This can happen to
> an extent already but normally not and it doesn't seem like a pattern we
> want to encourage.
>
>> I have mentions the simple example to change only one LDOs. However,
>> if someone want to edit many regulators with similar configuration, he
>> has to do lots of copy and paste works. Because he has to create new
>> dts file. So I would suggest to make it as simple as I could.
> Sure, but that's purely mechanical and very easy to review - you can do
> a code motion patch to split the bits of DT out then start changing
> things, and you can still keep the common paramters in the core file.
>
>> Also, I have somehow agree with you that affects any boolean property in the DT.
> This is a big one for me - it's going to be both time consuming and
> complex to add this sort of thing for more properties and we do get
> into complexity things if each individual property and its override
> has to be handled by hand.
Thank you for advising. I would take another way to apply it.
Also, I would like to say thanks to Krzysztof, giving me a advice.

