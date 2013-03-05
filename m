Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3CEUeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:34:01 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54081 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3CEUeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:34:00 -0500
Date: Tue, 05 Mar 2013 15:33:58 -0500 (EST)
Message-Id: <20130305.153358.503062411029894196.davem@davemloft.net>
To: jslaby@suse.cz
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <5136554F.3060006@suse.cz>
References: <51364B31.1010808@suse.cz>
	<20130305.150338.470704111422696046.davem@davemloft.net>
	<5136554F.3060006@suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 12:34:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Tue, 05 Mar 2013 21:27:59 +0100

> On 03/05/2013 09:03 PM, David Miller wrote:
>> From: Jiri Slaby <jslaby@suse.cz>
>> Date: Tue, 05 Mar 2013 20:44:49 +0100
>> 
>>> Hi, I must admit I don't understand. I now checked both of them and they
>>> call uart_handle_sysrq_char unconditionally, or?
>> 
>> Nope, in the sunsab.c receive function, we used to handle the SYSRQ
>> stuff before break checking when TTY is NULL, now we don't.
> 
> But how could tty be NULL in there? subsab enables interrupts after the
> TTY is open and disables before it is closed/hupped. So the tty couldn't
> be NULL there, right?

TTY is NULL until bootup and SYSRQ works perfectly fine during this
time when sunsab is the console, which via sunsab_console_setup()
invokes sunsab_startup() which requests the IRQ.
