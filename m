Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaCZRXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:23:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50620 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbaCZRXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:23:46 -0400
Date: Wed, 26 Mar 2014 17:23:32 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
In-Reply-To: <1395770101-24534-9-git-send-email-jack@suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-9-git-send-email-jack@suse.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014 18:55:01 +0100
Jan Kara <jack@suse.cz> wrote:

> Necessity for offloading of printing was observed only for large
> systems. So add a config option (disabled by default) which removes most
> of the overhead added by this functionality.

If its an option it'll not get used. It ought to be automatic.

I still think the mindset of this patch set is wrong. Only the device
driver really knows what is good or bad. A large x86 connected to a
network fake 16x50 serial port for example typically has a giant FIFO so
'bad' becomes 32K not 1000. A USB serial port already does async queueing
so the value is 0.

It also ignores priority so you might queue and loose an oops as a box
goes down in preference to reporting debugging crap.

All the afflicted consoles are serial, all go via the uart layer as far
as I can see.

The uart layer has a queue mechanism that could be used

Alan
