Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3CMIoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:44:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48364 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3CMIoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:44:19 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Excessive ethernet interrupts on AM335x board
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <513F4B58.1000204@mimc.co.uk>
Date: Wed, 13 Mar 2013 09:44:15 +0100
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <85569979-6B4C-46D0-BDC8-B70785375D64@dominion.thruhere.net>
References: <513F4B58.1000204@mimc.co.uk>
To: Mark Jackson <mpfj-list@mimc.co.uk>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 12 mrt. 2013, om 16:35 heeft Mark Jackson <mpfj-list@mimc.co.uk> het volgende geschreven:

> I'm just fighting an issue with ethernet on our custom AM335x board:-
> 
> # uname -a
> Linux nanobone 3.9.0-rc2-00113-gd60f039 #139 Tue Mar 12 15:14:01 GMT 2013 armv7l GNU/Linux
> 
> Every now and then, the whole unit slows to a crawl.  The only indication of any problem is:-
> 
> (a) the serial tty port becomes much less responsive
> (b) normal ping times jump from 1ms to >10sec (sometimes >20sec !!)
> (c) the ethernet interrupt count rockets (see below)

You probably have PG2.x silicon, have a look at this patch: https://github.com/beagleboard/kernel/blob/3.8/patches/net/0003-cpsw-Fix-interrupt-storm-among-other-things.patch

I saw some patches going into net-next today that might address this in a different way, but I haven't tried 3.9rc on an am335x yet.