Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbaBUPGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:06:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42514 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932223AbaBUPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:06:07 -0500
Date: Fri, 21 Feb 2014 10:06:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Tejun Heo <tj@kernel.org>, <laijs@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 5/9] usb: don't use PREPARE_DELAYED_WORK
In-Reply-To: <20140220205921.GA22830@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1402211001570.1273-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Greg Kroah-Hartman wrote:

> On Thu, Feb 20, 2014 at 03:44:27PM -0500, Tejun Heo wrote:
> > PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> > and a nasty surprise in terms of reentrancy guarantee as workqueue
> > considers work items to be different if they don't have the same work
> > function.
> > 
> > usb_hub->init_work is multiplexed with multiple work functions.
> > Introduce hub_init_workfn() which invokes usb_hub->init_workfn and
> > always use it as the work function and update the users to set the
> > ->init_workfn field instead of overriding the work function using
> > PREPARE_DELAYED_WORK().
> > 
> > It looks like that the work items are never queued while in-flight, so

They aren't.  But one work item does get queued by the previous one's 
work function.

> > simply using INIT_DELAYED_WORK() before each queueing could be enough.
> > This patch performs equivalent conversion just in case but we probably
> > wanna clean it up later if that's the case.
> 
> I think it should be fine to use INIT_DELAYED_WORK(), but Alan would
> know best.  Alan?

That's right; INIT_DELAYED_WORK() should be fine.  Provided there's no 
problem doing it from within the previous work routine.

Alan Stern

