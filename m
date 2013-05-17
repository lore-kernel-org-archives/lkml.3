Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3EQItj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:49:39 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:7637 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3EQItg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:49:36 -0400
Date: Fri, 17 May 2013 10:49:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Robert Norris <robn@opera.com>
Cc: linux-kernel@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130517104928.5b135a4f@endymion.delvare>
In-Reply-To: <20130516034455.GA19452@pyro.melbourne.osa>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
	<20130514231626.GA12961@pyro.melbourne.osa>
	<20130515112044.753bb7bb@endymion.delvare>
	<20130515112741.GA23766@pyro.melbourne.osa>
	<20130515214923.036dabdb@endymion.delvare>
	<20130516034455.GA19452@pyro.melbourne.osa>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013 13:44:55 +1000, Robert Norris wrote:
> > Then do a simple read from a random address
> >   with:
> >   # i2cget 4 0x50 0x00
> >   (Adjust the bus number as needed.)
> >   I am curious if this will hang as well or only when accessing the
> >   clock chip at address 0x69.
> 
> Yep, that one hangs. The hung task handler picked it up after a few
> minutes.

Hmm, can you please dump the PCI configuration space of the SMBus
controller?

# /sbin/lspci -s 00:1f.3 -xxx

It might be that you have interrupts routed to SMI# instead of the
regular IRQ line. The driver is supposed to disable interrupt support
in that case, but I have never tested it.

Thanks,
-- 
Jean Delvare
