Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3HEQb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:31:27 -0400
Received: from mx01-sz.bfs.de ([194.94.69.67]:45566 "EHLO mx01-sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab3HEQbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:31:23 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 12:31:23 EDT
Message-ID: <51FFD1CB.4080907@bfs.de>
Date: Mon, 05 Aug 2013 18:24:43 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Dan Carpenter <dan.carpenter@oracle.com>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, corbet@lwn.net, m.chehab@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: adjust code alignment
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr> <1375714059-29567-5-git-send-email-Julia.Lawall@lip6.fr> <20130805160645.GI5051@mwanda> <alpine.DEB.2.02.1308051810360.2134@hadrien>
In-Reply-To: <alpine.DEB.2.02.1308051810360.2134@hadrien>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Julia,

IMHO keep the patch as it is.
It does not change any code that is good.
Suspicious code that comes up here can be addressed
in a separate patch.

just my 2 cents,
re,
 wh

Am 05.08.2013 18:19, schrieb Julia Lawall:
> On Mon, 5 Aug 2013, Dan Carpenter wrote:
> 
>> On Mon, Aug 05, 2013 at 04:47:39PM +0200, Julia Lawall wrote:
>>> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
>>> index e8a1ce2..4a5a5dc 100644
>>> --- a/drivers/media/i2c/ov7670.c
>>> +++ b/drivers/media/i2c/ov7670.c
>>> @@ -1369,8 +1369,8 @@ static int ov7670_s_exp(struct v4l2_subdev *sd,
>>> int value)
>>>      unsigned char com1, com8, aech, aechh;
>>>
>>>      ret = ov7670_read(sd, REG_COM1, &com1) +
>>> -        ov7670_read(sd, REG_COM8, &com8);
>>> -        ov7670_read(sd, REG_AECHH, &aechh);
>>> +    ov7670_read(sd, REG_COM8, &com8);
>>> +    ov7670_read(sd, REG_AECHH, &aechh);
>>>      if (ret)
>>>          return ret;
>>>
>>
>> The new indenting isn't correct here and anyway the intent was to
>> combine all the error codes together and return them as an error
>> code jumble.  I'm not a fan of error code jumbles, probably the
>> right thing is to check each function call or, barring that, to
>> return -EIO.
> 
> Oops, thanks for spotting that.  I'm not sure whether it is safe to
> abort these calls as soon as the first one fails, but perhaps I could
> introduce some more variables, and test them all afterwards.
> 
> What should I do with the big patch?  Resend it with this cut out?  Or,
> considering that I might have overlooked something else, send 90 some
> little ones?
> 
> thanks,
> julia
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
