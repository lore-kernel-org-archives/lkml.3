Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaBUPHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:07:41 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55726 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaBUPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:07:39 -0500
Date: Fri, 21 Feb 2014 10:07:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/9] usb: don't use PREPARE_DELAYED_WORK
Message-ID: <20140221150735.GA460@htj.dyndns.org>
References: <20140220205921.GA22830@kroah.com>
 <Pine.LNX.4.44L0.1402211001570.1273-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1402211001570.1273-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 10:06:05AM -0500, Alan Stern wrote:
> > I think it should be fine to use INIT_DELAYED_WORK(), but Alan would
> > know best.  Alan?
> 
> That's right; INIT_DELAYED_WORK() should be fine.  Provided there's no 
> problem doing it from within the previous work routine.

Yeah, that's completely fine.  Once a work item starts execution,
workqueue doesn't care about it at all - even freeing and recycling it
is fine.

Thanks.

-- 
tejun
