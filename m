Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaAZRlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 12:41:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43131 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAZRlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 12:41:36 -0500
Date: Sun, 26 Jan 2014 17:41:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: error out if the name buffer is too short
Message-ID: <20140126174134.GZ10323@ZenIV.linux.org.uk>
References: <1390572299-3074-1-git-send-email-dvlasenk@redhat.com>
 <20140124161922.GA14195@redhat.com>
 <20140126153737.GA8184@redhat.com>
 <20140126155141.GA12249@redhat.com>
 <20140126163536.GA21320@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140126163536.GA21320@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 05:35:36PM +0100, Oleg Nesterov wrote:
> On 01/26, Oleg Nesterov wrote:
> >
> > Al, Denys, unless I am totally confused the "restart" logic is very broken.
> > We can't simply restart because the main loop changes dentry?
> 
> Plus prepend_name() can't actually return -ENAMETOOLONG,
> "int error" inside the loop is wrong.

... and already fixed.  Said that, the point about restarts is definitely
true.  See vfs.git#for-linus - it should propagate in a few
