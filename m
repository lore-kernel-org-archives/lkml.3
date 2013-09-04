Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771Ab3IDJ62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:58:28 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33846 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934478Ab3IDJ60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:58:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130904094159.GD20150@lee--X1>
References: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
	<20130904094159.GD20150@lee--X1>
Date: Wed, 4 Sep 2013 15:28:25 +0530
Message-ID: <CAK9yfHwDRP+WV_RWGhuw=8uZEBKVFqLQucVdhQnP20s9YvBsRw@mail.gmail.com>
Subject: Re: [PATCH 1/4] ab8500-charger: Check return value of regulator_enable
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, anton@enomsg.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2013 15:11, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, 02 Sep 2013, Sachin Kamat wrote:
>
>> Check the return value of regulator_enable to silence the following
>> type of warnings:
>> drivers/power/ab8500_charger.c:1390:20: warning: ignoring return value
>> of ‘regulator_enable’, declared with attribute warn_unused_result
>> [-Wunused-result]
>
> I think I remember something about it being okay for the regulators to
> fail, but that may have been something else. I think I'd be more
> comfortable if we just raised a dev_warn() and didn't return early in
> the error case.

In this particular case the regulator seems to be mandatory as they error out if
regulator_get() fails. Also, the comment above regulator_enable() said
the enabling
was done to fix some bug. Hence I wasn't sure if we could just print a
warning message
and continue further upon failure. I will change it as per your
suggestion and re-spin the patches.

-- 
With warm regards,
Sachin
