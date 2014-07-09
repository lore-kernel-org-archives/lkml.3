Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbaGIW7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:59:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbaGIW7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:59:41 -0400
Date: Wed, 9 Jul 2014 15:59:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        David Rientjes <rientjes@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: use after free in /proc/pid/mountinfo
Message-Id: <20140709155939.48b126f891132370532cb999@linux-foundation.org>
In-Reply-To: <53BDBDE7.8090600@oracle.com>
References: <53B3F331.7090204@oracle.com>
	<53B4CAB8.5070407@oracle.com>
	<alpine.DEB.2.02.1407031434470.10658@chino.kir.corp.google.com>
	<53B6C051.2060704@oracle.com>
	<20140706100420.GB3589@osiris>
	<20140709142406.GA27561@osiris>
	<20140709133138.c523aa03883be5417a4d19a4@linux-foundation.org>
	<53BDBDE7.8090600@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2014 18:10:47 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> On 07/09/2014 04:31 PM, Andrew Morton wrote:
> > On Wed, 9 Jul 2014 16:24:06 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > 
> >> > 058504edd026 ("fs/seq_file: fallback to vmalloc allocation") is suspected to
> >> > cause a crash. Actually I can't reprocude the crash nor would I be able to
> >> > tell how the commit could cause the crash.
> >> > Anyway, I'll be offline for the next 2.5 weeks. So if Sasha could confirm
> >> > that reverting the patch actually does fix the crash, please revert the
> >> > commit, unless somebody else can make sense of the report of course.
> >> > 
> >> > I'm still wondering how Sasha could reproduce the crash.
> > This really sucks :(
> > 
> > I suppose I'll queue up a revert of 058504edd026 as a for-3.16 bandaid.
> > 
> > Sasha, it would be great if you could delve a bit further into this,
> > see if we can identify a way for others to reproduce the bug.
> > 
> > Did you test that little patchlet which Heiko sent?
> 
> I've been trying, but as there isn't an easy way to reproduce it, breakage
> elsewhere in -next (there is a long list) is slowing me down. I'll revert
> back to the -next where I've initially observed this issue and will retry.
> 

Thanks.  The bug should be present in current mainline.
