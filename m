Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaFXXw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:52:26 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58333 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFXXwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:52:25 -0400
Date: Tue, 24 Jun 2014 16:52:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] /proc/stat vs. failed order-4 allocation
In-Reply-To: <20140623160414.f64bcfbfc3f40b4844552427@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1406241650340.22030@chino.kir.corp.google.com>
References: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com> <20140618142931.857d57fe0007a361404f6cab@linux-foundation.org> <20140621091058.GC3463@osiris> <20140623160414.f64bcfbfc3f40b4844552427@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014, Andrew Morton wrote:

> On Sat, 21 Jun 2014 11:10:58 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > On Wed, Jun 18, 2014 at 02:29:31PM -0700, Andrew Morton wrote:
> > > On Mon, 16 Jun 2014 11:04:50 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > 
> > > > These two patches are supposed to "fix" failed order-4 memory
> > > > allocations which have been observed when reading /proc/stat.
> > > > The problem has been observed on s390 as well as on x86.
> > > > 
> > > > To address the problem change the seq_file memory allocations to
> > > > fallback to use vmalloc, so that allocations also work if memory
> > > > is fragmented.
> > > > 
> > > > This approach seems to be simpler and less intrusive than changing
> > > > /proc/stat to use an interator. Also it "fixes" other users as well,
> > > > which use seq_file's single_open() interface.
> > > 
> > > Yes, those changes look pretty simple and effective.
> > > 
> > > I'm unclear on how urgent these fixes are.  I semi-randomly tagged them
> > > for 3.16 with a -stable backport, but that could be changed?
> > 
> > I assume tagged for 3.16 means you intend to get it merged before 3.16
> > gets released?
> > If so, then that would be fine with me.
> 
> um, actually, no, sorry, I meant merge for 3.17-rc1 with a -stable backport.
> 
> We can do 3.16 of course, but for what reasons?
> 

Heiko's patches should also fix 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1319244 as reported 
by Stefan Bader.  I've pinged them to determine if there is any other 
issues with -mm.
