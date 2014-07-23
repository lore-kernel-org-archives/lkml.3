Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbaGWU5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:57:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbaGWU5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:57:16 -0400
Date: Wed, 23 Jul 2014 13:57:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: use after free in /proc/pid/mountinfo
Message-Id: <20140723135714.54b97f8184ae69ba9fb32228@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1407151558450.32274@chino.kir.corp.google.com>
References: <53B3F331.7090204@oracle.com>
	<53B4CAB8.5070407@oracle.com>
	<alpine.DEB.2.02.1407031434470.10658@chino.kir.corp.google.com>
	<53B6C051.2060704@oracle.com>
	<20140706100420.GB3589@osiris>
	<20140709142406.GA27561@osiris>
	<20140709133138.c523aa03883be5417a4d19a4@linux-foundation.org>
	<53BDBDE7.8090600@oracle.com>
	<20140709155939.48b126f891132370532cb999@linux-foundation.org>
	<53C53223.5040502@oracle.com>
	<alpine.DEB.2.02.1407151558450.32274@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 16:01:34 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Tue, 15 Jul 2014, Sasha Levin wrote:
> 
> > I've been running mainline for a while, and while I can reproduce a different
> > bug for Hugh, I can't reproduce this one at all. Not sure how to call it now,
> > maybe memory corruption from somewhere else (I did find an unrelated memory
> > corruption couple days ago)?
> > 
> 
> I have a very large /proc/pid/mountinfo on one of my busy systems with VM 
> and slub debugging enabled and have not been able to reproduce the issue 
> while reading it in a loop for 24 hours.  I would call the patch good on 
> that basis, but it's very strange you'd report this problem a day after 
> the patch was merged and could not reproduce it once it was reverted.  
> (Unless the patch was misapplied locally and reapplying it now worked, but 
> I doubt you originally merged -mm patches into a local tree yourself.)

I was going to revert "fs/seq_file: fallback to vmalloc allocation" but
the idea of doing that is so lame and pathetic that I think I'll not do
that.  If we have a bug then let's just find and fix it when someone is
able to trigger it.


