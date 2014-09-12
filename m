Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaILQ2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:28:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57725 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaILQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:28:36 -0400
Date: Fri, 12 Sep 2014 17:28:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Seunghun Lee <waydi1@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: remove redundant sanity check in do_mount
Message-ID: <20140912162834.GE7996@ZenIV.linux.org.uk>
References: <1410537212-3153-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410537212-3153-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 12:53:32AM +0900, Seunghun Lee wrote:
> In sys_mount, getname() checks dir_name.
> So do_mount needn't check dir_name again.

... and simple grep shows four more call sites.  At the very least, the
commit message needs to cover those as well, *if* the check is, indeed,
redundant.  From the look through those guys it looks like it is, but...
I wonder if it would make more sense to pass char __user * instead of
char * here.  And do getname() inside do_mount().  As it is, we do
getname() in all callers *and* never look into the result of said getname()
until passing it to do_mount().  So how about just passing userland pointer
all the way down to do_mount() (grep for callers and watch out for ones
in arch/alpha/kernel/osf_sys.c) and doing getname() in do_mount() itself?
