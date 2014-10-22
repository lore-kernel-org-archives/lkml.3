Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbaJVMON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:14:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbaJVMOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:14:11 -0400
Date: Wed, 22 Oct 2014 14:14:03 +0200
From: Petr Holasek <pholasek@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC][PATCH] add pagesize field to /proc/pid/numa_maps
Message-ID: <20141022121403.GI2804@localhost.localdomain>
References: <1413847634-20039-1-git-send-email-pholasek@redhat.com>
 <alpine.DEB.2.02.1410201803540.2345@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410201803540.2345@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, David Rientjes <rientjes@google.com> wrote:
> On Tue, 21 Oct 2014, Petr Holasek wrote:
> 
> > There were some similar attempts to add vma's pagesize to numa_maps in the past,
> > so I've distilled the most straightforward one - adding pagesize field
> > expressing size in kbytes to each line. Although page size can be also obtained
> > from smaps file, adding pagesize to numa_maps makes the interface more compact
> > and easier to use without need for traversing other files.
> > 
> > New numa_maps output looks like that:
> > 
> > 2aaaaac00000 default file=/dev/hugepages/hugepagefile huge pagesize=2097152 dirty=1 N0=1
> > 7f302441a000 default file=/usr/lib64/libc-2.17.so pagesize=4096 mapped=65 mapmax=38 N0=65
> > 
> > Signed-off-by: Petr Holasek <pholasek@redhat.com>
> 
> I guess the existing "huge" is insufficient on platforms that support 
> multiple hugepage sizes.

Why do you think so? pagesize= could also distinguish between multiple hugepage
sizes.

-- 
Petr Holasek
pholasek@redhat.com
