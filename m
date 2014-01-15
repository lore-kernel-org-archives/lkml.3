Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaAOVLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:11:15 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:44543 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaAOVLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:11:12 -0500
Date: Wed, 15 Jan 2014 15:10:57 -0600
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GregKH <greg@kroah.com>
Subject: Re: [PATCH 16/16] hold bus_mutex in netlink and search
Message-ID: <20140115211057.GH27675@spacedout.fries.net>
References: <1388299556-12669-1-git-send-email-David@Fries.net>
 <20140115045200.GA29560@spacedout.fries.net>
 <8351389819482@web5j.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8351389819482@web5j.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 15:10:59 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's 1 through 14, and 16.  Patch 15 was in my tree from another developer,
"drivers/w1/masters/w1-gpio.c: add strong pullup emulation"
and wasn't included in what I submitted.  Should I repost the series
in sequence?

On Thu, Jan 16, 2014 at 12:58:02AM +0400, Evgeniy Polyakov wrote:
> Hi
> 
> 15.01.2014, 08:52, "David Fries" <David@Fries.net>:
> > The bus_mutex needs to be taken to serialize access to a specific bus.
> > netlink wasn't updated when bus_mutex was added and was calling
> > without that lock held, and not all of the masters were holding the
> > bus_mutex in a search.  This was causing the ds2490 hardware to stop
> > responding when both netlink and /sys slaves were executing bus
> > commands at the same time.
> >
> > Signed-off-by: David Fries <David@Fries.net>
> 
> Looks good to me, thank you.
> Greg, please pull the whole set if you hadn't yet
> 
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net> 

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
