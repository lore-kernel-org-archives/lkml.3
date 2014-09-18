Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbaIRQcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:32:01 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40278 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298AbaIRQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:31:59 -0400
Date: Thu, 18 Sep 2014 12:31:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] usb: hub: rename khubd to hub_wq in documentation
 and comments
Message-ID: <20140918163147.GA13573@mtj.dyndns.org>
References: <20140917212238.GB15795@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1409181013550.1326-100000@iolanthe.rowland.org>
 <20140918161501.GG2168@dhcp128.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140918161501.GG2168@dhcp128.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 06:15:02PM +0200, Petr Mládek wrote:
> The easiest solution would be to allocate the work queue with
> the flag WQ_UNBOUND and max_active = 1. It will force serialization
> of all work items.

Please use alloc_ordered_workqueue() for that purpose.  WQ_UNBOUND +
max_active == 1 no longer guarantees single thread of execution.

Thanks.

-- 
tejun
