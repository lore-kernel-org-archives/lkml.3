Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228AbaALVlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 16:41:04 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36003 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALVlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 16:41:02 -0500
Message-ID: <52D30BF7.90107@kernel.org>
Date: Sun, 12 Jan 2014 21:41:11 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Peter Meerwald <pmeerw@pmeerw.net>
CC: pali.rohar@gmail.com, pavel@ucw.cz, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] iio: tsl2563: Initialize channels
References: <1389556464-692-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <alpine.DEB.2.01.1401122150210.9334@pmeerw.net> <52D30444.5070800@gmail.com>
In-Reply-To: <52D30444.5070800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/01/14 21:08, Ivaylo Dimitrov wrote:
> On 12.01.2014 22:55, Peter Meerwald wrote:
>>
>> I think the fix should rather be
>>
>>     if (chan->channel2 == IIO_MOD_LIGHT_BOTH)
>>         chip->calib0 = calib_from_sysfs(val);
>>     else if (chan->channel2 == IIO_MOD_LIGHT_IR)
>>         chip->calib1 = calib_from_sysfs(val);
>>     else
>>         return -EINVAL;
>>
>> since only the INTENSITY channels have a CALIBSCALE info
>>
>> the light channel incorrectly sets .indexed = 1 and .channel = 0 which
>> should be unnecessary since there is only one IIO_LIGHT channel
>>
>> regards, p.
>>
>
> I thought so when I was preparing the patch, but unfortunately couldn't find any documentation for iio subsystem structs and defines, besides what is in the header files (and it is not very descriptive), so I took the easy route.
>
> However, I'll send a new patch with the above (and a little more) changes.
Leave the indexed bit alone.  Whilst unnecessary it is fine within the ABI
and changing it would be a userspace ABI change.

Otherwise, as described by Peter will be fine.

Jonathan
>
> Thanks,
> Ivo
>
