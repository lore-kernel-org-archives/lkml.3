Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab3BGQCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:02:21 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:36455 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3BGQCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:02:18 -0500
Message-ID: <5113D005.8080809@suse.cz>
Date: Thu, 07 Feb 2013 17:02:13 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 05/23] tty: Remove unnecessary re-test of ldisc ref
 count
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>  <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>  <1360095638-6624-6-git-send-email-peter@hurleysoftware.com>  <5113C566.2060403@suse.cz> <1360252777.4102.42.camel@thor.lan>
In-Reply-To: <1360252777.4102.42.camel@thor.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 04:59 PM, Peter Hurley wrote:
> On Thu, 2013-02-07 at 16:16 +0100, Jiri Slaby wrote:
>> On 02/05/2013 09:20 PM, Peter Hurley wrote:
>>> +	char cur_n[TASK_COMM_LEN], tty_n[64];
>>> +	long timeout = 3 * HZ;
>>> +
>>> +	if (tty->ldisc) {	/* Not yet closed */
>>> +		tty_unlock(tty);
>>> +
>>> +		while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
>>> +			timeout = MAX_SCHEDULE_TIMEOUT;
>>> +			printk_ratelimited(KERN_WARNING
>>> +				"%s: waiting (%s) for %s took too long, but we keep waiting...\n",
>>> +				__func__, get_task_comm(cur_n, current),
>>> +				tty_name(tty, tty_n));
>>>  		}
>>> -		break;
>>> +		/* must reacquire both locks and preserve lock order */
>>> +		mutex_unlock(&tty->ldisc_mutex);
>>> +		tty_lock(tty);
>>> +		mutex_lock(&tty->ldisc_mutex);
>>>  	}
>>>  	return !!(tty->ldisc);
>                    ^^^^^^^^^^^^
>                still want me to fix this though?

It's not worth it. It's up to you.

-- 
js
suse labs
