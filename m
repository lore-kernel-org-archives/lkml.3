Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbaKASiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 14:38:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58362 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaKASiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 14:38:04 -0400
Date: Sat, 1 Nov 2014 18:38:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W.Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dealing with proc_ns_follow_link() and "namespace" dentries
Message-ID: <20141101183802.GR7996@ZenIV.linux.org.uk>
References: <20141013062945.GX7996@ZenIV.linux.org.uk>
 <87r3ybwq0b.fsf@x220.int.ebiederm.org>
 <20141101083804.GO7996@ZenIV.linux.org.uk>
 <20141101150620.GP7996@ZenIV.linux.org.uk>
 <cfb295aa-0e4b-4185-875f-3745d2c5c01a@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfb295aa-0e4b-4185-875f-3745d2c5c01a@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 11:23:34AM -0700, Eric W.Biederman wrote:

> >From your description I am concerned about using the letter combination nsfs.   I once used nsfd, and that was so close to nfsd that Linus got confused, and hilarity ensued.   nsfs isn't quite as bad but the abbreviation still seems close enough to nfs that confusion could result.

Well, yes, but... the only non-static object in there with "nsfs" in the
name is nsfs_init().  As for the filename itself... any better suggestions
would be welcome, but it doesn't really mess the completion tree.

I've no strong preferences here - we might even move it into kernel/nsproxy.c.
In the latest variant it's ~160 lines...
