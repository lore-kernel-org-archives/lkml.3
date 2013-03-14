Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3CNKd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:33:58 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55770 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3CNKdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:33:55 -0400
Message-ID: <5141A646.2060406@gmail.com>
Date: Thu, 14 Mar 2013 14:28:22 +0400
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] wait while adding MMC host to ensure root mounts
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com> <20130314024719.GA9342@kroah.com>
In-Reply-To: <20130314024719.GA9342@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/13 06:47, Greg Kroah-Hartman wrote:
> On Thu, Mar 14, 2013 at 05:06:23AM +0400, Sergey Yanovich wrote:
>>   	/* wait for the known devices to complete their probing */
>> -
>>   	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
>
> You didn't need to change this file, please don't.

Got the point.

>>   	mmc_detect_change(host, 0);
>> +	mmc_flush_scheduled_work();
>
> If this is the only fix, then you don't need to change it from being
> static or need to export it.
>
> Please be more careful when making kernel patches.

I will. I apologize for spamming.
