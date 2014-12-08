Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaLHJup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:50:45 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37552 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaLHJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:50:43 -0500
Message-ID: <5485746F.9080102@suse.cz>
Date: Mon, 08 Dec 2014 10:50:39 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Julia Lawall <Julia.Lawall@lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/20] TTY: fix misspelling of current function in string
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>	 <1417980062-25151-7-git-send-email-Julia.Lawall@lip6.fr>	 <548565FC.1020908@suse.cz> <1418030309.31745.37.camel@perches.com>
In-Reply-To: <1418030309.31745.37.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014, 10:18 AM, Joe Perches wrote:
> On Mon, 2014-12-08 at 09:49 +0100, Jiri Slaby wrote:
>> On 12/07/2014, 08:20 PM, Julia Lawall wrote:
>>> Replace the last argument of serial_paranoia_check by the actual function
>>> name.
> []
>>> diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
> []
>>> @@ -931,7 +931,7 @@ static void rs_send_xchar(struct tty_struct *tty, char ch)
>>>  	struct serial_state *info = tty->driver_data;
>>>          unsigned long flags;
>>>  
>>> -	if (serial_paranoia_check(info, tty->name, "rs_send_char"))
>>> +	if (serial_paranoia_check(info, tty->name, "rs_send_xchar"))
>>
>> I wonder, why not to use __func__ here too?
> 
> Nearly identical functions are used in amiserial and cyclades.

And I would bet more. They are mostly copy&paste drivers.

> Disabled in amiserial, enabled in cyclades.
> 
> It might be better to add it to some file like
> drivers/tty/debug_utils.h

Oh no, these should better die, not being generalized. But since the
drivers have nearly no users, if some at all, nobody wants to touch the
code.

-- 
js
suse labs
