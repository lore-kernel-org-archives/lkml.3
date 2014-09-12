Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaILSI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:08:26 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38065 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaILSIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:08:23 -0400
Date: Sat, 13 Sep 2014 03:08:18 +0900
From: Tejun Heo <tj@kernel.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] usb: hub: convert khubd into workqueue
Message-ID: <20140912180818.GC6298@mtj.dyndns.org>
References: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
 <1410524468-15232-2-git-send-email-pmladek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410524468-15232-2-git-send-email-pmladek@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 02:21:05PM +0200, Petr Mladek wrote:
> There is no need to have separate kthread for handling USB hub events.
> It is more elegant to use the workqueue framework.
> 
> The workqueue is allocated as unbound, cpu intensive, and freezable.

I'd just go with WQ_FREEZABLE.  As a general rule of thumb, please
only use attributes which are strictly necessary.  If the default
behavior turns out to be not so good for typical wq usages (and AFAICS
khubd seems fairly typical), we should be changing the default
behavior.  Each usage deviating complicates the long-term prospect.

Thanks.

-- 
tejun
