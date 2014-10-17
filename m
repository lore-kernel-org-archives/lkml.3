Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaJQJsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:48:04 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:54640 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaJQJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:48:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=iRubshWkv0xj6DDomeR-wdYs3y2QebCgW5u-dvu0J3g@mail.gmail.com>
References: <1413527826-22906-1-git-send-email-keguang.zhang@gmail.com>
	<CAKohpo=iRubshWkv0xj6DDomeR-wdYs3y2QebCgW5u-dvu0J3g@mail.gmail.com>
Date: Fri, 17 Oct 2014 15:18:00 +0530
Message-ID: <CAKohpokYhpTU-SXYuLbGz4TxhhWvring_2PB-CVBWeGjdeeXKA@mail.gmail.com>
Subject: Re: [PATCH V2 6/6] cpufreq: Loongson1: Add cpufreq driver for Loongson1B
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2014 13:47, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 17 October 2014 12:07, Kelvin Cheung <keguang.zhang@gmail.com> wrote:
>> V2:
>>    Use devm_clk_get() instead of clk_get().
>
> Search for a few drivers which have used this API and understand how
> to use it.

To elaborate it a bit further, devm_* routines are there to make our
lives simple.
And they do it by allowing us to skip error handling.

So in your case because you are doing devm_clk_get(), you don't have to put
the clk on errors or in remove() routine. The device core will do that for you
once the device/driver bond finishes.

Also, what about clk_enable/prepare for these clks? You don't need them ?

--
viresh
