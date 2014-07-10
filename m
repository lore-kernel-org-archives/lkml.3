Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaGJXMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:12:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaGJXMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:12:06 -0400
Date: Thu, 10 Jul 2014 16:12:05 -0700 (PDT)
Message-Id: <20140710.161205.2079073830695357277.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, sethb@digi.com, aaro.koskinen@iki.fi,
        sam@ravnborg.org, tsbogend@alpha.franken.de
Subject: Re: [PATCH 0/2] fixes for empty tx buffer breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140710231432.GA9423@kroah.com>
References: <20140609205917.GA913@drone.musicnaut.iki.fi>
	<1404660593-12172-1-git-send-email-peter@hurleysoftware.com>
	<20140710231432.GA9423@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 10 Jul 2014 16:12:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 10 Jul 2014 16:14:32 -0700

> On Sun, Jul 06, 2014 at 11:29:51AM -0400, Peter Hurley wrote:
>> Cc: Seth Bollinger <sethb@digi.com>
>> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>> 
>> Greg,
>> 
>> I completed the audit of serial drivers after reports that
>> several Sun serial drivers were broken by
>> commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c,
>> 'serial_core: Fix conditional start_tx on ring buffer not empty'.
>> 
>> I apologize for not submitting this sooner. The delay was due to
>> an ongoing analysis of serial flow control prompted by Sam Ravnborg's
>> question:
>> 
>> On 06/10/2014 03:24 PM, Sam Ravnborg wrote:
>> > I also noticed the typical pattern is:
>> > 
>> >      if (uart_circ_empty(xmit) || uart_tx_stopped(port))
>> > 
>> > Should you use this pattern also in sunsab.c?
>> 
>> Unfortunately, that analysis revealed that tx flow control is
>> largely SMP-unsafe, and it's fairly easy to corrupt the hardware
>> state wrt. the tty flow control state.
>> 
>> I'm still working on the solutions to that; they're too
>> extensive to submit for 3.16 anyway.
> 
> So these should go into 3.16-final?  Or 3.17?

Definitely 3.16, this regression is several releases old.
