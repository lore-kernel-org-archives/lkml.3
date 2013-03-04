Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3CDAFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 19:05:25 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39901 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3CDAFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 19:05:24 -0500
Message-ID: <1362355465.3221.82.camel@thor.lan>
Subject: Re: [PATCH] ircomm: release tty before sleeping potentially
 indefintely
From: Peter Hurley <peter@hurleysoftware.com>
To: David Miller <davem@davemloft.net>
Cc: sasha.levin@oracle.com, samuel@sortiz.org, gregkh@linuxfoundation.org,
        jslaby@suse.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 03 Mar 2013 19:04:25 -0500
In-Reply-To: <20130303.174739.1195645942179862011.davem@davemloft.net>
References: <1362350153-26225-1-git-send-email-sasha.levin@oracle.com>
	 <20130303.174739.1195645942179862011.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-03 at 17:47 -0500, David Miller wrote:
> From: Sasha Levin <sasha.levin@oracle.com>
> Date: Sun,  3 Mar 2013 17:35:53 -0500
> 
> > ircomm_tty_block_til_ready would hold tty lock while blocking. Since the sleep
> > might take a long time we can prevent other processes from accessing the tty,
> > causing hung tasks and a dead tty.
> > 
> > Diagnosed-by: Peter Hurley <peter@hurleysoftware.com>
> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> 
> But then you invalidate all of the tty state tests made under
> the lock at the beginning of this function, before enterring
> the loop.  If you drop the lock, those pieces of state could
> change.

Yes, the state could change. For example, the tty could be hung up while
ircomm_tty_block_til_ready() is sleeping. Or the session leader could be
exiting and SIGHUPed this task. Or the port could have been shutdown.

All these are re-tested in the loop. What state test isn't repeated?

> I'm not applying this.

That's certainly your perogative.
But you should know this bug hangs the entire tty subsystem.

This is the correct fix and exactly how this is done by the tty port.

Regards,
Peter Hurley







