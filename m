Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3CETo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:44:59 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:59918 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3CETo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:44:58 -0500
Message-ID: <51364B31.1010808@suse.cz>
Date: Tue, 05 Mar 2013 20:44:49 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
References: <20130301.164711.326215889038834651.davem@davemloft.net> <20130301.170056.382924644594872197.davem@davemloft.net> <5135D072.8070101@suse.cz> <20130305.143940.1976678289652676624.davem@davemloft.net>
In-Reply-To: <20130305.143940.1976678289652676624.davem@davemloft.net>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 08:39 PM, David Miller wrote:
> From: Jiri Slaby <jslaby@suse.cz>
> Date: Tue, 05 Mar 2013 12:01:06 +0100
> 
>> I left that "if (port->start == NULL)" in sunhv in place because it
>> behaves completely differently. It checks port->start on all paths prior
>> dereferencing it. And it does not stop interrupts on ->shutdown.
> 
> But this code really does care if a TTY is attached, because it wants
> to make sure that SYSRQ handling occurs unconditionally, even if there
> is no TTY to queue the characters to.
> 
> This is critically important during bootup before the initial shell
> is spawned, if you want to do a SYSRQ register dump or reset out of
> a hung boot.
> 
> Whether that test is now ->state == NULL or whatever, the same logic
> still needs to exist in all of these places.

Hi, I must admit I don't understand. I now checked both of them and they
call uart_handle_sysrq_char unconditionally, or?

-- 
js
suse labs
