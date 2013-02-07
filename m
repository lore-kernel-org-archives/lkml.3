Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab3BGPzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:55:54 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:61884 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3BGPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:55:51 -0500
Message-ID: <5113CE82.5070609@suse.cz>
Date: Thu, 07 Feb 2013 16:55:46 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 01/23] tty: Add diagnostic for halted line discipline
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>  <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>  <1360095638-6624-2-git-send-email-peter@hurleysoftware.com>  <5113BF3B.3060307@suse.cz> <1360252434.4102.37.camel@thor.lan>
In-Reply-To: <1360252434.4102.37.camel@thor.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 04:53 PM, Peter Hurley wrote:
>>> +static int tty_ldisc_halt(struct tty_struct *tty)
>>> +{
>>> +	int scheduled;
>>> +	clear_bit(TTY_LDISC, &tty->flags);
>>> +	scheduled = cancel_work_sync(&tty->port->buf.work);
>>> +	set_bit(TTY_LDISC_HALTED, &tty->flags);
>>> +	return scheduled;
>>> +}
>>
>> Why did you move with that function? It makes the patch unnecessarily
>> bigger (and harder for a review).
> 
> 07/23 starts using tty_wait_for_idle() in tty_ldisc_halt().
> 
> Should I split this?

Yes please.

-- 
js
suse labs
