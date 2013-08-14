Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab3HNKaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:30:11 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:64793 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759500Ab3HNKaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:30:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130813233449.GK23412@tassilo.jf.intel.com>
References: <1376394957-31691-1-git-send-email-eranian@google.com>
	<1376394957-31691-3-git-send-email-eranian@google.com>
	<20130813233449.GK23412@tassilo.jf.intel.com>
Date: Wed, 14 Aug 2013 12:30:08 +0200
Message-ID: <CABPqkBTJKhFPNgeWcffsYr6pnHKM7OEg-et-rc-SY1J0x_Y9gQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] perf tools: add attr->mmap2 support
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 1:34 AM, Andi Kleen <ak@linux.intel.com> wrote:
> On Tue, Aug 13, 2013 at 01:55:57PM +0200, Stephane Eranian wrote:
>> This patch adds support for the new PERF_RECORD_MMAP2
>> record type exposed by the kernel. This is an extended
>> PERF_RECORD_MMAP record. It adds for each file-backed
>> mapping the device major, minor number and the inode
>> number. This triplet uniquely identifies the source
>> of a file-backed mapping. It can be used to detect
>> identical virtual mappings between processes for instance.
>
> Can you also add the generation number please?
> That would make it even more unique.
>
I assume you're talkng about inode->i_generation, right?
I could add that one easily. I am surprised to see:

mm/shmem.c:
static struct inode *shmem_get_inode(struct super_block *sb, const
struct inode *dir,
                                     umode_t mode, dev_t dev, unsigned
long flags)
{
                inode->i_generation = get_seconds();
}
I am assuming that the uniqueness for SHM is coming from the SHMID and therefore
a poor quality i_generation is sufficient here.
