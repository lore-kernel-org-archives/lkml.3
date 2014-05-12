Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaELPmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:42:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33330 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaELPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:42:35 -0400
Date: Mon, 12 May 2014 16:42:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc5 soft-lockup in dentry_kill
Message-ID: <20140512154230.GD18016@ZenIV.linux.org.uk>
References: <CA+5PVA480wkD1xhWbhPVGoHeG=T3F3zeEwAPbEatUmmX_L5h-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA480wkD1xhWbhPVGoHeG=T3F3zeEwAPbEatUmmX_L5h-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 09:21:53AM -0400, Josh Boyer wrote:
> Hi All,
> 
> We got a report[1] of udevd hanging up in a soft lockup with 3.15-rc5
> over the weekend.  The backtrace is below.  I know there were a number
> of recent changes here, so hopefully this triggers someone's memory.

Reproducer would be nice...  Incidentally, kernfs ->d_revalidate() looks
like a massive source of contention - it grabs a system-wide mutex all
the time, and I'd like to see profiles on the loads that go anywhere near
that sucker.
