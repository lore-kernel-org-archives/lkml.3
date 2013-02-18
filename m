Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3BRVsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 16:48:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:57834 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756393Ab3BRVsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 16:48:08 -0500
Date: Mon, 18 Feb 2013 16:48:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Doug Thompson <dougthompson@xmission.com>,
        <linux-edac@vger.kernel.org>, <rjw@sisk.pl>,
        <linux-pm@vger.kernel.org>
Subject: Re: SYSFS "errors"
In-Reply-To: <20130218184633.GC10755@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1302181644260.6790-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2013, Felipe Balbi wrote:

> Hi, On Mon, Feb 18, 2013 at 09:49:16AM -0800, Greg KH wrote:
> > > Input/output error - /sys/devices/cpu/power/autosuspend_delay_ms
> > 
> > The issue with this file is, if the power.use_autosuspend flag is not
> > set for the device, then it can't be read or written to.  This flag
> > changes dynamically with the system state
> > (__pm_runtime_use_autosuspend() can change it), so we can't just not
> > show the file if the flag is not set properly, sorry.
> > 
> > So the "error" is correct here, as is the 0644 file value.
> 
> hmm... we could create the file at pm_runtime_enable() time and remove
> it on pm_runtime_disable() time, no ? Addin Rafael to Cc

In theory this could be done, although the times would be when runtime 
autosuspend is turned on or off, not when pm_runtime_enable is called.

Alan Stern

