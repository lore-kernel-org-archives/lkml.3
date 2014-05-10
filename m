Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaEJJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 05:09:56 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:46613 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaEJJJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 05:09:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140506084749.GT26890@mwanda>
References: <1399364528-3727-1-git-send-email-martink@posteo.de>
	<20140506084749.GT26890@mwanda>
Date: Sat, 10 May 2014 02:09:52 -0700
X-Google-Sender-Auth: g9kBryiU01KX9O_tehmQ3L8kaVs
Message-ID: <CANeU7Qkpg3_mYEYqZpT2zy__6z0q8KDNB=gDH9oMY8UtQNu0+Q@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8192u: initialize array in C compliant way
From: Christopher Li <sparse@chrisli.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Martin Kepplinger <martink@posteo.de>,
        Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>, burzalodowa@gmail.com,
        Linux-Sparse <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 1:47 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
>> index 426f223..c96dbab 100644
>> --- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
>> +++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
>> @@ -241,7 +241,7 @@ static PTS_COMMON_INFO SearchAdmitTRStream(struct ieee80211_device *ieee,
>>  {
>>       //DIRECTION_VALUE       dir;
>>       u8      dir;
>> -     bool                            search_dir[4] = {0, 0, 0, 0};
>> +     bool                            search_dir[4] = {0};
>
> That's weird.  The original code is valid but it generates a sparse
> warning.

Sorry for the late reply. I see what is going on already. The bits_to_bytes()
function is buggy for bool type. Bool is the only type has bits less than 8.
It truncates the bool byte size to 0. As a result, the array layout function
convert_index() always set the expr->init_offset to 0 for bool type:

"e->init_offset = from * bits_to_bytes(e->ctype->bit_size);"

Chris
