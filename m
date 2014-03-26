Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaCZFyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 01:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaCZFyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 01:54:04 -0400
Date: Wed, 26 Mar 2014 01:53:50 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
Message-ID: <20140326055350.GA21267@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
	Sasha Levin <sasha.levin@oracle.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <53189BF8.1010308@oracle.com>
 <531A7CFD.9030603@oracle.com>
 <20140310104350.GB28797@quack.suse.cz>
 <531DC89A.9010601@oracle.com>
 <53304451.7030800@oracle.com>
 <20140324214851.GB10057@quack.suse.cz>
 <5330D15E.2000702@oracle.com>
 <20140325173340.GB17292@quack.suse.cz>
 <5331C20F.5010109@oracle.com>
 <20140325211229.GA27422@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325211229.GA27422@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 10:12:29PM +0100, Jan Kara wrote:

 > This fixes an oops triggered by trinity when it tried mounting
 > anon_inodefs which overwrote anon_inode_inode pointer while other CPU
 > has been in anon_inode_getfile() between ihold() and d_instantiate().
 > Thus effectively creating dentry pointing to an inode without holding a
 > reference to it.
 
<raises eyebrows>

Sasha, do you have changes to trinity's syscall/mount.c ?
It's kind of miraculous we managed to get the type arg right
there, because right now we're just passing a random address as an arg.
The only way that could work is if we randomly managed to do an allocation,
and then a seek & read from /proc/filesystems to that buffer.  If you're
lucky enough to get all those conditions right from rand() calls, you should
probably give up on kernel hacking and buy some powerball tickets.

We should add some code to make that only return strings from /proc/filesystems,
which makes me wonder if you already did that..

	Dave

