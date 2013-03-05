Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab3CEUDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:03:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53774 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3CEUDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:03:40 -0500
Date: Tue, 05 Mar 2013 15:03:38 -0500 (EST)
Message-Id: <20130305.150338.470704111422696046.davem@davemloft.net>
To: jslaby@suse.cz
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <51364B31.1010808@suse.cz>
References: <5135D072.8070101@suse.cz>
	<20130305.143940.1976678289652676624.davem@davemloft.net>
	<51364B31.1010808@suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 12:03:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Tue, 05 Mar 2013 20:44:49 +0100

> Hi, I must admit I don't understand. I now checked both of them and they
> call uart_handle_sysrq_char unconditionally, or?

Nope, in the sunsab.c receive function, we used to handle the SYSRQ
stuff before break checking when TTY is NULL, now we don't.
