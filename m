Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab3G3XcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:32:23 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53068 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab3G3XcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:32:22 -0400
Date: Tue, 30 Jul 2013 16:32:17 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: David Miller <davem@davemloft.net>
Cc: sam8641@gmail.com, mlindner@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: detect and prevent kernel panic from a possible
 faulty hardware
Message-ID: <20130730163217.130cbe08@nehalam.linuxnetplumber.net>
In-Reply-To: <20130730.161906.1898764862564749288.davem@davemloft.net>
References: <1374957354-10142-1-git-send-email-sam8641@gmail.com>
	<20130730.161906.1898764862564749288.davem@davemloft.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013 16:19:06 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Samuel Williams <sam8641@gmail.com>
> Date: Sat, 27 Jul 2013 15:35:54 -0500
> 
> > A possible faulty hardware might interrupt with a status of 0xffffffff which
> > may kernel panic if sky2 driver tries to handle it. Detecting this problem
> > may avoid kernel panic.
> > 
> > Signed-off-by: Samuel Williams <sam8641@gmail.com>
> 
> Sure, but then the device is basically just going to stop.
> 
> I think this change needs to be more comprehensive, for example it
> needs to fully reset the device and try to get it operational again.

Not only that it is going to assert IRQ until the device is hard
reset. Plus it is not clear that cleaning up after sick hardware
is possible at all.
