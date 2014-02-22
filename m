Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaBVPiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 10:38:09 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:56481 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaBVPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 10:38:07 -0500
Date: Sat, 22 Feb 2014 10:37:55 -0500
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 5/9] usb: don't use PREPARE_DELAYED_WORK
Message-ID: <20140222153755.GG12830@htj.dyndns.org>
References: <20140222145959.GF12830@htj.dyndns.org>
 <Pine.LNX.4.44L0.1402221002440.24585-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1402221002440.24585-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 10:14:48AM -0500, Alan Stern wrote:
> Is the cancel_delayed_work_sync(&hub->init_work) call in hub_quiesce()
> going to get confused by all this?

Yeah, you can't cancel a work item which hasn't been initialzed.
Maybe move init of the first work function there?  I don't think it
really matters tho.

> It's worth mentioning that the only reason for the hub_init_func3 stuff
> is, as the comment says, to avoid a long sleep (100 ms) inside a work
> routine.  With all the changes to the work queue infrastructure, maybe
> this doesn't matter so much any more.  If we got rid of it then there
> wouldn't be any multiplexing, and this whole issue would become moot.

I don't really think that'd be necessary.  Just sleeping synchronously
should be fine.  How many threads are we talking about?

Thanks.

-- 
tejun
