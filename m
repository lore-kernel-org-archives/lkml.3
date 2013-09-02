Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3IBBVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 21:21:07 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49577 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab3IBBVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 21:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130830123057.GK20329@zurbaran>
References: <1376875675-11286-1-git-send-email-chao.xie@marvell.com>
	<1376875675-11286-2-git-send-email-chao.xie@marvell.com>
	<20130820014042.GF13324@zurbaran>
	<CADApbehFDH2-vJMHuVPq8i+zR0fm4ii36JNB_CEKaYEx0r23zw@mail.gmail.com>
	<20130830123057.GK20329@zurbaran>
Date: Mon, 2 Sep 2013 09:21:04 +0800
Message-ID: <CADApbej6Tp6dCQOTBdRZY7UH70AtGuAKMPP2gy+TXWsC08hHJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: 88pm800: Fix the bug that pdata may be NULL
From: Chao Xie <xiechao.mail@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Chao Xie <chao.xie@marvell.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 8:30 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Xie,
>
> On Tue, Aug 27, 2013 at 02:11:58PM +0800, Chao Xie wrote:
>> On Tue, Aug 20, 2013 at 9:40 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>> > Hi Xie,
>> >
>> > On Sun, Aug 18, 2013 at 09:27:54PM -0400, Chao Xie wrote:
>> >> User pass platform data to device, and platform data may be
>> >> NULL.
>> > In which case do you get that ? With DT ?
>> > Should rtc_init fail when pdata is NULL ?
>> >
>> > You need to explain that, be it only for us to know if it's a critical
>> > fix or not.
>> >
>> Sorry for late response.
>> If pdata is NULL, the driver will fail.
> The question is: Why would pdata be NULL ? If there's a fundamental
> issue you're hiding with this patch, you probably want to fix the real
> problem instead.
>
Maybe i do not explain it clearly.
The error is detected y some software checking tool.
Pdata is passed from dev->platform_data.
If the user pass the dev->platform_data to be NULL, at least mfd device driver
need detect it, and reject it if it is not accpetable like return -EINVAL.
Then the following probing code will not cause kernel panic if we
access pdata->xxx.

> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
