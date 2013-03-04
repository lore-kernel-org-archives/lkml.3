Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3CDCgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:36:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59456 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab3CDCgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:36:06 -0500
Date: Sun, 03 Mar 2013 21:36:01 -0500 (EST)
Message-Id: <20130303.213601.1201168888595187293.davem@davemloft.net>
To: peter@hurleysoftware.com
Cc: sasha.levin@oracle.com, samuel@sortiz.org, gregkh@linuxfoundation.org,
        jslaby@suse.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ircomm: release tty before sleeping potentially
 indefintely
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362359178.3221.118.camel@thor.lan>
References: <1362355465.3221.82.camel@thor.lan>
	<20130303.193313.408641189137321065.davem@davemloft.net>
	<1362359178.3221.118.camel@thor.lan>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 03 Mar 2013 18:36:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>
Date: Sun, 03 Mar 2013 20:06:18 -0500

> But regardless, this function __cannot__ sleep holding the tty_lock().

So drop it across the schedule(), but recheck the termios after
regrabbing it.
