Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbaFUJLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 05:11:06 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:51478 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaFUJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 05:11:03 -0400
Date: Sat, 21 Jun 2014 11:10:58 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] /proc/stat vs. failed order-4 allocation
Message-ID: <20140621091058.GC3463@osiris>
References: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com>
 <20140618142931.857d57fe0007a361404f6cab@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618142931.857d57fe0007a361404f6cab@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062109-0342-0000-0000-0000003084D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 02:29:31PM -0700, Andrew Morton wrote:
> On Mon, 16 Jun 2014 11:04:50 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > These two patches are supposed to "fix" failed order-4 memory
> > allocations which have been observed when reading /proc/stat.
> > The problem has been observed on s390 as well as on x86.
> > 
> > To address the problem change the seq_file memory allocations to
> > fallback to use vmalloc, so that allocations also work if memory
> > is fragmented.
> > 
> > This approach seems to be simpler and less intrusive than changing
> > /proc/stat to use an interator. Also it "fixes" other users as well,
> > which use seq_file's single_open() interface.
> 
> Yes, those changes look pretty simple and effective.
> 
> I'm unclear on how urgent these fixes are.  I semi-randomly tagged them
> for 3.16 with a -stable backport, but that could be changed?

I assume tagged for 3.16 means you intend to get it merged before 3.16
gets released?
If so, then that would be fine with me.

