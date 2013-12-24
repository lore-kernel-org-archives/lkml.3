Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3LXFFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 00:05:48 -0500
Received: from churchofgit.com ([198.20.106.155]:41808 "EHLO
	www.churchofgit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3LXFFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 00:05:47 -0500
Message-ID: <4051ac2a919c34e44113669e84ca7e8b.squirrel@localhost>
In-Reply-To: <20131213023239.GA15130@kroah.com>
References: <1386086125-1865-1-git-send-email-shawn@churchofgit.com>
    <20131213023239.GA15130@kroah.com>
Date: Tue, 24 Dec 2013 05:04:54 -0000
Subject: Re: [PATCH] tty: only print sysrq help for handlers that are
 enabled
From: shawn@churchofgit.com
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: "Shawn Landden" <shawn@churchofgit.com>, "Jiri Slaby" <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.23 [SVN]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Dec 03, 2013 at 07:55:25AM -0800, Shawn Landden wrote:
>> Also print out a notice when sysrq is in selective mode.
>>
>> Signed-off-by: Shawn Landden <shawn@churchofgit.com>
>> ---
>>  drivers/tty/sysrq.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
>> index ce396ec..4eee0e4 100644
>> --- a/drivers/tty/sysrq.c
>> +++ b/drivers/tty/sysrq.c
>> @@ -548,9 +548,14 @@ void __handle_sysrq(int key, bool check_mask)
>>  					;
>>  				if (j != i)
>>  					continue;
>> -				printk("%s ", sysrq_key_table[i]->help_msg);
>> +				/* only print if handler is enabled */
>> +				if (sysrq_enabled & 1 ||
>> +				    sysrq_enabled & sysrq_key_table[i]->enable_mask)
>> +					printk("%s ", sysrq_key_table[i]->help_msg);
>>  			}
>>  		}
>> +		if (!(sysrq_enabled & 1))
>> +			printk("(some options are disabled)");
>>  		printk("\n");
>>  		console_loglevel = orig_log_level;
>>  	}
>
> What exactly is this fixing?  What is broken here that this change
> resolves?  Where is it applicable?  I need a lot more context here
> please.

Without this patch you get something like
re[b]oot [r]aw [s]ync [h]elp ....
even if none of these sysrq triggers are available because of the setting
mask of
kernel.sysrq
With this patch then if (e.g.)
kernel.sysrq = 16
then you will only see
[s]ync
i.e. those commands you have privilege to issue via sysrq keypresses.
Contact me if you need more,
Shawn
>
> thanks,
>
> greg k-h
>


