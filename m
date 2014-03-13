Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaCMX0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:26:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35716 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaCMX0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:26:49 -0400
Date: Thu, 13 Mar 2014 23:26:36 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/6] printk: Hand over printing to console if printing
 too long
Message-ID: <20140313232636.02766d06@alan.etchedpixels.co.uk>
In-Reply-To: <20140313160625.1c62ca6bba080286194aa868@linux-foundation.org>
References: <1394726318-2757-1-git-send-email-jack@suse.cz>
	<1394726318-2757-6-git-send-email-jack@suse.cz>
	<20140313160625.1c62ca6bba080286194aa868@linux-foundation.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Creating yet more kernel threads to solve this problem is a bit sad. 
> Is there no way in which we can borrow one of the existing threads?

schedule_work()

Surely that's all we need, if we get bunged up for a bit then it ends up
on a work queue item and everyone with a billion disks and a 9600 baud
serial port is still happy. Nobody else will ever see it.

Alan
