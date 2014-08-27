Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936113AbaH0XFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:05:05 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:38931 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935682AbaH0XFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:05:03 -0400
Date: Thu, 28 Aug 2014 00:04:40 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v10 00/21] Support ext4 on NV-DIMMs
Message-ID: <20140828000440.5d9f5bff@alan.etchedpixels.co.uk>
In-Reply-To: <20140827143055.5210c5fb9696e460b456eb26@linux-foundation.org>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
	<20140827130613.c8f6790093d279a447196f17@linux-foundation.org>
	<alpine.DEB.2.11.1408271616070.17080@gentwo.org>
	<20140827143055.5210c5fb9696e460b456eb26@linux-foundation.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 14:30:55 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 27 Aug 2014 16:22:20 -0500 (CDT) Christoph Lameter <cl@linux.com> wrote:
> 
> > > Some explanation of why one would use ext4 instead of, say,
> > > suitably-modified ramfs/tmpfs/rd/etc?
> > 
> > The NVDIMM contents survive reboot and therefore ramfs and friends wont
> > work with it.
> 
> See "suitably modified".  Presumably this type of memory would need to
> come from a particular page allocator zone.  ramfs would be unweildy
> due to its use to dentry/inode caches, but rd/etc should be feasible.

If you took one of the existing ramfs types you would then need to

- make it persistent in its storage, and put all the objects in the store
- add journalling for failures mid transaction. Your dimm may retain its
  bits but if your CPU reset mid fs operation its got to be recovered
- write an fsck tool for it
- validate it

at which point it's probably turned into ext4 8)

It's persistent but that doesn't solve the 'my box crashed' problem. 

Alan
