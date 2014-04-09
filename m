Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbaDINxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:53:55 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:58077 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaDINxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:53:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140409113904.GE4912@mwanda>
References: <2039876.xlVvlD6iFL@daeseok-laptop.cloud.net>
	<20140409113904.GE4912@mwanda>
Date: Wed, 9 Apr 2014 22:53:52 +0900
Message-ID: <CAHb8M2Dy3uKe9Vm05wR5VNFj7qYjw1Z_+Qic6O4HVHdzsu0amQ@mail.gmail.com>
Subject: Re: [PATCH] staging: speakup: fix misuse of kstrtol() in handle_goto()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org,
        devel@driverdev.osuosl.org, grygorii.strashko@ti.com,
        lisa@xenapiadmin.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-09 20:39 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Apr 09, 2014 at 07:45:46PM +0900, Daeseok Youn wrote:
>>
>> A string of goto_buf has a number followed by x or y.
>> e.g. "3x" means move 3 lines down.
>> The kstrtol() returns an error(-EINVAL) with this string so
>> go_pos has unsigned a value of that error.
>> And also "*cp" has not expected value.
>>
>
> Good catch.  This was introduced when we changed the simple_strtoul() to
> kstrtol().

Thanks! :-)

>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> Did you find this bug by testing or through reading the code?
Actually, I couldn't test. I have looked the code for checking sparse
warnings and found this bug.

Regards,
Daeseok Youn

>
> regards,
> dan carpenter
>
>
