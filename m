Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3CQSoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:44:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab3CQSox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:44:53 -0400
Date: Sun, 17 Mar 2013 19:42:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Use file_inode()
Message-ID: <20130317184255.GA23280@redhat.com>
References: <20130317180036.GA16843@redhat.com> <20130317182550.GD21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317182550.GD21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Al Viro wrote:
>
> On Sun, Mar 17, 2013 at 07:00:36PM +0100, Oleg Nesterov wrote:
> > Cleanup. Now that we have f_inode/file_inode() we can use it
> > instead of ->f_mapping->host.
>
> No.  This is *not* guaranteed to be the same thing in general; note that
> e.g. for block devices ->f_mapping->host is *not* equal to file_inode().

Yes,

> It probably is valid in this particular case,

And yes (I think). In fact I think ->f_mode is "more correct" in this case.
Say, if this uprobe was created by create_trace_uprobe() we use d_inode,
and uprobe_mmap/etc uses file_inode() only to compare this pointer with
uprobe->inode.

But I'll try to recheck, and:

> but at the very least you
> need to explain that in commit message,

OK. Will do, thanks.

Oleg.

