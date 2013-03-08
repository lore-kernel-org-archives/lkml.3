Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200Ab3CHOps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:45:48 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:37938 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab3CHOpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:45:47 -0500
Message-ID: <5139F9B2.1070909@suse.cz>
Date: Fri, 08 Mar 2013 15:46:10 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] TTY: cleanup tty->hw_stopped uses
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>  <1362658360-26629-10-git-send-email-jslaby@suse.cz> <1362753564.4219.17.camel@thor.lan>
In-Reply-To: <1362753564.4219.17.camel@thor.lan>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 03:39 PM, Peter Hurley wrote:
> On Thu, 2013-03-07 at 13:12 +0100, Jiri Slaby wrote:
>> --- a/drivers/net/caif/caif_serial.c
>> +++ b/drivers/net/caif/caif_serial.c
>> @@ -88,7 +88,6 @@ static inline void update_tty_status(struct ser_device *ser)
>>  {
>>  	ser->tty_status =
>>  		ser->tty->stopped << 5 |
>> -		ser->tty->hw_stopped << 4 |
>>  		ser->tty->flow_stopped << 3 |
>>  		ser->tty->packet << 2 |
>>  		ser->tty->port->low_latency << 1 |
> 
> I would maybe leave this with a code comment instead.
> 
> 		ser->tty->hw_stopped << 4 |      /* hw_stopped is not used by tty layer */

Yeah, maybe...

>> @@ -4256,9 +4251,6 @@ static void seq_line_info(struct seq_file *m, struct e100_serial *info)
>>  		if (info->port.tty->stopped)
>>  			seq_printf(m, " stopped:%i",
>>  				   (int)info->port.tty->stopped);
>> -		if (info->port.tty->hw_stopped)
>> -			seq_printf(m, " hw_stopped:%i",
>> -				   (int)info->port.tty->hw_stopped);
> 
> User-space visible. Tool may expect this field.

I thought that on the first glance too. But look what does that whole
seq_printf depend on.

-- 
js
suse labs
