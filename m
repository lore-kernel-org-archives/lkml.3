Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaILOX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:23:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52803 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754715AbaILOX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:23:26 -0400
Date: Fri, 12 Sep 2014 10:23:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Petr Mladek <pmladek@suse.cz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] usb: hub: remove obsolete while cycle in hub_event()
In-Reply-To: <1410524468-15232-3-git-send-email-pmladek@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1409121020500.1180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Petr Mladek wrote:

> The USB hub events are proceed by workqueue instead of kthread now.
> The result is that hub_event() function processes only one event.
> The while cycle was not removed earlier to show the real changes when
> switching to the workqueue.
> 
> This patch also consolidates the goto targets and rename them from "loop*"
> to "out*".
> 
> When touching the code, it fixes also formatting of dev_err() and dev_dbg()
> calls to make checkpatch.pl happy :-)

Although the reason given in the description above is not really
accurate, removing the loop in hub_events is a reasonable thing to do.  
That loop doesn't serve any purpose as far as I can see.

Alan Stern

