Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3HEQTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:19:21 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:1484 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817Ab3HEQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:19:19 -0400
X-IronPort-AV: E=Sophos;i="4.89,819,1367964000"; 
   d="scan'208";a="28556013"
Date: Mon, 5 Aug 2013 18:19:18 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, corbet@lwn.net,
        m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: adjust code alignment
In-Reply-To: <20130805160645.GI5051@mwanda>
Message-ID: <alpine.DEB.2.02.1308051810360.2134@hadrien>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr> <1375714059-29567-5-git-send-email-Julia.Lawall@lip6.fr> <20130805160645.GI5051@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Aug 2013, Dan Carpenter wrote:

> On Mon, Aug 05, 2013 at 04:47:39PM +0200, Julia Lawall wrote:
>> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
>> index e8a1ce2..4a5a5dc 100644
>> --- a/drivers/media/i2c/ov7670.c
>> +++ b/drivers/media/i2c/ov7670.c
>> @@ -1369,8 +1369,8 @@ static int ov7670_s_exp(struct v4l2_subdev *sd, int value)
>>  	unsigned char com1, com8, aech, aechh;
>>
>>  	ret = ov7670_read(sd, REG_COM1, &com1) +
>> -		ov7670_read(sd, REG_COM8, &com8);
>> -		ov7670_read(sd, REG_AECHH, &aechh);
>> +	ov7670_read(sd, REG_COM8, &com8);
>> +	ov7670_read(sd, REG_AECHH, &aechh);
>>  	if (ret)
>>  		return ret;
>>
>
> The new indenting isn't correct here and anyway the intent was to
> combine all the error codes together and return them as an error
> code jumble.  I'm not a fan of error code jumbles, probably the
> right thing is to check each function call or, barring that, to
> return -EIO.

Oops, thanks for spotting that.  I'm not sure whether it is safe to abort 
these calls as soon as the first one fails, but perhaps I could introduce 
some more variables, and test them all afterwards.

What should I do with the big patch?  Resend it with this cut out?  Or, 
considering that I might have overlooked something else, send 90 some 
little ones?

thanks,
julia
