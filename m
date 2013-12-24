Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3LXMn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:43:59 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35195 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750964Ab3LXMn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:43:58 -0500
Message-ID: <52B9818A.2060402@hurleysoftware.com>
Date: Tue, 24 Dec 2013 07:43:54 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: shawn@churchofgit.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: only print sysrq help for handlers that are enabled
References: <1386086125-1865-1-git-send-email-shawn@churchofgit.com>    <20131213023239.GA15130@kroah.com> <4051ac2a919c34e44113669e84ca7e8b.squirrel@localhost>
In-Reply-To: <4051ac2a919c34e44113669e84ca7e8b.squirrel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2013 12:04 AM, shawn@churchofgit.com wrote:
>> On Tue, Dec 03, 2013 at 07:55:25AM -0800, Shawn Landden wrote:
>>> Also print out a notice when sysrq is in selective mode.
>>>
>>> Signed-off-by: Shawn Landden <shawn@churchofgit.com>
>>> ---
>>>   drivers/tty/sysrq.c | 7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
>>> index ce396ec..4eee0e4 100644
>>> --- a/drivers/tty/sysrq.c
>>> +++ b/drivers/tty/sysrq.c
>>> @@ -548,9 +548,14 @@ void __handle_sysrq(int key, bool check_mask)
>>>   					;
>>>   				if (j != i)
>>>   					continue;
>>> -				printk("%s ", sysrq_key_table[i]->help_msg);
>>> +				/* only print if handler is enabled */
>>> +				if (sysrq_enabled & 1 ||
>>> +				    sysrq_enabled & sysrq_key_table[i]->enable_mask)
>>> +					printk("%s ", sysrq_key_table[i]->help_msg);
>>>   			}
>>>   		}
>>> +		if (!(sysrq_enabled & 1))
>>> +			printk("(some options are disabled)");
>>>   		printk("\n");
>>>   		console_loglevel = orig_log_level;
>>>   	}
>>
>> What exactly is this fixing?  What is broken here that this change
>> resolves?  Where is it applicable?  I need a lot more context here
>> please.
>
> Without this patch you get something like
> re[b]oot [r]aw [s]ync [h]elp ....
> even if none of these sysrq triggers are available because of the setting
> mask of
> kernel.sysrq
> With this patch then if (e.g.)
> kernel.sysrq = 16
> then you will only see
> [s]ync
> i.e. those commands you have privilege to issue via sysrq keypresses.
> Contact me if you need more,
> Shawn

But all operations are enabled when triggered via /proc/sysrq-trigger.
How about indicating key-disabled operations with a symbol instead?

Regards,
Peter Hurley

