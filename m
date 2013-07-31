Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab3GaISU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:18:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759231Ab3GaISP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:18:15 -0400
Message-ID: <1375258693.17175.4.camel@linux-fkkt.site>
Subject: Re: [PATCH] sky2: detect and prevent kernel panic from a possible
 faulty hardware
From: Oliver Neukum <oneukum@suse.de>
To: David Miller <davem@davemloft.net>
Cc: sam8641@gmail.com, mlindner@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 31 Jul 2013 10:18:13 +0200
In-Reply-To: <20130730.161906.1898764862564749288.davem@davemloft.net>
References: <1374957354-10142-1-git-send-email-sam8641@gmail.com>
	 <20130730.161906.1898764862564749288.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 16:19 -0700, David Miller wrote:
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

But sky2 is used in some hotremovable cards. You can hit the window
for this race. It is unlikely but still this simple check fixes a bug.

	Regards
		Oliver


