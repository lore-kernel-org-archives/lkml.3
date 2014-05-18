Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaERO6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 10:58:22 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63683 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaERO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 10:58:20 -0400
Message-ID: <5378CA88.3080105@gmail.com>
Date: Sun, 18 May 2014 17:58:16 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org,
        Sagi Manole <sagi.manole@gmail.com>
CC: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, willy@linux.intel.com
Subject: Re: [PATCH v7 00/22] Support ext4 on NV-DIMMs
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395591795.git.matthew.r.wilcox@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2014 09:08 PM, Matthew Wilcox wrote:
> One of the primary uses for NV-DIMMs is to expose them as a block device
> and use a filesystem to store files on the NV-DIMM.  While that works,
> it currently wastes memory and CPU time buffering the files in the page
> cache.  We have support in ext2 for bypassing the page cache, but it
> has some races which are unfixable in the current design.  This series
> of patches rewrite the underlying support, and add support for direct
> access to ext4.
> 
> This iteration of the patchset rebases to Linus' 3.14-rc7 (plus Kirill's
> patches in linux-next http://marc.info/?l=linux-mm&m=139206489208546&w=2)


Hi Matthew

We are experimenting with NV-DIMMs. The experiment will use its own
FS not based on ext4 at all, more like the infamous PMFS but we want
to start DAX based and not current XIP based. We want to make sure the proposed
new API can be utilized stand alone and there are no extX based assumptions.
(Like the need for direct directory access instead of the ext4
 copy-from-nvdimm-to-ram directory)

Could you please put these patches on a public tree somewhere, or perhaps some
later version, that I can pull directly from? this would help alot.

These patches are a bit hard to patch because it is not clear what
Kirill's patches I need. I tried some linux-next version around 3.14-rc7 that
also include Kirill's patches but it looks like there was farther work done
then your base. I was able to produce a tree with V6 of your
patches but I would hate to do that manual work yet again.
(Any linux base is fine just that I can pull it)
Thanks

Also I'm curios. I see you guys where working on PMFS for a while
fixing and enhancing stuff. Then development stopped and these DAX
patches started showing. Now, PMFS is based on current XIP (I was able
to easily port it to 3.14-rc7). Do you guys have an Internal attempt
to port PMFS to DAX? (We might do it in future just as an exercise
to get intimate with DAX and to make sure nothing is missing.)
What are your plans with PMFS is it dead?

Good day
Boaz



> and fixes several bugs:
> 
>  - Initialise cow_page in do_page_mkwrite() (Matthew Wilcox)
>  - Clear new or unwritten blocks in page fault handler (Matthew Wilcox)
>  - Only call get_block when necessary (Matthew Wilcox)
>  - Reword Kconfig options (Matthew Wilcox / Vishal Verma)
>  - Fix a race between page fault and truncate (Matthew Wilcox)
>  - Fix a race between fault-for-read and fault-for-write (Matthew Wilcox)
>  - Zero the correct bytes in dax_new_buf() (Toshi Kani)
>  - Add DIO_LOCKING to an invocation of dax_do_io in ext4 (Ross Zwisler)
> 
> Relative to the last patchset, I folded the 'Add reporting of major faults'
> patch into the patch that adds the DAX page fault handler.
> 
> The v6 patchset had seven additional xfstests failures.  This patchset
> now passes approximately as many xfstests as ext4 does on a ramdisk.
> 


