Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaCXTAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:00:00 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:44234 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbaCXS76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:59:58 -0400
Message-ID: <533080AB.9080702@acm.org>
Date: Mon, 24 Mar 2014 13:59:55 -0500
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Tomas Cech <tcech@suse.cz>, openipmi-developer@lists.sourceforge.net,
        Rocky Craig <rocky.craig@hp.com>
Subject: Re: [PATCH 1/1] Char: ipmi_bt_sm, fix infinite loop
References: <1393323294-11423-1-git-send-email-jslaby@suse.cz> <530D1021.1050402@acm.org> <533023F5.40909@suse.cz>
In-Reply-To: <533023F5.40909@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2014 07:24 AM, Jiri Slaby wrote:
> On 02/25/2014 10:50 PM, Corey Minyard wrote:
>> Looks right to me.  Rocky, copying you in case there's an issue with this.
> Hi,
>
> any updates here, I don't see it in the -next tree yet?
>
> Thanks.

I normally don't submit to the -next tree because there is little to
integrate with in the IPMI driver.  Maybe it would be a good idea to
start, though.  If you want to, I can.

Thanks,

-corey

>> On 02/25/2014 04:14 AM, Jiri Slaby wrote:
>>> In read_all_bytes, we do
>>>   unsigned char i;
>>> ...
>>>   bt->read_data[0] = BMC2HOST;
>>>   bt->read_count = bt->read_data[0];
>>> ...
>>>   for (i = 1; i <= bt->read_count; i++)
>>>     bt->read_data[i] = BMC2HOST;
>>>
>>> If bt->read_data[0] == bt->read_count == 255, we loop infinitely in
>>> the 'for' loop. Make 'i' an 'int' instead of 'char' to get rid of the
>>> overflow and finish the loop after 255 iterations every time.
>>>
>>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>>> Reported-and-debugged-by: Rui Hui Dian <rhdian@novell.com>
>>> Cc: Tomas Cech <tcech@suse.cz>
>>> Cc: Corey Minyard <minyard@acm.org>
>>> Cc: <openipmi-developer@lists.sourceforge.net>
>>> ---
>>>  drivers/char/ipmi/ipmi_bt_sm.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
>>> index f5e4cd7617f6..61e71616689b 100644
>>> --- a/drivers/char/ipmi/ipmi_bt_sm.c
>>> +++ b/drivers/char/ipmi/ipmi_bt_sm.c
>>> @@ -352,7 +352,7 @@ static inline void write_all_bytes(struct si_sm_data *bt)
>>>  
>>>  static inline int read_all_bytes(struct si_sm_data *bt)
>>>  {
>>> -	unsigned char i;
>>> +	unsigned int i;
>>>  
>>>  	/*
>>>  	 * length is "framing info", minimum = 4: NetFn, Seq, Cmd, cCode.
>

