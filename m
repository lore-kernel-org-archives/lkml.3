Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaFWXER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 19:04:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaFWXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 19:04:16 -0400
Date: Mon, 23 Jun 2014 16:04:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Rientjes <rientjes@google.com>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] /proc/stat vs. failed order-4 allocation
Message-Id: <20140623160414.f64bcfbfc3f40b4844552427@linux-foundation.org>
In-Reply-To: <20140621091058.GC3463@osiris>
References: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
	<20140618142931.857d57fe0007a361404f6cab@linux-foundation.org>
	<20140621091058.GC3463@osiris>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2014 11:10:58 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Wed, Jun 18, 2014 at 02:29:31PM -0700, Andrew Morton wrote:
> > On Mon, 16 Jun 2014 11:04:50 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > 
> > > These two patches are supposed to "fix" failed order-4 memory
> > > allocations which have been observed when reading /proc/stat.
> > > The problem has been observed on s390 as well as on x86.
> > > 
> > > To address the problem change the seq_file memory allocations to
> > > fallback to use vmalloc, so that allocations also work if memory
> > > is fragmented.
> > > 
> > > This approach seems to be simpler and less intrusive than changing
> > > /proc/stat to use an interator. Also it "fixes" other users as well,
> > > which use seq_file's single_open() interface.
> > 
> > Yes, those changes look pretty simple and effective.
> > 
> > I'm unclear on how urgent these fixes are.  I semi-randomly tagged them
> > for 3.16 with a -stable backport, but that could be changed?
> 
> I assume tagged for 3.16 means you intend to get it merged before 3.16
> gets released?
> If so, then that would be fine with me.

um, actually, no, sorry, I meant merge for 3.17-rc1 with a -stable backport.

We can do 3.16 of course, but for what reasons?
