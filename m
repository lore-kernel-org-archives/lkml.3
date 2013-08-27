Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3H0GL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:11:59 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:58246 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab3H0GL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:11:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130820014042.GF13324@zurbaran>
References: <1376875675-11286-1-git-send-email-chao.xie@marvell.com>
	<1376875675-11286-2-git-send-email-chao.xie@marvell.com>
	<20130820014042.GF13324@zurbaran>
Date: Tue, 27 Aug 2013 14:11:58 +0800
Message-ID: <CADApbehFDH2-vJMHuVPq8i+zR0fm4ii36JNB_CEKaYEx0r23zw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: 88pm800: Fix the bug that pdata may be NULL
From: Chao Xie <xiechao.mail@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Chao Xie <chao.xie@marvell.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 9:40 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Xie,
>
> On Sun, Aug 18, 2013 at 09:27:54PM -0400, Chao Xie wrote:
>> User pass platform data to device, and platform data may be
>> NULL.
> In which case do you get that ? With DT ?
> Should rtc_init fail when pdata is NULL ?
>
> You need to explain that, be it only for us to know if it's a critical
> fix or not.
>
Sorry for late response.
If pdata is NULL, the driver will fail. So the error check should be done at
the beginning of probe.
If (!pdata)
   return -EINVAL;

Is that OK?

> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
