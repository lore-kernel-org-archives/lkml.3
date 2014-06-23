Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaFWGeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:34:06 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:34390 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbaFWGeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:34:05 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Tyler Hall <tylerwhall@gmail.com>, Andre Naujoks <nautsch2@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slip: Fix deadlock in write_wakeup
Date: Mon, 23 Jun 2014 08:31:59 +0200
Message-ID: <3115845.XamgKCD80B@ws-stein>
User-Agent: KMail/4.12.5 (Linux/3.12.20-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <539F2F78.40502@hartkopp.net>
References: <1402885397-21062-1-git-send-email-tylerwhall@gmail.com> <539F2F78.40502@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 June 2014 19:55:04, Oliver Hartkopp wrote:
> Hello Tyler,
> 
> On 16.06.2014 04:23, Tyler Hall wrote:
> > Use schedule_work() to avoid potentially taking the spinlock in
> > interrupt context.
> > 
> (..)
> 
> > 
> > To deal with these issues, don't grab the lock in the wakeup function by
> > deferring the writeout to a workqueue. Also hold the lock during close
> > when de-assigning the tty pointer to safely disarm the worker and
> > timers.
> > 
> > This bug is easily reproducible on the first transmit when slip is
> > used with the standard 8250 serial driver.
> > 
> 
> looks reasonable. Thanks for your patch!
> Indeed I can't remember ever using the slcan driver with a real serial
> controller hardware with irq line but only via serial-to-USB adapters :-)
> Due to the recent fixes from Andre and Alexander these two drivers got in
> motion again ...
> 
> @Andre/Alexander: Can you please check if slcan still works in your setup. I
> don't have that hardware with me. I only was able to compile it successfully.

Sorry, I don't have access to the serial hardware currently.

Best regards
Alexander

