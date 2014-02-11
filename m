Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaBKRKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:10:54 -0500
Received: from top.free-electrons.com ([176.31.233.9]:38226 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752025AbaBKRKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:10:51 -0500
Date: Tue, 11 Feb 2014 18:10:48 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Josh Cartwright <joshc@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 4/8] ARM: mvebu: make use of
 of_find_matching_node_and_match
Message-ID: <20140211181048.6934bdd3@skate>
In-Reply-To: <20140211165314.GA8533@titan.lakedaemon.net>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
	<1392135847-30791-5-git-send-email-joshc@codeaurora.org>
	<20140211165314.GA8533@titan.lakedaemon.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason Cooper,

On Tue, 11 Feb 2014 11:53:14 -0500, Jason Cooper wrote:

> > -	np = of_find_matching_node(NULL, of_system_controller_table);
> > +	np = of_find_matching_node_and_match(NULL, of_system_controller_table,
> > +					     &match);
> >  	if (np) {
> > -		const struct of_device_id *match =
> > -		    of_match_node(of_system_controller_table, np);
> 
> 
> > -		BUG_ON(!match);
> 
> Gregory, is it ok to remove this?  It was added with the original code
> submission for mach-mvebu.  mvebu_restart() will handle this
> gracefully...

The BUG_ON here can normally never be reached. If
of_find_matching_node() returns a non-NULL result, then of_match_node()
should also return a non-NULL result.

Or I'm missing something :)

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
