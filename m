Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab3LFJ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:29:05 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:45353 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab3LFJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:28:56 -0500
Message-ID: <1386322131.7152.36.camel@host5.omatika.ru>
Subject: Re: [PATCH] serial: rewrite pxa2xx-uart to use 8250_core
From: Sergei Ianovich <ynvich@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Zhou Zhu <zzhu3@marvell.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Date: Fri, 06 Dec 2013 13:28:51 +0400
In-Reply-To: <20131206001728.GJ4360@n2100.arm.linux.org.uk>
References: <20131205043544.GA28580@kroah.com>
	 <1386286149-2855-1-git-send-email-ynvich@gmail.com>
	 <20131206000253.GC21358@kroah.com>
	 <20131206001728.GJ4360@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 00:17 +0000, Russell King - ARM Linux wrote:

> I may be able to - one of the downsides though is that many of these
> systems had hard-coded scripts which started a getty on the original
> port - and that kind of makes it difficult to sort out.  This kind of
> change becomes very much one of Linus' "flag days".

> So I'd suggest that we have a period where the old driver is still
> available, so at least people can choose to use the old major/minor
> numbers for a while.

The patch doesn't change how the driver looks from the outside. The old
driver was using 8250 name (ttyS), major (4) and first minor (64). So we
only resolve an internal conflict.

Kernel configuration is the place where issues may appear, since the
patch removes CONFIG_SERIAL_PXA_CONSOLE option. I've updated all
in-kernel users. However, out-of-kernel configs will no longer provide
serial console, unless manually reconfigured. Is this the case we should
worry about?

