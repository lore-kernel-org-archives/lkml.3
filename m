Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab3CEUrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:47:14 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:45825 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3CEUrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:47:12 -0500
Message-ID: <1362516424.18799.81.camel@thor.lan>
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
From: Peter Hurley <peter@hurleysoftware.com>
To: David Miller <davem@davemloft.net>
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 15:47:04 -0500
In-Reply-To: <20130305.150338.470704111422696046.davem@davemloft.net>
References: <5135D072.8070101@suse.cz>
	 <20130305.143940.1976678289652676624.davem@davemloft.net>
	 <51364B31.1010808@suse.cz>
	 <20130305.150338.470704111422696046.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 15:03 -0500, David Miller wrote:
> From: Jiri Slaby <jslaby@suse.cz>
> Date: Tue, 05 Mar 2013 20:44:49 +0100
> 
> > Hi, I must admit I don't understand. I now checked both of them and they
> > call uart_handle_sysrq_char unconditionally, or?
> 
> Nope, in the sunsab.c receive function, we used to handle the SYSRQ
> stuff before break checking when TTY is NULL, now we don't.

Hi David,

SysRq is signalled first by a BRK condition, then followed by the input
character indicating which SysRq function to perform.

sunsab.c: receive_char() is behaving as you would expect.

First, a BRK status is indicated so uart_handle_break() records a
timestamp. If the next input is received within 5 sec. of that
timestamp, the character received is interpreted as a SysRq function --
handled by uart_handle_sysrq_char().

Are you observing that SysRq processing is not occurring with this
driver when only a console exists, or are you hypothesizing that this is
possible?

Regards,
Peter Hurley

