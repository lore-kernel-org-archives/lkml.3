Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab3HNQoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:44:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:51686 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709Ab3HNQow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:44:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,878,1367996400"; 
   d="scan'208";a="281985068"
Date: Wed, 14 Aug 2013 09:43:59 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v1 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130814164359.GM23412@tassilo.jf.intel.com>
References: <1376394957-31691-1-git-send-email-eranian@google.com>
 <1376394957-31691-3-git-send-email-eranian@google.com>
 <20130813233449.GK23412@tassilo.jf.intel.com>
 <CABPqkBTJKhFPNgeWcffsYr6pnHKM7OEg-et-rc-SY1J0x_Y9gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTJKhFPNgeWcffsYr6pnHKM7OEg-et-rc-SY1J0x_Y9gQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 12:30:08PM +0200, Stephane Eranian wrote:
> On Wed, Aug 14, 2013 at 1:34 AM, Andi Kleen <ak@linux.intel.com> wrote:
> > On Tue, Aug 13, 2013 at 01:55:57PM +0200, Stephane Eranian wrote:
> >> This patch adds support for the new PERF_RECORD_MMAP2
> >> record type exposed by the kernel. This is an extended
> >> PERF_RECORD_MMAP record. It adds for each file-backed
> >> mapping the device major, minor number and the inode
> >> number. This triplet uniquely identifies the source
> >> of a file-backed mapping. It can be used to detect
> >> identical virtual mappings between processes for instance.
> >
> > Can you also add the generation number please?
> > That would make it even more unique.
> >
> I assume you're talkng about inode->i_generation, right?

Yes.

> I could add that one easily. I am surprised to see:
> 
> mm/shmem.c:
> static struct inode *shmem_get_inode(struct super_block *sb, const
> struct inode *dir,
>                                      umode_t mode, dev_t dev, unsigned
> long flags)
> {
>                 inode->i_generation = get_seconds();
> }
> I am assuming that the uniqueness for SHM is coming from the SHMID and therefore
> a poor quality i_generation is sufficient here.

Yes that's odd. But most file system should have a sensible generation
number.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
