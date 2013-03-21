Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3CUVPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:15:30 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56537 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3CUVP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:15:29 -0400
Date: Thu, 21 Mar 2013 22:15:23 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Lior Amsalem <alior@marvell.com>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jon Masters <jcm@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64
 bits
Message-ID: <20130321221523.7ede6ccc@skate>
In-Reply-To: <20130321205545.GA8358@obsidianresearch.com>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
	<1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
	<20130321201533.GN21478@lunn.ch>
	<20130321212236.1015295d@skate>
	<20130321205545.GA8358@obsidianresearch.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason Gunthorpe,

On Thu, 21 Mar 2013 14:55:45 -0600, Jason Gunthorpe wrote:

> Or, better, locate all the internal registers above 8G and use
> contiguous DRAM mapping from 0 -> 8GB

I see two potential issues with this idea:

 *) It only works when LPAE is enabled, so we would have to have
    different internal register addresses depending on whether LPAE is
    enabled or not. Probably not impossible, but not very
    straightforward either.

 *) It would require Linux to change the internal registers address
    (for now the kernel relies on the bootloader). The problem is that
    we can't do it early enough to preserve the earlyprintk
    functionality. Maybe you have suggestions on how to achieve that?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
