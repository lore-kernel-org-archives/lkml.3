Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaKJP2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:28:08 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:62538 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKJP2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:28:05 -0500
From: Paul Moore <paul@paul-moore.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Security: Provide copy-up security hooks for unioned files
Date: Mon, 10 Nov 2014 10:28:02 -0500
Message-ID: <1598563.E145j9ZHLH@sifl>
User-Agent: KMail/4.14.2 (Linux/3.16.7-gentoo; KDE/4.14.2; x86_64; ; )
In-Reply-To: <3206.1415398234@warthog.procyon.org.uk>
References: <2455443.WUExuKDC0I@sifl> <20141105154228.2555.55814.stgit@warthog.procyon.org.uk> <3206.1415398234@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 07, 2014 10:10:34 PM David Howells wrote:
> Paul Moore <paul@paul-moore.com> wrote:
> > This didn't occur to me earlier, but we may want to pick a different
> > phrase to use instead of "copy_up" as that has a special meaning for some
> > security/MLS folks...
> 
> It does?

Yep, think upgrading the sensitivity level, e.g. relabeling a "secret" file up 
to a "top secret".

> security_inode_make_union()?

Actually, after thinking on this some more, forget I mentioned anything.  The 
existing "copy_up" makes the most sense for the LSM hook (it matches the 
naming of the caller in overlayfs, which is a nice thing) and the number of 
times any MLS will look that closely at the kernel code is going to be very 
few.

-- 
paul moore
www.paul-moore.com

