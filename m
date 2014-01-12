Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbaALVIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 16:08:32 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48508 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALVIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 16:08:30 -0500
Message-ID: <52D30444.5070800@gmail.com>
Date: Sun, 12 Jan 2014 23:08:20 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Meerwald <pmeerw@pmeerw.net>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: jic23@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] iio: tsl2563: Initialize channels
References: <1389556464-692-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <alpine.DEB.2.01.1401122150210.9334@pmeerw.net>
In-Reply-To: <alpine.DEB.2.01.1401122150210.9334@pmeerw.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.2014 22:55, Peter Meerwald wrote:
>
> I think the fix should rather be
>
> 	if (chan->channel2 == IIO_MOD_LIGHT_BOTH)
> 		chip->calib0 = calib_from_sysfs(val);
> 	else if (chan->channel2 == IIO_MOD_LIGHT_IR)
> 		chip->calib1 = calib_from_sysfs(val);
> 	else
> 		return -EINVAL;
>
> since only the INTENSITY channels have a CALIBSCALE info
>
> the light channel incorrectly sets .indexed = 1 and .channel = 0 which
> should be unnecessary since there is only one IIO_LIGHT channel
>
> regards, p.
>

I thought so when I was preparing the patch, but unfortunately couldn't 
find any documentation for iio subsystem structs and defines, besides 
what is in the header files (and it is not very descriptive), so I took 
the easy route.

However, I'll send a new patch with the above (and a little more) changes.

Thanks,
Ivo

