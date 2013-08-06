Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3HFSir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:38:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42411 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756515Ab3HFSiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:38:46 -0400
Date: Tue, 6 Aug 2013 14:38:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Shuah Khan <shuah.kh@samsung.com>
cc: "rjw@sisk.pl" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sl811h_suspend() and PM_EVENT_PRETHAW state handling
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6175A08F@sisaex02sj>
Message-ID: <Pine.LNX.4.44L0.1308061433000.1154-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Aug 2013, Shuah Khan wrote:

> sl811h_suspend() seems to be the odd routine in the way it handles the 
> PM_EVENT_PRETHAW state. It treats it same as PM_EVENT_SUSPEND and 
> PM_EVENT_HIBERNATE. All other uses I could find treat it same as 
> PM_EVENT_FREEZE and PM_EVENT_QUIESCE. Makes sense since PM_EVENT_PRETHAW 
> is PM_EVENT_QUIESCE.
> 
> #define PM_EVENT_PRETHAW PM_EVENT_QUIESCE
> 
> Reference: Commit 185849991d592497e43bcd264c6152af1261ffe2 introduced 
> PM_EVENT_PRETHAW state to sl811h_suspend().
> 
> Couple of questions?
> 
> - Why does sl811h_suspend() treat PM_EVENT_PRETHAW different from 
> PM_EVENT_FREEZE?

Because with FREEZE, the driver wants to retain the current bus state.  
With PRETHAW, it doesn't care about retaining the bus state.

At least, that's how it looks to me.  The original author of this 
driver died a couple of years ago.  I don't know if anyone is using it 
any more.

> There is no problem with this code as such, since state is passed in. 
> However, this usage conflicts with the rest of the usages and the way 
> pm_op() routine maps PM_EVENT_PRETHAW/PM_EVENT_QUIESCE to freeze() pm_ops.
> 
>          case PM_EVENT_FREEZE:
>          case PM_EVENT_QUIESCE:
>                  return ops->freeze;
> 
> Assuming the handling PM_EVENT_PRETHAW is correct in this routine, what 
> would be the right mapping for this legacy handling to dev_pm_ops?

It depends on the driver; there is no one answer.

Alan Stern

