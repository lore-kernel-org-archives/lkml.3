Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaKDIUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:20:16 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:54848 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaKDIUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:20:14 -0500
X-Original-SENDERIP: 10.177.242.33
X-Original-MAILFROM: hugh.kang@lge.com
Message-ID: <54588C3B.9070605@lge.com>
Date: Tue, 04 Nov 2014 17:20:11 +0900
From: Hugh Kang <hugh.kang@lge.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        jonghoon.park@lge.com
Subject: Re: [PATCH] regulator: adding disable options for regulator-always-on
 and regulator-boots-on
References: <1414978003-20437-1-git-send-email-hugh.kang@lge.com> <20141103120313.GC3815@sirena.org.uk>
In-Reply-To: <20141103120313.GC3815@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On 2014년 11월 03일 21:03, Mark Brown wrote:
> On Mon, Nov 03, 2014 at 10:26:43AM +0900, Hugh Kang wrote:
>> From: "hugh.kang" <hugh.kang@lge.com>
>>
>> If a regulator is set by always-on option, the regulator will be set forever.
>> For example, suppose LDO1 is set to always-on at RevA.dts with including of a.dtsi. After that
>> RevB.dts may wants to include the same a.dtsi but override the LDO1 always-on option. However,
>> currently there is no way to delete the always-on option, even when we change the LDO1 option value,
>> the always-on setting is still remains.
> This sounds like a problem with the way the DTSs have been written - I'd
> expect the thing to do here is just to move the property to the rev A
> DTS when rev B is created.  Why is that not the way forward?
>
> Otherwise this is an issue which affects any boolean property in the DT
> so if it's something we need to fix we should be fixing it in a generic
> fashion that will work for other properties too.

I understand that I could make Rev.B with b.dtsi due to LDOs option is different. However, aim to use device tree is that making easy steps. Refer to dts option, if you set to be set status disabled option, the driver dose not probe when the system boot up. Even though, the system has different board revision exist. So dts have to be no corrupts any overlap situation.
I have mentions the simple example to change only one LDOs. However, if someone want to edit many regulators with similar configuration, he has to do lots of copy and paste works. Because he has to create new dts file. So I would suggest to make it as simple as I could.

Also, I have somehow agree with you that affects any boolean property in the DT.
