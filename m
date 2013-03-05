Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3CEU2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:28:06 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:44094 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3CEU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:28:04 -0500
Message-ID: <5136554F.3060006@suse.cz>
Date: Tue, 05 Mar 2013 21:27:59 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
References: <5135D072.8070101@suse.cz> <20130305.143940.1976678289652676624.davem@davemloft.net> <51364B31.1010808@suse.cz> <20130305.150338.470704111422696046.davem@davemloft.net>
In-Reply-To: <20130305.150338.470704111422696046.davem@davemloft.net>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 09:03 PM, David Miller wrote:
> From: Jiri Slaby <jslaby@suse.cz>
> Date: Tue, 05 Mar 2013 20:44:49 +0100
> 
>> Hi, I must admit I don't understand. I now checked both of them and they
>> call uart_handle_sysrq_char unconditionally, or?
> 
> Nope, in the sunsab.c receive function, we used to handle the SYSRQ
> stuff before break checking when TTY is NULL, now we don't.

But how could tty be NULL in there? subsab enables interrupts after the
TTY is open and disables before it is closed/hupped. So the tty couldn't
be NULL there, right?

-- 
js
suse labs
