Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbaIQRd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:33:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39829 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756003AbaIQRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:33:25 -0400
Date: Wed, 17 Sep 2014 13:33:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Petr Mladek <pmladek@suse.cz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] usb: hub: remove obsolete while cycle in hub_event()
In-Reply-To: <1410967150-25240-3-git-send-email-pmladek@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1409171331280.1579-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Petr Mladek wrote:

> The USB hub events are proceed by workqueue instead of kthread now.
> The result is that hub_event() function processes only one event.
> The block from the while cycle was not removed earlier to show the real
>  changes when switching to the workqueue.
> 
> When touching the code, it fixes also formatting of dev_err() and dev_dbg()
> calls to make checkpatch.pl happy :-)

More sylistic comments...

> +	hub = container_of(work, struct usb_hub, events);
> +	hdev = hub->hdev;
> +	hub_dev = hub->intfdev;
> +	intf = to_usb_interface(hub_dev);
> +
> +	dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
> +		hdev->state, hdev->maxchild,
> +		/* NOTE: expects max 15 ports... */
> +		(u16) hub->change_bits[0],
> +		(u16) hub->event_bits[0]);

In this file, continuation lines are indented by 2 tab stops beyond the 
starting line, not one.

> +		if (test_bit(i, hub->event_bits)
> +		    || test_bit(i, hub->change_bits)
> +		    || test_bit(i, hub->wakeup_bits)) {

And not four spaces.

Alan Stern

