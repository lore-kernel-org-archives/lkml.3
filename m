Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaAaKT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:19:28 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:63916 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaAaKT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:19:27 -0500
Message-ID: <52EB78A9.4020306@gmail.com>
Date: Fri, 31 Jan 2014 11:19:21 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/21] pinctrl: mvebu: dove: provide generic mpp callbacks
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com> <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com> <1390869573-27624-10-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkdYpGm-KAFqU5cpzbhrM1NaZJYtQa86wP7qJFrai2bDYbw@mail.gmail.com>
In-Reply-To: <CACRpkdYpGm-KAFqU5cpzbhrM1NaZJYtQa86wP7qJFrai2bDYbw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/14 11:13, Linus Walleij wrote:
> On Tue, Jan 28, 2014 at 1:39 AM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
>
>> We want to get rid of passing register addresses to common pinctrl
>> driver, so provide set/get callbacks for generic mpp pins.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
[...]
>> @@ -374,7 +398,7 @@ static struct mvebu_mpp_ctrl dove_mpp_controls[] = {
>>          MPP_FUNC_CTRL(13, 13, "mpp13", dove_pmu_mpp_ctrl),
>>          MPP_FUNC_CTRL(14, 14, "mpp14", dove_pmu_mpp_ctrl),
>>          MPP_FUNC_CTRL(15, 15, "mpp15", dove_pmu_mpp_ctrl),
>> -       MPP_REG_CTRL(16, 23),
>> +       MPP_FUNC_CTRL(16, 23, NULL, dove_mpp_ctrl),
>
> What does this have to do with the rest of the patch?
>
> (Maybe I'm stupid, beware I'm just glancing over this stuff as I
> see the patch set is still in development.)

Not really, the driver is slightly misdesigned and this patches
try to clean this up a bit. I have prepared a v3 branch for the
MVEBU guys to have a look at first.

Short version: Thanks for trying to review this, but I guess your time
would be better spent on a soon to be posted v3.

Long version:
Not having a callback identifies each control as "generic mpp pins",
so by passing a callback we make them "SoC specific" as a preparation
to remove the common "generic mpp" set/get function.

Sebastian

