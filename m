Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3BWQkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 11:40:52 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47940 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3BWQkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 11:40:49 -0500
MIME-Version: 1.0
In-Reply-To: <5127AA9E.9030008@linaro.org>
References: <51257FFF.3070109@linaro.org>
	<51266897.9070308@linaro.org>
	<51271673.9090003@linaro.org>
	<5127AA9E.9030008@linaro.org>
Date: Sat, 23 Feb 2013 22:10:48 +0530
Message-ID: <CAHbNUh0U=vFXs7p5REPZ79DR+Pi4oAHkrQRD3sfY2e-infv4DQ@mail.gmail.com>
Subject: Re: Origen board hang with functionfs
From: Tushar Behera <tushar.behera@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 22:57, John Stultz <john.stultz@linaro.org> wrote:
>
> On 02/21/2013 10:55 PM, Tushar Behera wrote:
>>
>>
>> I think the issue is because of the USB phy regulators. LDO3 and LDO8
>> power the phy regulators for OTG and HOST. These regulators are disabled
>> in OTG probe whereas they are not handled at all in HOST driver. Keeping
>> these LDOs always active should solve the problem for the time being.
>>
>> I will follow-up with a patch shortly. But I am not sure if this patch
>> will be considered for mainline as board patches are not getting
>> accepted these days.
>
>
> So your patch worked great for me! Thanks for the analysis and the patch!
>
> In the above, do you mean board-patches aren't getting accepted since the
> 3.9 merge window is already open, or that folks aren't accepting board
> patches at all?
>

As the board file may eventually be removed within 1-2 kernel
releases, maintainers are
not very keen in accepting new board patches. I will check if the
issue persists with DT
based system and submit related patch after the merge window.

> thanks
> -john
>



--
Tushar Behera
