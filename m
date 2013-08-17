Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3HQPiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 11:38:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50646 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753516Ab3HQPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 11:38:09 -0400
Date: Sat, 17 Aug 2013 17:38:02 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 5/5] ARM: mvebu: add board init for Armada 1500
Message-ID: <20130817173802.71da1d14@skate>
In-Reply-To: <1376682098-10580-6-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1376682098-10580-6-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Fri, 16 Aug 2013 21:41:38 +0200, Sebastian Hesselbarth wrote:

> I am not so sure about the .map_io but I didn't yet fully understand
> the mapping requirement. Anyway, it is required for iomap and friends
> to work and basically remaps physical register addressed onto the same
> virtual addresses.

You should normally be able to completely avoid the ->map_io() hook. If
you leave it set to NULL, it will automatically call
debug_ll_io_init(), which will setup the virt->phys mapping needed by
DEBUG_LL stuff. All the other mappings will be created dynamically with
ioremap().

The static mapping covering all registers is really no longer needed.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
