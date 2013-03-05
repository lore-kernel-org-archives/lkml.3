Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3CETjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:39:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53415 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3CETjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:39:42 -0500
Date: Tue, 05 Mar 2013 14:39:40 -0500 (EST)
Message-Id: <20130305.143940.1976678289652676624.davem@davemloft.net>
To: jslaby@suse.cz
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <5135D072.8070101@suse.cz>
References: <20130301.164711.326215889038834651.davem@davemloft.net>
	<20130301.170056.382924644594872197.davem@davemloft.net>
	<5135D072.8070101@suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 11:39:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Tue, 05 Mar 2013 12:01:06 +0100

> I left that "if (port->start == NULL)" in sunhv in place because it
> behaves completely differently. It checks port->start on all paths prior
> dereferencing it. And it does not stop interrupts on ->shutdown.

But this code really does care if a TTY is attached, because it wants
to make sure that SYSRQ handling occurs unconditionally, even if there
is no TTY to queue the characters to.

This is critically important during bootup before the initial shell
is spawned, if you want to do a SYSRQ register dump or reset out of
a hung boot.

Whether that test is now ->state == NULL or whatever, the same logic
still needs to exist in all of these places.
