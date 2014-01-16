Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaAPKjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:39:13 -0500
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:18187
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190AbaAPKiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:38:54 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21a7h1fc6hzzz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: <hongbo.zhang@freescale.com>
To: <rob@landley.net>, <linux-doc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Hongbo Zhang <hongbo.zhang@freescale.com>,
        "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, <sumit.semwal@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] Documentation: move all DMA documentations into Documentaion/dma
Date: Thu, 16 Jan 2014 18:37:43 +0800
Message-ID: <1389868664-10202-1-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Since there are already seven DMA documentations under the top Documentation/,
it is better to create one dedicated directory for them.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: David S. Miller <davem@redhat.com>
Cc: Richard Henderson <rth@cygnus.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arthur Kepner <akepner@sgi.com>
Cc: sumit.semwal@linaro.org
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/DMA-API-HOWTO.txt       |  915 ---------------------------------
 Documentation/DMA-API.txt             |  700 -------------------------
 Documentation/DMA-ISA-LPC.txt         |  151 ------
 Documentation/DMA-attributes.txt      |  102 ----
 Documentation/dma-buf-sharing.txt     |  462 -----------------
 Documentation/dma/DMA-API-HOWTO.txt   |  915 +++++++++++++++++++++++++++++++++
 Documentation/dma/DMA-API.txt         |  700 +++++++++++++++++++++++++
 Documentation/dma/DMA-ISA-LPC.txt     |  151 ++++++
 Documentation/dma/DMA-attributes.txt  |  102 ++++
 Documentation/dma/dma-buf-sharing.txt |  462 +++++++++++++++++
 Documentation/dma/dmaengine.txt       |  198 +++++++
 Documentation/dma/dmatest.txt         |   92 ++++
 Documentation/dmaengine.txt           |  198 -------
 Documentation/dmatest.txt             |   92 ----
 14 files changed, 2620 insertions(+), 2620 deletions(-)
 delete mode 100644 Documentation/DMA-API-HOWTO.txt
 delete mode 100644 Documentation/DMA-API.txt
 delete mode 100644 Documentation/DMA-ISA-LPC.txt
 delete mode 100644 Documentation/DMA-attributes.txt
 delete mode 100644 Documentation/dma-buf-sharing.txt
 create mode 100644 Documentation/dma/DMA-API-HOWTO.txt
 create mode 100644 Documentation/dma/DMA-API.txt
 create mode 100644 Documentation/dma/DMA-ISA-LPC.txt
 create mode 100644 Documentation/dma/DMA-attributes.txt
 create mode 100644 Documentation/dma/dma-buf-sharing.txt
 create mode 100644 Documentation/dma/dmaengine.txt
 create mode 100644 Documentation/dma/dmatest.txt
 delete mode 100644 Documentation/dmaengine.txt
 delete mode 100644 Documentation/dmatest.txt

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
deleted file mode 100644
index 5e98303..0000000
--- a/Documentation/DMA-API-HOWTO.txt
+++ /dev/null
@@ -1,915 +0,0 @@
-		     Dynamic DMA mapping Guide
-		     =========================
-
-		 David S. Miller <davem@redhat.com>
-		 Richard Henderson <rth@cygnus.com>
-		  Jakub Jelinek <jakub@redhat.com>
-
-This is a guide to device driver writers on how to use the DMA API
-with example pseudo-code.  For a concise description of the API, see
-DMA-API.txt.
-
-Most of the 64bit platforms have special hardware that translates bus
-addresses (DMA addresses) into physical addresses.  This is similar to
-how page tables and/or a TLB translates virtual addresses to physical
-addresses on a CPU.  This is needed so that e.g. PCI devices can
-access with a Single Address Cycle (32bit DMA address) any page in the
-64bit physical address space.  Previously in Linux those 64bit
-platforms had to set artificial limits on the maximum RAM size in the
-system, so that the virt_to_bus() static scheme works (the DMA address
-translation tables were simply filled on bootup to map each bus
-address to the physical page __pa(bus_to_virt())).
-
-So that Linux can use the dynamic DMA mapping, it needs some help from the
-drivers, namely it has to take into account that DMA addresses should be
-mapped only for the time they are actually used and unmapped after the DMA
-transfer.
-
-The following API will work of course even on platforms where no such
-hardware exists.
-
-Note that the DMA API works with any bus independent of the underlying
-microprocessor architecture. You should use the DMA API rather than
-the bus specific DMA API (e.g. pci_dma_*).
-
-First of all, you should make sure
-
-#include <linux/dma-mapping.h>
-
-is in your driver. This file will obtain for you the definition of the
-dma_addr_t (which can hold any valid DMA address for the platform)
-type which should be used everywhere you hold a DMA (bus) address
-returned from the DMA mapping functions.
-
-			 What memory is DMA'able?
-
-The first piece of information you must know is what kernel memory can
-be used with the DMA mapping facilities.  There has been an unwritten
-set of rules regarding this, and this text is an attempt to finally
-write them down.
-
-If you acquired your memory via the page allocator
-(i.e. __get_free_page*()) or the generic memory allocators
-(i.e. kmalloc() or kmem_cache_alloc()) then you may DMA to/from
-that memory using the addresses returned from those routines.
-
-This means specifically that you may _not_ use the memory/addresses
-returned from vmalloc() for DMA.  It is possible to DMA to the
-_underlying_ memory mapped into a vmalloc() area, but this requires
-walking page tables to get the physical addresses, and then
-translating each of those pages back to a kernel address using
-something like __va().  [ EDIT: Update this when we integrate
-Gerd Knorr's generic code which does this. ]
-
-This rule also means that you may use neither kernel image addresses
-(items in data/text/bss segments), nor module image addresses, nor
-stack addresses for DMA.  These could all be mapped somewhere entirely
-different than the rest of physical memory.  Even if those classes of
-memory could physically work with DMA, you'd need to ensure the I/O
-buffers were cacheline-aligned.  Without that, you'd see cacheline
-sharing problems (data corruption) on CPUs with DMA-incoherent caches.
-(The CPU could write to one word, DMA would write to a different one
-in the same cache line, and one of them could be overwritten.)
-
-Also, this means that you cannot take the return of a kmap()
-call and DMA to/from that.  This is similar to vmalloc().
-
-What about block I/O and networking buffers?  The block I/O and
-networking subsystems make sure that the buffers they use are valid
-for you to DMA from/to.
-
-			DMA addressing limitations
-
-Does your device have any DMA addressing limitations?  For example, is
-your device only capable of driving the low order 24-bits of address?
-If so, you need to inform the kernel of this fact.
-
-By default, the kernel assumes that your device can address the full
-32-bits.  For a 64-bit capable device, this needs to be increased.
-And for a device with limitations, as discussed in the previous
-paragraph, it needs to be decreased.
-
-Special note about PCI: PCI-X specification requires PCI-X devices to
-support 64-bit addressing (DAC) for all transactions.  And at least
-one platform (SGI SN2) requires 64-bit consistent allocations to
-operate correctly when the IO bus is in PCI-X mode.
-
-For correct operation, you must interrogate the kernel in your device
-probe routine to see if the DMA controller on the machine can properly
-support the DMA addressing limitation your device has.  It is good
-style to do this even if your device holds the default setting,
-because this shows that you did think about these issues wrt. your
-device.
-
-The query is performed via a call to dma_set_mask_and_coherent():
-
-	int dma_set_mask_and_coherent(struct device *dev, u64 mask);
-
-which will query the mask for both streaming and coherent APIs together.
-If you have some special requirements, then the following two separate
-queries can be used instead:
-
-	The query for streaming mappings is performed via a call to
-	dma_set_mask():
-
-		int dma_set_mask(struct device *dev, u64 mask);
-
-	The query for consistent allocations is performed via a call
-	to dma_set_coherent_mask():
-
-		int dma_set_coherent_mask(struct device *dev, u64 mask);
-
-Here, dev is a pointer to the device struct of your device, and mask
-is a bit mask describing which bits of an address your device
-supports.  It returns zero if your card can perform DMA properly on
-the machine given the address mask you provided.  In general, the
-device struct of your device is embedded in the bus specific device
-struct of your device.  For example, a pointer to the device struct of
-your PCI device is pdev->dev (pdev is a pointer to the PCI device
-struct of your device).
-
-If it returns non-zero, your device cannot perform DMA properly on
-this platform, and attempting to do so will result in undefined
-behavior.  You must either use a different mask, or not use DMA.
-
-This means that in the failure case, you have three options:
-
-1) Use another DMA mask, if possible (see below).
-2) Use some non-DMA mode for data transfer, if possible.
-3) Ignore this device and do not initialize it.
-
-It is recommended that your driver print a kernel KERN_WARNING message
-when you end up performing either #2 or #3.  In this manner, if a user
-of your driver reports that performance is bad or that the device is not
-even detected, you can ask them for the kernel messages to find out
-exactly why.
-
-The standard 32-bit addressing device would do something like this:
-
-	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
-		printk(KERN_WARNING
-		       "mydev: No suitable DMA available.\n");
-		goto ignore_this_device;
-	}
-
-Another common scenario is a 64-bit capable device.  The approach here
-is to try for 64-bit addressing, but back down to a 32-bit mask that
-should not fail.  The kernel may fail the 64-bit mask not because the
-platform is not capable of 64-bit addressing.  Rather, it may fail in
-this case simply because 32-bit addressing is done more efficiently
-than 64-bit addressing.  For example, Sparc64 PCI SAC addressing is
-more efficient than DAC addressing.
-
-Here is how you would handle a 64-bit capable device which can drive
-all 64-bits when accessing streaming DMA:
-
-	int using_dac;
-
-	if (!dma_set_mask(dev, DMA_BIT_MASK(64))) {
-		using_dac = 1;
-	} else if (!dma_set_mask(dev, DMA_BIT_MASK(32))) {
-		using_dac = 0;
-	} else {
-		printk(KERN_WARNING
-		       "mydev: No suitable DMA available.\n");
-		goto ignore_this_device;
-	}
-
-If a card is capable of using 64-bit consistent allocations as well,
-the case would look like this:
-
-	int using_dac, consistent_using_dac;
-
-	if (!dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64))) {
-		using_dac = 1;
-	   	consistent_using_dac = 1;
-	} else if (!dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
-		using_dac = 0;
-		consistent_using_dac = 0;
-	} else {
-		printk(KERN_WARNING
-		       "mydev: No suitable DMA available.\n");
-		goto ignore_this_device;
-	}
-
-The coherent coherent mask will always be able to set the same or a
-smaller mask as the streaming mask. However for the rare case that a
-device driver only uses consistent allocations, one would have to
-check the return value from dma_set_coherent_mask().
-
-Finally, if your device can only drive the low 24-bits of
-address you might do something like:
-
-	if (dma_set_mask(dev, DMA_BIT_MASK(24))) {
-		printk(KERN_WARNING
-		       "mydev: 24-bit DMA addressing not available.\n");
-		goto ignore_this_device;
-	}
-
-When dma_set_mask() or dma_set_mask_and_coherent() is successful, and
-returns zero, the kernel saves away this mask you have provided.  The
-kernel will use this information later when you make DMA mappings.
-
-There is a case which we are aware of at this time, which is worth
-mentioning in this documentation.  If your device supports multiple
-functions (for example a sound card provides playback and record
-functions) and the various different functions have _different_
-DMA addressing limitations, you may wish to probe each mask and
-only provide the functionality which the machine can handle.  It
-is important that the last call to dma_set_mask() be for the
-most specific mask.
-
-Here is pseudo-code showing how this might be done:
-
-	#define PLAYBACK_ADDRESS_BITS	DMA_BIT_MASK(32)
-	#define RECORD_ADDRESS_BITS	DMA_BIT_MASK(24)
-
-	struct my_sound_card *card;
-	struct device *dev;
-
-	...
-	if (!dma_set_mask(dev, PLAYBACK_ADDRESS_BITS)) {
-		card->playback_enabled = 1;
-	} else {
-		card->playback_enabled = 0;
-		printk(KERN_WARNING "%s: Playback disabled due to DMA limitations.\n",
-		       card->name);
-	}
-	if (!dma_set_mask(dev, RECORD_ADDRESS_BITS)) {
-		card->record_enabled = 1;
-	} else {
-		card->record_enabled = 0;
-		printk(KERN_WARNING "%s: Record disabled due to DMA limitations.\n",
-		       card->name);
-	}
-
-A sound card was used as an example here because this genre of PCI
-devices seems to be littered with ISA chips given a PCI front end,
-and thus retaining the 16MB DMA addressing limitations of ISA.
-
-			Types of DMA mappings
-
-There are two types of DMA mappings:
-
-- Consistent DMA mappings which are usually mapped at driver
-  initialization, unmapped at the end and for which the hardware should
-  guarantee that the device and the CPU can access the data
-  in parallel and will see updates made by each other without any
-  explicit software flushing.
-
-  Think of "consistent" as "synchronous" or "coherent".
-
-  The current default is to return consistent memory in the low 32
-  bits of the bus space.  However, for future compatibility you should
-  set the consistent mask even if this default is fine for your
-  driver.
-
-  Good examples of what to use consistent mappings for are:
-
-	- Network card DMA ring descriptors.
-	- SCSI adapter mailbox command data structures.
-	- Device firmware microcode executed out of
-	  main memory.
-
-  The invariant these examples all require is that any CPU store
-  to memory is immediately visible to the device, and vice
-  versa.  Consistent mappings guarantee this.
-
-  IMPORTANT: Consistent DMA memory does not preclude the usage of
-             proper memory barriers.  The CPU may reorder stores to
-	     consistent memory just as it may normal memory.  Example:
-	     if it is important for the device to see the first word
-	     of a descriptor updated before the second, you must do
-	     something like:
-
-		desc->word0 = address;
-		wmb();
-		desc->word1 = DESC_VALID;
-
-             in order to get correct behavior on all platforms.
-
-	     Also, on some platforms your driver may need to flush CPU write
-	     buffers in much the same way as it needs to flush write buffers
-	     found in PCI bridges (such as by reading a register's value
-	     after writing it).
-
-- Streaming DMA mappings which are usually mapped for one DMA
-  transfer, unmapped right after it (unless you use dma_sync_* below)
-  and for which hardware can optimize for sequential accesses.
-
-  This of "streaming" as "asynchronous" or "outside the coherency
-  domain".
-
-  Good examples of what to use streaming mappings for are:
-
-	- Networking buffers transmitted/received by a device.
-	- Filesystem buffers written/read by a SCSI device.
-
-  The interfaces for using this type of mapping were designed in
-  such a way that an implementation can make whatever performance
-  optimizations the hardware allows.  To this end, when using
-  such mappings you must be explicit about what you want to happen.
-
-Neither type of DMA mapping has alignment restrictions that come from
-the underlying bus, although some devices may have such restrictions.
-Also, systems with caches that aren't DMA-coherent will work better
-when the underlying buffers don't share cache lines with other data.
-
-
-		 Using Consistent DMA mappings.
-
-To allocate and map large (PAGE_SIZE or so) consistent DMA regions,
-you should do:
-
-	dma_addr_t dma_handle;
-
-	cpu_addr = dma_alloc_coherent(dev, size, &dma_handle, gfp);
-
-where device is a struct device *. This may be called in interrupt
-context with the GFP_ATOMIC flag.
-
-Size is the length of the region you want to allocate, in bytes.
-
-This routine will allocate RAM for that region, so it acts similarly to
-__get_free_pages (but takes size instead of a page order).  If your
-driver needs regions sized smaller than a page, you may prefer using
-the dma_pool interface, described below.
-
-The consistent DMA mapping interfaces, for non-NULL dev, will by
-default return a DMA address which is 32-bit addressable.  Even if the
-device indicates (via DMA mask) that it may address the upper 32-bits,
-consistent allocation will only return > 32-bit addresses for DMA if
-the consistent DMA mask has been explicitly changed via
-dma_set_coherent_mask().  This is true of the dma_pool interface as
-well.
-
-dma_alloc_coherent returns two values: the virtual address which you
-can use to access it from the CPU and dma_handle which you pass to the
-card.
-
-The cpu return address and the DMA bus master address are both
-guaranteed to be aligned to the smallest PAGE_SIZE order which
-is greater than or equal to the requested size.  This invariant
-exists (for example) to guarantee that if you allocate a chunk
-which is smaller than or equal to 64 kilobytes, the extent of the
-buffer you receive will not cross a 64K boundary.
-
-To unmap and free such a DMA region, you call:
-
-	dma_free_coherent(dev, size, cpu_addr, dma_handle);
-
-where dev, size are the same as in the above call and cpu_addr and
-dma_handle are the values dma_alloc_coherent returned to you.
-This function may not be called in interrupt context.
-
-If your driver needs lots of smaller memory regions, you can write
-custom code to subdivide pages returned by dma_alloc_coherent,
-or you can use the dma_pool API to do that.  A dma_pool is like
-a kmem_cache, but it uses dma_alloc_coherent not __get_free_pages.
-Also, it understands common hardware constraints for alignment,
-like queue heads needing to be aligned on N byte boundaries.
-
-Create a dma_pool like this:
-
-	struct dma_pool *pool;
-
-	pool = dma_pool_create(name, dev, size, align, alloc);
-
-The "name" is for diagnostics (like a kmem_cache name); dev and size
-are as above.  The device's hardware alignment requirement for this
-type of data is "align" (which is expressed in bytes, and must be a
-power of two).  If your device has no boundary crossing restrictions,
-pass 0 for alloc; passing 4096 says memory allocated from this pool
-must not cross 4KByte boundaries (but at that time it may be better to
-go for dma_alloc_coherent directly instead).
-
-Allocate memory from a dma pool like this:
-
-	cpu_addr = dma_pool_alloc(pool, flags, &dma_handle);
-
-flags are SLAB_KERNEL if blocking is permitted (not in_interrupt nor
-holding SMP locks), SLAB_ATOMIC otherwise.  Like dma_alloc_coherent,
-this returns two values, cpu_addr and dma_handle.
-
-Free memory that was allocated from a dma_pool like this:
-
-	dma_pool_free(pool, cpu_addr, dma_handle);
-
-where pool is what you passed to dma_pool_alloc, and cpu_addr and
-dma_handle are the values dma_pool_alloc returned. This function
-may be called in interrupt context.
-
-Destroy a dma_pool by calling:
-
-	dma_pool_destroy(pool);
-
-Make sure you've called dma_pool_free for all memory allocated
-from a pool before you destroy the pool. This function may not
-be called in interrupt context.
-
-			DMA Direction
-
-The interfaces described in subsequent portions of this document
-take a DMA direction argument, which is an integer and takes on
-one of the following values:
-
- DMA_BIDIRECTIONAL
- DMA_TO_DEVICE
- DMA_FROM_DEVICE
- DMA_NONE
-
-One should provide the exact DMA direction if you know it.
-
-DMA_TO_DEVICE means "from main memory to the device"
-DMA_FROM_DEVICE means "from the device to main memory"
-It is the direction in which the data moves during the DMA
-transfer.
-
-You are _strongly_ encouraged to specify this as precisely
-as you possibly can.
-
-If you absolutely cannot know the direction of the DMA transfer,
-specify DMA_BIDIRECTIONAL.  It means that the DMA can go in
-either direction.  The platform guarantees that you may legally
-specify this, and that it will work, but this may be at the
-cost of performance for example.
-
-The value DMA_NONE is to be used for debugging.  One can
-hold this in a data structure before you come to know the
-precise direction, and this will help catch cases where your
-direction tracking logic has failed to set things up properly.
-
-Another advantage of specifying this value precisely (outside of
-potential platform-specific optimizations of such) is for debugging.
-Some platforms actually have a write permission boolean which DMA
-mappings can be marked with, much like page protections in the user
-program address space.  Such platforms can and do report errors in the
-kernel logs when the DMA controller hardware detects violation of the
-permission setting.
-
-Only streaming mappings specify a direction, consistent mappings
-implicitly have a direction attribute setting of
-DMA_BIDIRECTIONAL.
-
-The SCSI subsystem tells you the direction to use in the
-'sc_data_direction' member of the SCSI command your driver is
-working on.
-
-For Networking drivers, it's a rather simple affair.  For transmit
-packets, map/unmap them with the DMA_TO_DEVICE direction
-specifier.  For receive packets, just the opposite, map/unmap them
-with the DMA_FROM_DEVICE direction specifier.
-
-		  Using Streaming DMA mappings
-
-The streaming DMA mapping routines can be called from interrupt
-context.  There are two versions of each map/unmap, one which will
-map/unmap a single memory region, and one which will map/unmap a
-scatterlist.
-
-To map a single region, you do:
-
-	struct device *dev = &my_dev->dev;
-	dma_addr_t dma_handle;
-	void *addr = buffer->ptr;
-	size_t size = buffer->len;
-
-	dma_handle = dma_map_single(dev, addr, size, direction);
-	if (dma_mapping_error(dma_handle)) {
-		/*
-		 * reduce current DMA mapping usage,
-		 * delay and try again later or
-		 * reset driver.
-		 */
-		goto map_error_handling;
-	}
-
-and to unmap it:
-
-	dma_unmap_single(dev, dma_handle, size, direction);
-
-You should call dma_mapping_error() as dma_map_single() could fail and return
-error. Not all dma implementations support dma_mapping_error() interface.
-However, it is a good practice to call dma_mapping_error() interface, which
-will invoke the generic mapping error check interface. Doing so will ensure
-that the mapping code will work correctly on all dma implementations without
-any dependency on the specifics of the underlying implementation. Using the
-returned address without checking for errors could result in failures ranging
-from panics to silent data corruption. A couple of examples of incorrect ways
-to check for errors that make assumptions about the underlying dma
-implementation are as follows and these are applicable to dma_map_page() as
-well.
-
-Incorrect example 1:
-	dma_addr_t dma_handle;
-
-	dma_handle = dma_map_single(dev, addr, size, direction);
-	if ((dma_handle & 0xffff != 0) || (dma_handle >= 0x1000000)) {
-		goto map_error;
-	}
-
-Incorrect example 2:
-	dma_addr_t dma_handle;
-
-	dma_handle = dma_map_single(dev, addr, size, direction);
-	if (dma_handle == DMA_ERROR_CODE) {
-		goto map_error;
-	}
-
-You should call dma_unmap_single when the DMA activity is finished, e.g.
-from the interrupt which told you that the DMA transfer is done.
-
-Using cpu pointers like this for single mappings has a disadvantage,
-you cannot reference HIGHMEM memory in this way.  Thus, there is a
-map/unmap interface pair akin to dma_{map,unmap}_single.  These
-interfaces deal with page/offset pairs instead of cpu pointers.
-Specifically:
-
-	struct device *dev = &my_dev->dev;
-	dma_addr_t dma_handle;
-	struct page *page = buffer->page;
-	unsigned long offset = buffer->offset;
-	size_t size = buffer->len;
-
-	dma_handle = dma_map_page(dev, page, offset, size, direction);
-	if (dma_mapping_error(dma_handle)) {
-		/*
-		 * reduce current DMA mapping usage,
-		 * delay and try again later or
-		 * reset driver.
-		 */
-		goto map_error_handling;
-	}
-
-	...
-
-	dma_unmap_page(dev, dma_handle, size, direction);
-
-Here, "offset" means byte offset within the given page.
-
-You should call dma_mapping_error() as dma_map_page() could fail and return
-error as outlined under the dma_map_single() discussion.
-
-You should call dma_unmap_page when the DMA activity is finished, e.g.
-from the interrupt which told you that the DMA transfer is done.
-
-With scatterlists, you map a region gathered from several regions by:
-
-	int i, count = dma_map_sg(dev, sglist, nents, direction);
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, count, i) {
-		hw_address[i] = sg_dma_address(sg);
-		hw_len[i] = sg_dma_len(sg);
-	}
-
-where nents is the number of entries in the sglist.
-
-The implementation is free to merge several consecutive sglist entries
-into one (e.g. if DMA mapping is done with PAGE_SIZE granularity, any
-consecutive sglist entries can be merged into one provided the first one
-ends and the second one starts on a page boundary - in fact this is a huge
-advantage for cards which either cannot do scatter-gather or have very
-limited number of scatter-gather entries) and returns the actual number
-of sg entries it mapped them to. On failure 0 is returned.
-
-Then you should loop count times (note: this can be less than nents times)
-and use sg_dma_address() and sg_dma_len() macros where you previously
-accessed sg->address and sg->length as shown above.
-
-To unmap a scatterlist, just call:
-
-	dma_unmap_sg(dev, sglist, nents, direction);
-
-Again, make sure DMA activity has already finished.
-
-PLEASE NOTE:  The 'nents' argument to the dma_unmap_sg call must be
-              the _same_ one you passed into the dma_map_sg call,
-	      it should _NOT_ be the 'count' value _returned_ from the
-              dma_map_sg call.
-
-Every dma_map_{single,sg} call should have its dma_unmap_{single,sg}
-counterpart, because the bus address space is a shared resource (although
-in some ports the mapping is per each BUS so less devices contend for the
-same bus address space) and you could render the machine unusable by eating
-all bus addresses.
-
-If you need to use the same streaming DMA region multiple times and touch
-the data in between the DMA transfers, the buffer needs to be synced
-properly in order for the cpu and device to see the most uptodate and
-correct copy of the DMA buffer.
-
-So, firstly, just map it with dma_map_{single,sg}, and after each DMA
-transfer call either:
-
-	dma_sync_single_for_cpu(dev, dma_handle, size, direction);
-
-or:
-
-	dma_sync_sg_for_cpu(dev, sglist, nents, direction);
-
-as appropriate.
-
-Then, if you wish to let the device get at the DMA area again,
-finish accessing the data with the cpu, and then before actually
-giving the buffer to the hardware call either:
-
-	dma_sync_single_for_device(dev, dma_handle, size, direction);
-
-or:
-
-	dma_sync_sg_for_device(dev, sglist, nents, direction);
-
-as appropriate.
-
-After the last DMA transfer call one of the DMA unmap routines
-dma_unmap_{single,sg}. If you don't touch the data from the first dma_map_*
-call till dma_unmap_*, then you don't have to call the dma_sync_*
-routines at all.
-
-Here is pseudo code which shows a situation in which you would need
-to use the dma_sync_*() interfaces.
-
-	my_card_setup_receive_buffer(struct my_card *cp, char *buffer, int len)
-	{
-		dma_addr_t mapping;
-
-		mapping = dma_map_single(cp->dev, buffer, len, DMA_FROM_DEVICE);
-		if (dma_mapping_error(dma_handle)) {
-			/*
-			 * reduce current DMA mapping usage,
-			 * delay and try again later or
-			 * reset driver.
-			 */
-			goto map_error_handling;
-		}
-
-		cp->rx_buf = buffer;
-		cp->rx_len = len;
-		cp->rx_dma = mapping;
-
-		give_rx_buf_to_card(cp);
-	}
-
-	...
-
-	my_card_interrupt_handler(int irq, void *devid, struct pt_regs *regs)
-	{
-		struct my_card *cp = devid;
-
-		...
-		if (read_card_status(cp) == RX_BUF_TRANSFERRED) {
-			struct my_card_header *hp;
-
-			/* Examine the header to see if we wish
-			 * to accept the data.  But synchronize
-			 * the DMA transfer with the CPU first
-			 * so that we see updated contents.
-			 */
-			dma_sync_single_for_cpu(&cp->dev, cp->rx_dma,
-						cp->rx_len,
-						DMA_FROM_DEVICE);
-
-			/* Now it is safe to examine the buffer. */
-			hp = (struct my_card_header *) cp->rx_buf;
-			if (header_is_ok(hp)) {
-				dma_unmap_single(&cp->dev, cp->rx_dma, cp->rx_len,
-						 DMA_FROM_DEVICE);
-				pass_to_upper_layers(cp->rx_buf);
-				make_and_setup_new_rx_buf(cp);
-			} else {
-				/* CPU should not write to
-				 * DMA_FROM_DEVICE-mapped area,
-				 * so dma_sync_single_for_device() is
-				 * not needed here. It would be required
-				 * for DMA_BIDIRECTIONAL mapping if
-				 * the memory was modified.
-				 */
-				give_rx_buf_to_card(cp);
-			}
-		}
-	}
-
-Drivers converted fully to this interface should not use virt_to_bus any
-longer, nor should they use bus_to_virt. Some drivers have to be changed a
-little bit, because there is no longer an equivalent to bus_to_virt in the
-dynamic DMA mapping scheme - you have to always store the DMA addresses
-returned by the dma_alloc_coherent, dma_pool_alloc, and dma_map_single
-calls (dma_map_sg stores them in the scatterlist itself if the platform
-supports dynamic DMA mapping in hardware) in your driver structures and/or
-in the card registers.
-
-All drivers should be using these interfaces with no exceptions.  It
-is planned to completely remove virt_to_bus() and bus_to_virt() as
-they are entirely deprecated.  Some ports already do not provide these
-as it is impossible to correctly support them.
-
-			Handling Errors
-
-DMA address space is limited on some architectures and an allocation
-failure can be determined by:
-
-- checking if dma_alloc_coherent returns NULL or dma_map_sg returns 0
-
-- checking the returned dma_addr_t of dma_map_single and dma_map_page
-  by using dma_mapping_error():
-
-	dma_addr_t dma_handle;
-
-	dma_handle = dma_map_single(dev, addr, size, direction);
-	if (dma_mapping_error(dev, dma_handle)) {
-		/*
-		 * reduce current DMA mapping usage,
-		 * delay and try again later or
-		 * reset driver.
-		 */
-		goto map_error_handling;
-	}
-
-- unmap pages that are already mapped, when mapping error occurs in the middle
-  of a multiple page mapping attempt. These example are applicable to
-  dma_map_page() as well.
-
-Example 1:
-	dma_addr_t dma_handle1;
-	dma_addr_t dma_handle2;
-
-	dma_handle1 = dma_map_single(dev, addr, size, direction);
-	if (dma_mapping_error(dev, dma_handle1)) {
-		/*
-		 * reduce current DMA mapping usage,
-		 * delay and try again later or
-		 * reset driver.
-		 */
-		goto map_error_handling1;
-	}
-	dma_handle2 = dma_map_single(dev, addr, size, direction);
-	if (dma_mapping_error(dev, dma_handle2)) {
-		/*
-		 * reduce current DMA mapping usage,
-		 * delay and try again later or
-		 * reset driver.
-		 */
-		goto map_error_handling2;
-	}
-
-	...
-
-	map_error_handling2:
-		dma_unmap_single(dma_handle1);
-	map_error_handling1:
-
-Example 2: (if buffers are allocated in a loop, unmap all mapped buffers when
-	    mapping error is detected in the middle)
-
-	dma_addr_t dma_addr;
-	dma_addr_t array[DMA_BUFFERS];
-	int save_index = 0;
-
-	for (i = 0; i < DMA_BUFFERS; i++) {
-
-		...
-
-		dma_addr = dma_map_single(dev, addr, size, direction);
-		if (dma_mapping_error(dev, dma_addr)) {
-			/*
-			 * reduce current DMA mapping usage,
-			 * delay and try again later or
-			 * reset driver.
-			 */
-			goto map_error_handling;
-		}
-		array[i].dma_addr = dma_addr;
-		save_index++;
-	}
-
-	...
-
-	map_error_handling:
-
-	for (i = 0; i < save_index; i++) {
-
-		...
-
-		dma_unmap_single(array[i].dma_addr);
-	}
-
-Networking drivers must call dev_kfree_skb to free the socket buffer
-and return NETDEV_TX_OK if the DMA mapping fails on the transmit hook
-(ndo_start_xmit). This means that the socket buffer is just dropped in
-the failure case.
-
-SCSI drivers must return SCSI_MLQUEUE_HOST_BUSY if the DMA mapping
-fails in the queuecommand hook. This means that the SCSI subsystem
-passes the command to the driver again later.
-
-		Optimizing Unmap State Space Consumption
-
-On many platforms, dma_unmap_{single,page}() is simply a nop.
-Therefore, keeping track of the mapping address and length is a waste
-of space.  Instead of filling your drivers up with ifdefs and the like
-to "work around" this (which would defeat the whole purpose of a
-portable API) the following facilities are provided.
-
-Actually, instead of describing the macros one by one, we'll
-transform some example code.
-
-1) Use DEFINE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
-   Example, before:
-
-	struct ring_state {
-		struct sk_buff *skb;
-		dma_addr_t mapping;
-		__u32 len;
-	};
-
-   after:
-
-	struct ring_state {
-		struct sk_buff *skb;
-		DEFINE_DMA_UNMAP_ADDR(mapping);
-		DEFINE_DMA_UNMAP_LEN(len);
-	};
-
-2) Use dma_unmap_{addr,len}_set to set these values.
-   Example, before:
-
-	ringp->mapping = FOO;
-	ringp->len = BAR;
-
-   after:
-
-	dma_unmap_addr_set(ringp, mapping, FOO);
-	dma_unmap_len_set(ringp, len, BAR);
-
-3) Use dma_unmap_{addr,len} to access these values.
-   Example, before:
-
-	dma_unmap_single(dev, ringp->mapping, ringp->len,
-			 DMA_FROM_DEVICE);
-
-   after:
-
-	dma_unmap_single(dev,
-			 dma_unmap_addr(ringp, mapping),
-			 dma_unmap_len(ringp, len),
-			 DMA_FROM_DEVICE);
-
-It really should be self-explanatory.  We treat the ADDR and LEN
-separately, because it is possible for an implementation to only
-need the address in order to perform the unmap operation.
-
-			Platform Issues
-
-If you are just writing drivers for Linux and do not maintain
-an architecture port for the kernel, you can safely skip down
-to "Closing".
-
-1) Struct scatterlist requirements.
-
-   Don't invent the architecture specific struct scatterlist; just use
-   <asm-generic/scatterlist.h>. You need to enable
-   CONFIG_NEED_SG_DMA_LENGTH if the architecture supports IOMMUs
-   (including software IOMMU).
-
-2) ARCH_DMA_MINALIGN
-
-   Architectures must ensure that kmalloc'ed buffer is
-   DMA-safe. Drivers and subsystems depend on it. If an architecture
-   isn't fully DMA-coherent (i.e. hardware doesn't ensure that data in
-   the CPU cache is identical to data in main memory),
-   ARCH_DMA_MINALIGN must be set so that the memory allocator
-   makes sure that kmalloc'ed buffer doesn't share a cache line with
-   the others. See arch/arm/include/asm/cache.h as an example.
-
-   Note that ARCH_DMA_MINALIGN is about DMA memory alignment
-   constraints. You don't need to worry about the architecture data
-   alignment constraints (e.g. the alignment constraints about 64-bit
-   objects).
-
-3) Supporting multiple types of IOMMUs
-
-   If your architecture needs to support multiple types of IOMMUs, you
-   can use include/linux/asm-generic/dma-mapping-common.h. It's a
-   library to support the DMA API with multiple types of IOMMUs. Lots
-   of architectures (x86, powerpc, sh, alpha, ia64, microblaze and
-   sparc) use it. Choose one to see how it can be used. If you need to
-   support multiple types of IOMMUs in a single system, the example of
-   x86 or powerpc helps.
-
-			   Closing
-
-This document, and the API itself, would not be in its current
-form without the feedback and suggestions from numerous individuals.
-We would like to specifically mention, in no particular order, the
-following people:
-
-	Russell King <rmk@arm.linux.org.uk>
-	Leo Dagum <dagum@barrel.engr.sgi.com>
-	Ralf Baechle <ralf@oss.sgi.com>
-	Grant Grundler <grundler@cup.hp.com>
-	Jay Estabrook <Jay.Estabrook@compaq.com>
-	Thomas Sailer <sailer@ife.ee.ethz.ch>
-	Andrea Arcangeli <andrea@suse.de>
-	Jens Axboe <jens.axboe@oracle.com>
-	David Mosberger-Tang <davidm@hpl.hp.com>
diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
deleted file mode 100644
index e865279..0000000
--- a/Documentation/DMA-API.txt
+++ /dev/null
@@ -1,700 +0,0 @@
-               Dynamic DMA mapping using the generic device
-               ============================================
-
-        James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
-
-This document describes the DMA API.  For a more gentle introduction
-of the API (and actual examples) see
-Documentation/DMA-API-HOWTO.txt.
-
-This API is split into two pieces.  Part I describes the API.  Part II
-describes the extensions to the API for supporting non-consistent
-memory machines.  Unless you know that your driver absolutely has to
-support non-consistent platforms (this is usually only legacy
-platforms) you should only use the API described in part I.
-
-Part I - dma_ API
--------------------------------------
-
-To get the dma_ API, you must #include <linux/dma-mapping.h>
-
-
-Part Ia - Using large dma-coherent buffers
-------------------------------------------
-
-void *
-dma_alloc_coherent(struct device *dev, size_t size,
-			     dma_addr_t *dma_handle, gfp_t flag)
-
-Consistent memory is memory for which a write by either the device or
-the processor can immediately be read by the processor or device
-without having to worry about caching effects.  (You may however need
-to make sure to flush the processor's write buffers before telling
-devices to read that memory.)
-
-This routine allocates a region of <size> bytes of consistent memory.
-It also returns a <dma_handle> which may be cast to an unsigned
-integer the same width as the bus and used as the physical address
-base of the region.
-
-Returns: a pointer to the allocated region (in the processor's virtual
-address space) or NULL if the allocation failed.
-
-Note: consistent memory can be expensive on some platforms, and the
-minimum allocation length may be as big as a page, so you should
-consolidate your requests for consistent memory as much as possible.
-The simplest way to do that is to use the dma_pool calls (see below).
-
-The flag parameter (dma_alloc_coherent only) allows the caller to
-specify the GFP_ flags (see kmalloc) for the allocation (the
-implementation may choose to ignore flags that affect the location of
-the returned memory, like GFP_DMA).
-
-void *
-dma_zalloc_coherent(struct device *dev, size_t size,
-			     dma_addr_t *dma_handle, gfp_t flag)
-
-Wraps dma_alloc_coherent() and also zeroes the returned memory if the
-allocation attempt succeeded.
-
-void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-			   dma_addr_t dma_handle)
-
-Free the region of consistent memory you previously allocated.  dev,
-size and dma_handle must all be the same as those passed into the
-consistent allocate.  cpu_addr must be the virtual address returned by
-the consistent allocate.
-
-Note that unlike their sibling allocation calls, these routines
-may only be called with IRQs enabled.
-
-
-Part Ib - Using small dma-coherent buffers
-------------------------------------------
-
-To get this part of the dma_ API, you must #include <linux/dmapool.h>
-
-Many drivers need lots of small dma-coherent memory regions for DMA
-descriptors or I/O buffers.  Rather than allocating in units of a page
-or more using dma_alloc_coherent(), you can use DMA pools.  These work
-much like a struct kmem_cache, except that they use the dma-coherent allocator,
-not __get_free_pages().  Also, they understand common hardware constraints
-for alignment, like queue heads needing to be aligned on N-byte boundaries.
-
-
-	struct dma_pool *
-	dma_pool_create(const char *name, struct device *dev,
-			size_t size, size_t align, size_t alloc);
-
-The pool create() routines initialize a pool of dma-coherent buffers
-for use with a given device.  It must be called in a context which
-can sleep.
-
-The "name" is for diagnostics (like a struct kmem_cache name); dev and size
-are like what you'd pass to dma_alloc_coherent().  The device's hardware
-alignment requirement for this type of data is "align" (which is expressed
-in bytes, and must be a power of two).  If your device has no boundary
-crossing restrictions, pass 0 for alloc; passing 4096 says memory allocated
-from this pool must not cross 4KByte boundaries.
-
-
-	void *dma_pool_alloc(struct dma_pool *pool, gfp_t gfp_flags,
-			dma_addr_t *dma_handle);
-
-This allocates memory from the pool; the returned memory will meet the size
-and alignment requirements specified at creation time.  Pass GFP_ATOMIC to
-prevent blocking, or if it's permitted (not in_interrupt, not holding SMP locks),
-pass GFP_KERNEL to allow blocking.  Like dma_alloc_coherent(), this returns
-two values:  an address usable by the cpu, and the dma address usable by the
-pool's device.
-
-
-	void dma_pool_free(struct dma_pool *pool, void *vaddr,
-			dma_addr_t addr);
-
-This puts memory back into the pool.  The pool is what was passed to
-the pool allocation routine; the cpu (vaddr) and dma addresses are what
-were returned when that routine allocated the memory being freed.
-
-
-	void dma_pool_destroy(struct dma_pool *pool);
-
-The pool destroy() routines free the resources of the pool.  They must be
-called in a context which can sleep.  Make sure you've freed all allocated
-memory back to the pool before you destroy it.
-
-
-Part Ic - DMA addressing limitations
-------------------------------------
-
-int
-dma_supported(struct device *dev, u64 mask)
-
-Checks to see if the device can support DMA to the memory described by
-mask.
-
-Returns: 1 if it can and 0 if it can't.
-
-Notes: This routine merely tests to see if the mask is possible.  It
-won't change the current mask settings.  It is more intended as an
-internal API for use by the platform than an external API for use by
-driver writers.
-
-int
-dma_set_mask_and_coherent(struct device *dev, u64 mask)
-
-Checks to see if the mask is possible and updates the device
-streaming and coherent DMA mask parameters if it is.
-
-Returns: 0 if successful and a negative error if not.
-
-int
-dma_set_mask(struct device *dev, u64 mask)
-
-Checks to see if the mask is possible and updates the device
-parameters if it is.
-
-Returns: 0 if successful and a negative error if not.
-
-int
-dma_set_coherent_mask(struct device *dev, u64 mask)
-
-Checks to see if the mask is possible and updates the device
-parameters if it is.
-
-Returns: 0 if successful and a negative error if not.
-
-u64
-dma_get_required_mask(struct device *dev)
-
-This API returns the mask that the platform requires to
-operate efficiently.  Usually this means the returned mask
-is the minimum required to cover all of memory.  Examining the
-required mask gives drivers with variable descriptor sizes the
-opportunity to use smaller descriptors as necessary.
-
-Requesting the required mask does not alter the current mask.  If you
-wish to take advantage of it, you should issue a dma_set_mask()
-call to set the mask to the value returned.
-
-
-Part Id - Streaming DMA mappings
---------------------------------
-
-dma_addr_t
-dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-		      enum dma_data_direction direction)
-
-Maps a piece of processor virtual memory so it can be accessed by the
-device and returns the physical handle of the memory.
-
-The direction for both api's may be converted freely by casting.
-However the dma_ API uses a strongly typed enumerator for its
-direction:
-
-DMA_NONE		no direction (used for debugging)
-DMA_TO_DEVICE		data is going from the memory to the device
-DMA_FROM_DEVICE		data is coming from the device to the memory
-DMA_BIDIRECTIONAL	direction isn't known
-
-Notes:  Not all memory regions in a machine can be mapped by this
-API.  Further, regions that appear to be physically contiguous in
-kernel virtual space may not be contiguous as physical memory.  Since
-this API does not provide any scatter/gather capability, it will fail
-if the user tries to map a non-physically contiguous piece of memory.
-For this reason, it is recommended that memory mapped by this API be
-obtained only from sources which guarantee it to be physically contiguous
-(like kmalloc).
-
-Further, the physical address of the memory must be within the
-dma_mask of the device (the dma_mask represents a bit mask of the
-addressable region for the device.  I.e., if the physical address of
-the memory anded with the dma_mask is still equal to the physical
-address, then the device can perform DMA to the memory).  In order to
-ensure that the memory allocated by kmalloc is within the dma_mask,
-the driver may specify various platform-dependent flags to restrict
-the physical memory range of the allocation (e.g. on x86, GFP_DMA
-guarantees to be within the first 16Mb of available physical memory,
-as required by ISA devices).
-
-Note also that the above constraints on physical contiguity and
-dma_mask may not apply if the platform has an IOMMU (a device which
-supplies a physical to virtual mapping between the I/O memory bus and
-the device).  However, to be portable, device driver writers may *not*
-assume that such an IOMMU exists.
-
-Warnings:  Memory coherency operates at a granularity called the cache
-line width.  In order for memory mapped by this API to operate
-correctly, the mapped region must begin exactly on a cache line
-boundary and end exactly on one (to prevent two separately mapped
-regions from sharing a single cache line).  Since the cache line size
-may not be known at compile time, the API will not enforce this
-requirement.  Therefore, it is recommended that driver writers who
-don't take special care to determine the cache line size at run time
-only map virtual regions that begin and end on page boundaries (which
-are guaranteed also to be cache line boundaries).
-
-DMA_TO_DEVICE synchronisation must be done after the last modification
-of the memory region by the software and before it is handed off to
-the driver.  Once this primitive is used, memory covered by this
-primitive should be treated as read-only by the device.  If the device
-may write to it at any point, it should be DMA_BIDIRECTIONAL (see
-below).
-
-DMA_FROM_DEVICE synchronisation must be done before the driver
-accesses data that may be changed by the device.  This memory should
-be treated as read-only by the driver.  If the driver needs to write
-to it at any point, it should be DMA_BIDIRECTIONAL (see below).
-
-DMA_BIDIRECTIONAL requires special handling: it means that the driver
-isn't sure if the memory was modified before being handed off to the
-device and also isn't sure if the device will also modify it.  Thus,
-you must always sync bidirectional memory twice: once before the
-memory is handed off to the device (to make sure all memory changes
-are flushed from the processor) and once before the data may be
-accessed after being used by the device (to make sure any processor
-cache lines are updated with data that the device may have changed).
-
-void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-
-Unmaps the region previously mapped.  All the parameters passed in
-must be identical to those passed in (and returned) by the mapping
-API.
-
-dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-		    unsigned long offset, size_t size,
-		    enum dma_data_direction direction)
-void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-
-API for mapping and unmapping for pages.  All the notes and warnings
-for the other mapping APIs apply here.  Also, although the <offset>
-and <size> parameters are provided to do partial page mapping, it is
-recommended that you never use these unless you really know what the
-cache width is.
-
-int
-dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-
-In some circumstances dma_map_single and dma_map_page will fail to create
-a mapping. A driver can check for these errors by testing the returned
-dma address with dma_mapping_error(). A non-zero return value means the mapping
-could not be created and the driver should take appropriate action (e.g.
-reduce current DMA mapping usage or delay and try again later).
-
-	int
-	dma_map_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction direction)
-
-Returns: the number of physical segments mapped (this may be shorter
-than <nents> passed in if some elements of the scatter/gather list are
-physically or virtually adjacent and an IOMMU maps them with a single
-entry).
-
-Please note that the sg cannot be mapped again if it has been mapped once.
-The mapping process is allowed to destroy information in the sg.
-
-As with the other mapping interfaces, dma_map_sg can fail. When it
-does, 0 is returned and a driver must take appropriate action. It is
-critical that the driver do something, in the case of a block driver
-aborting the request or even oopsing is better than doing nothing and
-corrupting the filesystem.
-
-With scatterlists, you use the resulting mapping like this:
-
-	int i, count = dma_map_sg(dev, sglist, nents, direction);
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, count, i) {
-		hw_address[i] = sg_dma_address(sg);
-		hw_len[i] = sg_dma_len(sg);
-	}
-
-where nents is the number of entries in the sglist.
-
-The implementation is free to merge several consecutive sglist entries
-into one (e.g. with an IOMMU, or if several pages just happen to be
-physically contiguous) and returns the actual number of sg entries it
-mapped them to. On failure 0, is returned.
-
-Then you should loop count times (note: this can be less than nents times)
-and use sg_dma_address() and sg_dma_len() macros where you previously
-accessed sg->address and sg->length as shown above.
-
-	void
-	dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-		int nhwentries, enum dma_data_direction direction)
-
-Unmap the previously mapped scatter/gather list.  All the parameters
-must be the same as those and passed in to the scatter/gather mapping
-API.
-
-Note: <nents> must be the number you passed in, *not* the number of
-physical entries returned.
-
-void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
-void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
-			   enum dma_data_direction direction)
-void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
-void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		       enum dma_data_direction direction)
-
-Synchronise a single contiguous or scatter/gather mapping for the cpu
-and device. With the sync_sg API, all the parameters must be the same
-as those passed into the single mapping API. With the sync_single API,
-you can use dma_handle and size parameters that aren't identical to
-those passed into the single mapping API to do a partial sync.
-
-Notes:  You must do this:
-
-- Before reading values that have been written by DMA from the device
-  (use the DMA_FROM_DEVICE direction)
-- After writing values that will be written to the device using DMA
-  (use the DMA_TO_DEVICE) direction
-- before *and* after handing memory to the device if the memory is
-  DMA_BIDIRECTIONAL
-
-See also dma_map_single().
-
-dma_addr_t
-dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
-		     enum dma_data_direction dir,
-		     struct dma_attrs *attrs)
-
-void
-dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
-		       size_t size, enum dma_data_direction dir,
-		       struct dma_attrs *attrs)
-
-int
-dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
-		 int nents, enum dma_data_direction dir,
-		 struct dma_attrs *attrs)
-
-void
-dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
-		   int nents, enum dma_data_direction dir,
-		   struct dma_attrs *attrs)
-
-The four functions above are just like the counterpart functions
-without the _attrs suffixes, except that they pass an optional
-struct dma_attrs*.
-
-struct dma_attrs encapsulates a set of "dma attributes". For the
-definition of struct dma_attrs see linux/dma-attrs.h.
-
-The interpretation of dma attributes is architecture-specific, and
-each attribute should be documented in Documentation/DMA-attributes.txt.
-
-If struct dma_attrs* is NULL, the semantics of each of these
-functions is identical to those of the corresponding function
-without the _attrs suffix. As a result dma_map_single_attrs()
-can generally replace dma_map_single(), etc.
-
-As an example of the use of the *_attrs functions, here's how
-you could pass an attribute DMA_ATTR_FOO when mapping memory
-for DMA:
-
-#include <linux/dma-attrs.h>
-/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h and
- * documented in Documentation/DMA-attributes.txt */
-...
-
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_FOO, &attrs);
-	....
-	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
-	....
-
-Architectures that care about DMA_ATTR_FOO would check for its
-presence in their implementations of the mapping and unmapping
-routines, e.g.:
-
-void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
-			     size_t size, enum dma_data_direction dir,
-			     struct dma_attrs *attrs)
-{
-	....
-	int foo =  dma_get_attr(DMA_ATTR_FOO, attrs);
-	....
-	if (foo)
-		/* twizzle the frobnozzle */
-	....
-
-
-Part II - Advanced dma_ usage
------------------------------
-
-Warning: These pieces of the DMA API should not be used in the
-majority of cases, since they cater for unlikely corner cases that
-don't belong in usual drivers.
-
-If you don't understand how cache line coherency works between a
-processor and an I/O device, you should not be using this part of the
-API at all.
-
-void *
-dma_alloc_noncoherent(struct device *dev, size_t size,
-			       dma_addr_t *dma_handle, gfp_t flag)
-
-Identical to dma_alloc_coherent() except that the platform will
-choose to return either consistent or non-consistent memory as it sees
-fit.  By using this API, you are guaranteeing to the platform that you
-have all the correct and necessary sync points for this memory in the
-driver should it choose to return non-consistent memory.
-
-Note: where the platform can return consistent memory, it will
-guarantee that the sync points become nops.
-
-Warning:  Handling non-consistent memory is a real pain.  You should
-only ever use this API if you positively know your driver will be
-required to work on one of the rare (usually non-PCI) architectures
-that simply cannot make consistent memory.
-
-void
-dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
-			      dma_addr_t dma_handle)
-
-Free memory allocated by the nonconsistent API.  All parameters must
-be identical to those passed in (and returned by
-dma_alloc_noncoherent()).
-
-int
-dma_get_cache_alignment(void)
-
-Returns the processor cache alignment.  This is the absolute minimum
-alignment *and* width that you must observe when either mapping
-memory or doing partial flushes.
-
-Notes: This API may return a number *larger* than the actual cache
-line, but it will guarantee that one or more cache lines fit exactly
-into the width returned by this call.  It will also always be a power
-of two for easy alignment.
-
-void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
-
-Do a partial sync of memory that was allocated by
-dma_alloc_noncoherent(), starting at virtual address vaddr and
-continuing on for size.  Again, you *must* observe the cache line
-boundaries when doing this.
-
-int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int
-			    flags)
-
-Declare region of memory to be handed out by dma_alloc_coherent when
-it's asked for coherent memory for this device.
-
-bus_addr is the physical address to which the memory is currently
-assigned in the bus responding region (this will be used by the
-platform to perform the mapping).
-
-device_addr is the physical address the device needs to be programmed
-with actually to address this memory (this will be handed out as the
-dma_addr_t in dma_alloc_coherent()).
-
-size is the size of the area (must be multiples of PAGE_SIZE).
-
-flags can be or'd together and are:
-
-DMA_MEMORY_MAP - request that the memory returned from
-dma_alloc_coherent() be directly writable.
-
-DMA_MEMORY_IO - request that the memory returned from
-dma_alloc_coherent() be addressable using read/write/memcpy_toio etc.
-
-One or both of these flags must be present.
-
-DMA_MEMORY_INCLUDES_CHILDREN - make the declared memory be allocated by
-dma_alloc_coherent of any child devices of this one (for memory residing
-on a bridge).
-
-DMA_MEMORY_EXCLUSIVE - only allocate memory from the declared regions. 
-Do not allow dma_alloc_coherent() to fall back to system memory when
-it's out of memory in the declared region.
-
-The return value will be either DMA_MEMORY_MAP or DMA_MEMORY_IO and
-must correspond to a passed in flag (i.e. no returning DMA_MEMORY_IO
-if only DMA_MEMORY_MAP were passed in) for success or zero for
-failure.
-
-Note, for DMA_MEMORY_IO returns, all subsequent memory returned by
-dma_alloc_coherent() may no longer be accessed directly, but instead
-must be accessed using the correct bus functions.  If your driver
-isn't prepared to handle this contingency, it should not specify
-DMA_MEMORY_IO in the input flags.
-
-As a simplification for the platforms, only *one* such region of
-memory may be declared per device.
-
-For reasons of efficiency, most platforms choose to track the declared
-region only at the granularity of a page.  For smaller allocations,
-you should use the dma_pool() API.
-
-void
-dma_release_declared_memory(struct device *dev)
-
-Remove the memory region previously declared from the system.  This
-API performs *no* in-use checking for this region and will return
-unconditionally having removed all the required structures.  It is the
-driver's job to ensure that no parts of this memory region are
-currently in use.
-
-void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size)
-
-This is used to occupy specific regions of the declared space
-(dma_alloc_coherent() will hand out the first free region it finds).
-
-device_addr is the *device* address of the region requested.
-
-size is the size (and should be a page-sized multiple).
-
-The return value will be either a pointer to the processor virtual
-address of the memory, or an error (via PTR_ERR()) if any part of the
-region is occupied.
-
-Part III - Debug drivers use of the DMA-API
--------------------------------------------
-
-The DMA-API as described above as some constraints. DMA addresses must be
-released with the corresponding function with the same size for example. With
-the advent of hardware IOMMUs it becomes more and more important that drivers
-do not violate those constraints. In the worst case such a violation can
-result in data corruption up to destroyed filesystems.
-
-To debug drivers and find bugs in the usage of the DMA-API checking code can
-be compiled into the kernel which will tell the developer about those
-violations. If your architecture supports it you can select the "Enable
-debugging of DMA-API usage" option in your kernel configuration. Enabling this
-option has a performance impact. Do not enable it in production kernels.
-
-If you boot the resulting kernel will contain code which does some bookkeeping
-about what DMA memory was allocated for which device. If this code detects an
-error it prints a warning message with some details into your kernel log. An
-example warning message may look like this:
-
-------------[ cut here ]------------
-WARNING: at /data2/repos/linux-2.6-iommu/lib/dma-debug.c:448
-	check_unmap+0x203/0x490()
-Hardware name:
-forcedeth 0000:00:08.0: DMA-API: device driver frees DMA memory with wrong
-	function [device address=0x00000000640444be] [size=66 bytes] [mapped as
-single] [unmapped as page]
-Modules linked in: nfsd exportfs bridge stp llc r8169
-Pid: 0, comm: swapper Tainted: G        W  2.6.28-dmatest-09289-g8bb99c0 #1
-Call Trace:
- <IRQ>  [<ffffffff80240b22>] warn_slowpath+0xf2/0x130
- [<ffffffff80647b70>] _spin_unlock+0x10/0x30
- [<ffffffff80537e75>] usb_hcd_link_urb_to_ep+0x75/0xc0
- [<ffffffff80647c22>] _spin_unlock_irqrestore+0x12/0x40
- [<ffffffff8055347f>] ohci_urb_enqueue+0x19f/0x7c0
- [<ffffffff80252f96>] queue_work+0x56/0x60
- [<ffffffff80237e10>] enqueue_task_fair+0x20/0x50
- [<ffffffff80539279>] usb_hcd_submit_urb+0x379/0xbc0
- [<ffffffff803b78c3>] cpumask_next_and+0x23/0x40
- [<ffffffff80235177>] find_busiest_group+0x207/0x8a0
- [<ffffffff8064784f>] _spin_lock_irqsave+0x1f/0x50
- [<ffffffff803c7ea3>] check_unmap+0x203/0x490
- [<ffffffff803c8259>] debug_dma_unmap_page+0x49/0x50
- [<ffffffff80485f26>] nv_tx_done_optimized+0xc6/0x2c0
- [<ffffffff80486c13>] nv_nic_irq_optimized+0x73/0x2b0
- [<ffffffff8026df84>] handle_IRQ_event+0x34/0x70
- [<ffffffff8026ffe9>] handle_edge_irq+0xc9/0x150
- [<ffffffff8020e3ab>] do_IRQ+0xcb/0x1c0
- [<ffffffff8020c093>] ret_from_intr+0x0/0xa
- <EOI> <4>---[ end trace f6435a98e2a38c0e ]---
-
-The driver developer can find the driver and the device including a stacktrace
-of the DMA-API call which caused this warning.
-
-Per default only the first error will result in a warning message. All other
-errors will only silently counted. This limitation exist to prevent the code
-from flooding your kernel log. To support debugging a device driver this can
-be disabled via debugfs. See the debugfs interface documentation below for
-details.
-
-The debugfs directory for the DMA-API debugging code is called dma-api/. In
-this directory the following files can currently be found:
-
-	dma-api/all_errors	This file contains a numeric value. If this
-				value is not equal to zero the debugging code
-				will print a warning for every error it finds
-				into the kernel log. Be careful with this
-				option, as it can easily flood your logs.
-
-	dma-api/disabled	This read-only file contains the character 'Y'
-				if the debugging code is disabled. This can
-				happen when it runs out of memory or if it was
-				disabled at boot time
-
-	dma-api/error_count	This file is read-only and shows the total
-				numbers of errors found.
-
-	dma-api/num_errors	The number in this file shows how many
-				warnings will be printed to the kernel log
-				before it stops. This number is initialized to
-				one at system boot and be set by writing into
-				this file
-
-	dma-api/min_free_entries
-				This read-only file can be read to get the
-				minimum number of free dma_debug_entries the
-				allocator has ever seen. If this value goes
-				down to zero the code will disable itself
-				because it is not longer reliable.
-
-	dma-api/num_free_entries
-				The current number of free dma_debug_entries
-				in the allocator.
-
-	dma-api/driver-filter
-				You can write a name of a driver into this file
-				to limit the debug output to requests from that
-				particular driver. Write an empty string to
-				that file to disable the filter and see
-				all errors again.
-
-If you have this code compiled into your kernel it will be enabled by default.
-If you want to boot without the bookkeeping anyway you can provide
-'dma_debug=off' as a boot parameter. This will disable DMA-API debugging.
-Notice that you can not enable it again at runtime. You have to reboot to do
-so.
-
-If you want to see debug messages only for a special device driver you can
-specify the dma_debug_driver=<drivername> parameter. This will enable the
-driver filter at boot time. The debug code will only print errors for that
-driver afterwards. This filter can be disabled or changed later using debugfs.
-
-When the code disables itself at runtime this is most likely because it ran
-out of dma_debug_entries. These entries are preallocated at boot. The number
-of preallocated entries is defined per architecture. If it is too low for you
-boot with 'dma_debug_entries=<your_desired_number>' to overwrite the
-architectural default.
-
-void debug_dmap_mapping_error(struct device *dev, dma_addr_t dma_addr);
-
-dma-debug interface debug_dma_mapping_error() to debug drivers that fail
-to check dma mapping errors on addresses returned by dma_map_single() and
-dma_map_page() interfaces. This interface clears a flag set by
-debug_dma_map_page() to indicate that dma_mapping_error() has been called by
-the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
-this flag is still set, prints warning message that includes call trace that
-leads up to the unmap. This interface can be called from dma_mapping_error()
-routines to enable dma mapping error check debugging.
-
diff --git a/Documentation/DMA-ISA-LPC.txt b/Documentation/DMA-ISA-LPC.txt
deleted file mode 100644
index e767805..0000000
--- a/Documentation/DMA-ISA-LPC.txt
+++ /dev/null
@@ -1,151 +0,0 @@
-                        DMA with ISA and LPC devices
-                        ============================
-
-                      Pierre Ossman <drzeus@drzeus.cx>
-
-This document describes how to do DMA transfers using the old ISA DMA
-controller. Even though ISA is more or less dead today the LPC bus
-uses the same DMA system so it will be around for quite some time.
-
-Part I - Headers and dependencies
----------------------------------
-
-To do ISA style DMA you need to include two headers:
-
-#include <linux/dma-mapping.h>
-#include <asm/dma.h>
-
-The first is the generic DMA API used to convert virtual addresses to
-physical addresses (see Documentation/DMA-API.txt for details).
-
-The second contains the routines specific to ISA DMA transfers. Since
-this is not present on all platforms make sure you construct your
-Kconfig to be dependent on ISA_DMA_API (not ISA) so that nobody tries
-to build your driver on unsupported platforms.
-
-Part II - Buffer allocation
----------------------------
-
-The ISA DMA controller has some very strict requirements on which
-memory it can access so extra care must be taken when allocating
-buffers.
-
-(You usually need a special buffer for DMA transfers instead of
-transferring directly to and from your normal data structures.)
-
-The DMA-able address space is the lowest 16 MB of _physical_ memory.
-Also the transfer block may not cross page boundaries (which are 64
-or 128 KiB depending on which channel you use).
-
-In order to allocate a piece of memory that satisfies all these
-requirements you pass the flag GFP_DMA to kmalloc.
-
-Unfortunately the memory available for ISA DMA is scarce so unless you
-allocate the memory during boot-up it's a good idea to also pass
-__GFP_REPEAT and __GFP_NOWARN to make the allocater try a bit harder.
-
-(This scarcity also means that you should allocate the buffer as
-early as possible and not release it until the driver is unloaded.)
-
-Part III - Address translation
-------------------------------
-
-To translate the virtual address to a physical use the normal DMA
-API. Do _not_ use isa_virt_to_phys() even though it does the same
-thing. The reason for this is that the function isa_virt_to_phys()
-will require a Kconfig dependency to ISA, not just ISA_DMA_API which
-is really all you need. Remember that even though the DMA controller
-has its origins in ISA it is used elsewhere.
-
-Note: x86_64 had a broken DMA API when it came to ISA but has since
-been fixed. If your arch has problems then fix the DMA API instead of
-reverting to the ISA functions.
-
-Part IV - Channels
-------------------
-
-A normal ISA DMA controller has 8 channels. The lower four are for
-8-bit transfers and the upper four are for 16-bit transfers.
-
-(Actually the DMA controller is really two separate controllers where
-channel 4 is used to give DMA access for the second controller (0-3).
-This means that of the four 16-bits channels only three are usable.)
-
-You allocate these in a similar fashion as all basic resources:
-
-extern int request_dma(unsigned int dmanr, const char * device_id);
-extern void free_dma(unsigned int dmanr);
-
-The ability to use 16-bit or 8-bit transfers is _not_ up to you as a
-driver author but depends on what the hardware supports. Check your
-specs or test different channels.
-
-Part V - Transfer data
-----------------------
-
-Now for the good stuff, the actual DMA transfer. :)
-
-Before you use any ISA DMA routines you need to claim the DMA lock
-using claim_dma_lock(). The reason is that some DMA operations are
-not atomic so only one driver may fiddle with the registers at a
-time.
-
-The first time you use the DMA controller you should call
-clear_dma_ff(). This clears an internal register in the DMA
-controller that is used for the non-atomic operations. As long as you
-(and everyone else) uses the locking functions then you only need to
-reset this once.
-
-Next, you tell the controller in which direction you intend to do the
-transfer using set_dma_mode(). Currently you have the options
-DMA_MODE_READ and DMA_MODE_WRITE.
-
-Set the address from where the transfer should start (this needs to
-be 16-bit aligned for 16-bit transfers) and how many bytes to
-transfer. Note that it's _bytes_. The DMA routines will do all the
-required translation to values that the DMA controller understands.
-
-The final step is enabling the DMA channel and releasing the DMA
-lock.
-
-Once the DMA transfer is finished (or timed out) you should disable
-the channel again. You should also check get_dma_residue() to make
-sure that all data has been transferred.
-
-Example:
-
-int flags, residue;
-
-flags = claim_dma_lock();
-
-clear_dma_ff();
-
-set_dma_mode(channel, DMA_MODE_WRITE);
-set_dma_addr(channel, phys_addr);
-set_dma_count(channel, num_bytes);
-
-dma_enable(channel);
-
-release_dma_lock(flags);
-
-while (!device_done());
-
-flags = claim_dma_lock();
-
-dma_disable(channel);
-
-residue = dma_get_residue(channel);
-if (residue != 0)
-	printk(KERN_ERR "driver: Incomplete DMA transfer!"
-		" %d bytes left!\n", residue);
-
-release_dma_lock(flags);
-
-Part VI - Suspend/resume
-------------------------
-
-It is the driver's responsibility to make sure that the machine isn't
-suspended while a DMA transfer is in progress. Also, all DMA settings
-are lost when the system suspends so if your driver relies on the DMA
-controller being in a certain state then you have to restore these
-registers upon resume.
diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
deleted file mode 100644
index cc2450d..0000000
--- a/Documentation/DMA-attributes.txt
+++ /dev/null
@@ -1,102 +0,0 @@
-			DMA attributes
-			==============
-
-This document describes the semantics of the DMA attributes that are
-defined in linux/dma-attrs.h.
-
-DMA_ATTR_WRITE_BARRIER
-----------------------
-
-DMA_ATTR_WRITE_BARRIER is a (write) barrier attribute for DMA.  DMA
-to a memory region with the DMA_ATTR_WRITE_BARRIER attribute forces
-all pending DMA writes to complete, and thus provides a mechanism to
-strictly order DMA from a device across all intervening busses and
-bridges.  This barrier is not specific to a particular type of
-interconnect, it applies to the system as a whole, and so its
-implementation must account for the idiosyncrasies of the system all
-the way from the DMA device to memory.
-
-As an example of a situation where DMA_ATTR_WRITE_BARRIER would be
-useful, suppose that a device does a DMA write to indicate that data is
-ready and available in memory.  The DMA of the "completion indication"
-could race with data DMA.  Mapping the memory used for completion
-indications with DMA_ATTR_WRITE_BARRIER would prevent the race.
-
-DMA_ATTR_WEAK_ORDERING
-----------------------
-
-DMA_ATTR_WEAK_ORDERING specifies that reads and writes to the mapping
-may be weakly ordered, that is that reads and writes may pass each other.
-
-Since it is optional for platforms to implement DMA_ATTR_WEAK_ORDERING,
-those that do not will simply ignore the attribute and exhibit default
-behavior.
-
-DMA_ATTR_WRITE_COMBINE
-----------------------
-
-DMA_ATTR_WRITE_COMBINE specifies that writes to the mapping may be
-buffered to improve performance.
-
-Since it is optional for platforms to implement DMA_ATTR_WRITE_COMBINE,
-those that do not will simply ignore the attribute and exhibit default
-behavior.
-
-DMA_ATTR_NON_CONSISTENT
------------------------
-
-DMA_ATTR_NON_CONSISTENT lets the platform to choose to return either
-consistent or non-consistent memory as it sees fit.  By using this API,
-you are guaranteeing to the platform that you have all the correct and
-necessary sync points for this memory in the driver.
-
-DMA_ATTR_NO_KERNEL_MAPPING
---------------------------
-
-DMA_ATTR_NO_KERNEL_MAPPING lets the platform to avoid creating a kernel
-virtual mapping for the allocated buffer. On some architectures creating
-such mapping is non-trivial task and consumes very limited resources
-(like kernel virtual address space or dma consistent address space).
-Buffers allocated with this attribute can be only passed to user space
-by calling dma_mmap_attrs(). By using this API, you are guaranteeing
-that you won't dereference the pointer returned by dma_alloc_attr(). You
-can treat it as a cookie that must be passed to dma_mmap_attrs() and
-dma_free_attrs(). Make sure that both of these also get this attribute
-set on each call.
-
-Since it is optional for platforms to implement
-DMA_ATTR_NO_KERNEL_MAPPING, those that do not will simply ignore the
-attribute and exhibit default behavior.
-
-DMA_ATTR_SKIP_CPU_SYNC
-----------------------
-
-By default dma_map_{single,page,sg} functions family transfer a given
-buffer from CPU domain to device domain. Some advanced use cases might
-require sharing a buffer between more than one device. This requires
-having a mapping created separately for each device and is usually
-performed by calling dma_map_{single,page,sg} function more than once
-for the given buffer with device pointer to each device taking part in
-the buffer sharing. The first call transfers a buffer from 'CPU' domain
-to 'device' domain, what synchronizes CPU caches for the given region
-(usually it means that the cache has been flushed or invalidated
-depending on the dma direction). However, next calls to
-dma_map_{single,page,sg}() for other devices will perform exactly the
-same synchronization operation on the CPU cache. CPU cache synchronization
-might be a time consuming operation, especially if the buffers are
-large, so it is highly recommended to avoid it if possible.
-DMA_ATTR_SKIP_CPU_SYNC allows platform code to skip synchronization of
-the CPU cache for the given buffer assuming that it has been already
-transferred to 'device' domain. This attribute can be also used for
-dma_unmap_{single,page,sg} functions family to force buffer to stay in
-device domain after releasing a mapping for it. Use this attribute with
-care!
-
-DMA_ATTR_FORCE_CONTIGUOUS
--------------------------
-
-By default DMA-mapping subsystem is allowed to assemble the buffer
-allocated by dma_alloc_attrs() function from individual pages if it can
-be mapped as contiguous chunk into device dma address space. By
-specifing this attribute the allocated buffer is forced to be contiguous
-also in physical memory.
diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
deleted file mode 100644
index 505e711..0000000
--- a/Documentation/dma-buf-sharing.txt
+++ /dev/null
@@ -1,462 +0,0 @@
-                    DMA Buffer Sharing API Guide
-                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-                            Sumit Semwal
-                <sumit dot semwal at linaro dot org>
-                 <sumit dot semwal at ti dot com>
-
-This document serves as a guide to device-driver writers on what is the dma-buf
-buffer sharing API, how to use it for exporting and using shared buffers.
-
-Any device driver which wishes to be a part of DMA buffer sharing, can do so as
-either the 'exporter' of buffers, or the 'user' of buffers.
-
-Say a driver A wants to use buffers created by driver B, then we call B as the
-exporter, and A as buffer-user.
-
-The exporter
-- implements and manages operations[1] for the buffer
-- allows other users to share the buffer by using dma_buf sharing APIs,
-- manages the details of buffer allocation,
-- decides about the actual backing storage where this allocation happens,
-- takes care of any migration of scatterlist - for all (shared) users of this
-   buffer,
-
-The buffer-user
-- is one of (many) sharing users of the buffer.
-- doesn't need to worry about how the buffer is allocated, or where.
-- needs a mechanism to get access to the scatterlist that makes up this buffer
-   in memory, mapped into its own address space, so it can access the same area
-   of memory.
-
-dma-buf operations for device dma only
---------------------------------------
-
-The dma_buf buffer sharing API usage contains the following steps:
-
-1. Exporter announces that it wishes to export a buffer
-2. Userspace gets the file descriptor associated with the exported buffer, and
-   passes it around to potential buffer-users based on use case
-3. Each buffer-user 'connects' itself to the buffer
-4. When needed, buffer-user requests access to the buffer from exporter
-5. When finished with its use, the buffer-user notifies end-of-DMA to exporter
-6. when buffer-user is done using this buffer completely, it 'disconnects'
-   itself from the buffer.
-
-
-1. Exporter's announcement of buffer export
-
-   The buffer exporter announces its wish to export a buffer. In this, it
-   connects its own private buffer data, provides implementation for operations
-   that can be performed on the exported dma_buf, and flags for the file
-   associated with this buffer.
-
-   Interface:
-      struct dma_buf *dma_buf_export_named(void *priv, struct dma_buf_ops *ops,
-				     size_t size, int flags,
-				     const char *exp_name)
-
-   If this succeeds, dma_buf_export allocates a dma_buf structure, and returns a
-   pointer to the same. It also associates an anonymous file with this buffer,
-   so it can be exported. On failure to allocate the dma_buf object, it returns
-   NULL.
-
-   'exp_name' is the name of exporter - to facilitate information while
-   debugging.
-
-   Exporting modules which do not wish to provide any specific name may use the
-   helper define 'dma_buf_export()', with the same arguments as above, but
-   without the last argument; a __FILE__ pre-processor directive will be
-   inserted in place of 'exp_name' instead.
-
-2. Userspace gets a handle to pass around to potential buffer-users
-
-   Userspace entity requests for a file-descriptor (fd) which is a handle to the
-   anonymous file associated with the buffer. It can then share the fd with other
-   drivers and/or processes.
-
-   Interface:
-      int dma_buf_fd(struct dma_buf *dmabuf)
-
-   This API installs an fd for the anonymous file associated with this buffer;
-   returns either 'fd', or error.
-
-3. Each buffer-user 'connects' itself to the buffer
-
-   Each buffer-user now gets a reference to the buffer, using the fd passed to
-   it.
-
-   Interface:
-      struct dma_buf *dma_buf_get(int fd)
-
-   This API will return a reference to the dma_buf, and increment refcount for
-   it.
-
-   After this, the buffer-user needs to attach its device with the buffer, which
-   helps the exporter to know of device buffer constraints.
-
-   Interface:
-      struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
-                                                struct device *dev)
-
-   This API returns reference to an attachment structure, which is then used
-   for scatterlist operations. It will optionally call the 'attach' dma_buf
-   operation, if provided by the exporter.
-
-   The dma-buf sharing framework does the bookkeeping bits related to managing
-   the list of all attachments to a buffer.
-
-Until this stage, the buffer-exporter has the option to choose not to actually
-allocate the backing storage for this buffer, but wait for the first buffer-user
-to request use of buffer for allocation.
-
-
-4. When needed, buffer-user requests access to the buffer
-
-   Whenever a buffer-user wants to use the buffer for any DMA, it asks for
-   access to the buffer using dma_buf_map_attachment API. At least one attach to
-   the buffer must have happened before map_dma_buf can be called.
-
-   Interface:
-      struct sg_table * dma_buf_map_attachment(struct dma_buf_attachment *,
-                                         enum dma_data_direction);
-
-   This is a wrapper to dma_buf->ops->map_dma_buf operation, which hides the
-   "dma_buf->ops->" indirection from the users of this interface.
-
-   In struct dma_buf_ops, map_dma_buf is defined as
-      struct sg_table * (*map_dma_buf)(struct dma_buf_attachment *,
-                                                enum dma_data_direction);
-
-   It is one of the buffer operations that must be implemented by the exporter.
-   It should return the sg_table containing scatterlist for this buffer, mapped
-   into caller's address space.
-
-   If this is being called for the first time, the exporter can now choose to
-   scan through the list of attachments for this buffer, collate the requirements
-   of the attached devices, and choose an appropriate backing storage for the
-   buffer.
-
-   Based on enum dma_data_direction, it might be possible to have multiple users
-   accessing at the same time (for reading, maybe), or any other kind of sharing
-   that the exporter might wish to make available to buffer-users.
-
-   map_dma_buf() operation can return -EINTR if it is interrupted by a signal.
-
-
-5. When finished, the buffer-user notifies end-of-DMA to exporter
-
-   Once the DMA for the current buffer-user is over, it signals 'end-of-DMA' to
-   the exporter using the dma_buf_unmap_attachment API.
-
-   Interface:
-      void dma_buf_unmap_attachment(struct dma_buf_attachment *,
-                                    struct sg_table *);
-
-   This is a wrapper to dma_buf->ops->unmap_dma_buf() operation, which hides the
-   "dma_buf->ops->" indirection from the users of this interface.
-
-   In struct dma_buf_ops, unmap_dma_buf is defined as
-      void (*unmap_dma_buf)(struct dma_buf_attachment *, struct sg_table *);
-
-   unmap_dma_buf signifies the end-of-DMA for the attachment provided. Like
-   map_dma_buf, this API also must be implemented by the exporter.
-
-
-6. when buffer-user is done using this buffer, it 'disconnects' itself from the
-   buffer.
-
-   After the buffer-user has no more interest in using this buffer, it should
-   disconnect itself from the buffer:
-
-   - it first detaches itself from the buffer.
-
-   Interface:
-      void dma_buf_detach(struct dma_buf *dmabuf,
-                          struct dma_buf_attachment *dmabuf_attach);
-
-   This API removes the attachment from the list in dmabuf, and optionally calls
-   dma_buf->ops->detach(), if provided by exporter, for any housekeeping bits.
-
-   - Then, the buffer-user returns the buffer reference to exporter.
-
-   Interface:
-     void dma_buf_put(struct dma_buf *dmabuf);
-
-   This API then reduces the refcount for this buffer.
-
-   If, as a result of this call, the refcount becomes 0, the 'release' file
-   operation related to this fd is called. It calls the dmabuf->ops->release()
-   operation in turn, and frees the memory allocated for dmabuf when exported.
-
-NOTES:
-- Importance of attach-detach and {map,unmap}_dma_buf operation pairs
-   The attach-detach calls allow the exporter to figure out backing-storage
-   constraints for the currently-interested devices. This allows preferential
-   allocation, and/or migration of pages across different types of storage
-   available, if possible.
-
-   Bracketing of DMA access with {map,unmap}_dma_buf operations is essential
-   to allow just-in-time backing of storage, and migration mid-way through a
-   use-case.
-
-- Migration of backing storage if needed
-   If after
-   - at least one map_dma_buf has happened,
-   - and the backing storage has been allocated for this buffer,
-   another new buffer-user intends to attach itself to this buffer, it might
-   be allowed, if possible for the exporter.
-
-   In case it is allowed by the exporter:
-    if the new buffer-user has stricter 'backing-storage constraints', and the
-    exporter can handle these constraints, the exporter can just stall on the
-    map_dma_buf until all outstanding access is completed (as signalled by
-    unmap_dma_buf).
-    Once all users have finished accessing and have unmapped this buffer, the
-    exporter could potentially move the buffer to the stricter backing-storage,
-    and then allow further {map,unmap}_dma_buf operations from any buffer-user
-    from the migrated backing-storage.
-
-   If the exporter cannot fulfil the backing-storage constraints of the new
-   buffer-user device as requested, dma_buf_attach() would return an error to
-   denote non-compatibility of the new buffer-sharing request with the current
-   buffer.
-
-   If the exporter chooses not to allow an attach() operation once a
-   map_dma_buf() API has been called, it simply returns an error.
-
-Kernel cpu access to a dma-buf buffer object
---------------------------------------------
-
-The motivation to allow cpu access from the kernel to a dma-buf object from the
-importers side are:
-- fallback operations, e.g. if the devices is connected to a usb bus and the
-  kernel needs to shuffle the data around first before sending it away.
-- full transparency for existing users on the importer side, i.e. userspace
-  should not notice the difference between a normal object from that subsystem
-  and an imported one backed by a dma-buf. This is really important for drm
-  opengl drivers that expect to still use all the existing upload/download
-  paths.
-
-Access to a dma_buf from the kernel context involves three steps:
-
-1. Prepare access, which invalidate any necessary caches and make the object
-   available for cpu access.
-2. Access the object page-by-page with the dma_buf map apis
-3. Finish access, which will flush any necessary cpu caches and free reserved
-   resources.
-
-1. Prepare access
-
-   Before an importer can access a dma_buf object with the cpu from the kernel
-   context, it needs to notify the exporter of the access that is about to
-   happen.
-
-   Interface:
-      int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
-				   size_t start, size_t len,
-				   enum dma_data_direction direction)
-
-   This allows the exporter to ensure that the memory is actually available for
-   cpu access - the exporter might need to allocate or swap-in and pin the
-   backing storage. The exporter also needs to ensure that cpu access is
-   coherent for the given range and access direction. The range and access
-   direction can be used by the exporter to optimize the cache flushing, i.e.
-   access outside of the range or with a different direction (read instead of
-   write) might return stale or even bogus data (e.g. when the exporter needs to
-   copy the data to temporary storage).
-
-   This step might fail, e.g. in oom conditions.
-
-2. Accessing the buffer
-
-   To support dma_buf objects residing in highmem cpu access is page-based using
-   an api similar to kmap. Accessing a dma_buf is done in aligned chunks of
-   PAGE_SIZE size. Before accessing a chunk it needs to be mapped, which returns
-   a pointer in kernel virtual address space. Afterwards the chunk needs to be
-   unmapped again. There is no limit on how often a given chunk can be mapped
-   and unmapped, i.e. the importer does not need to call begin_cpu_access again
-   before mapping the same chunk again.
-
-   Interfaces:
-      void *dma_buf_kmap(struct dma_buf *, unsigned long);
-      void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
-
-   There are also atomic variants of these interfaces. Like for kmap they
-   facilitate non-blocking fast-paths. Neither the importer nor the exporter (in
-   the callback) is allowed to block when using these.
-
-   Interfaces:
-      void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
-      void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
-
-   For importers all the restrictions of using kmap apply, like the limited
-   supply of kmap_atomic slots. Hence an importer shall only hold onto at most 2
-   atomic dma_buf kmaps at the same time (in any given process context).
-
-   dma_buf kmap calls outside of the range specified in begin_cpu_access are
-   undefined. If the range is not PAGE_SIZE aligned, kmap needs to succeed on
-   the partial chunks at the beginning and end but may return stale or bogus
-   data outside of the range (in these partial chunks).
-
-   Note that these calls need to always succeed. The exporter needs to complete
-   any preparations that might fail in begin_cpu_access.
-
-   For some cases the overhead of kmap can be too high, a vmap interface
-   is introduced. This interface should be used very carefully, as vmalloc
-   space is a limited resources on many architectures.
-
-   Interfaces:
-      void *dma_buf_vmap(struct dma_buf *dmabuf)
-      void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
-
-   The vmap call can fail if there is no vmap support in the exporter, or if it
-   runs out of vmalloc space. Fallback to kmap should be implemented. Note that
-   the dma-buf layer keeps a reference count for all vmap access and calls down
-   into the exporter's vmap function only when no vmapping exists, and only
-   unmaps it once. Protection against concurrent vmap/vunmap calls is provided
-   by taking the dma_buf->lock mutex.
-
-3. Finish access
-
-   When the importer is done accessing the range specified in begin_cpu_access,
-   it needs to announce this to the exporter (to facilitate cache flushing and
-   unpinning of any pinned resources). The result of any dma_buf kmap calls
-   after end_cpu_access is undefined.
-
-   Interface:
-      void dma_buf_end_cpu_access(struct dma_buf *dma_buf,
-				  size_t start, size_t len,
-				  enum dma_data_direction dir);
-
-
-Direct Userspace Access/mmap Support
-------------------------------------
-
-Being able to mmap an export dma-buf buffer object has 2 main use-cases:
-- CPU fallback processing in a pipeline and
-- supporting existing mmap interfaces in importers.
-
-1. CPU fallback processing in a pipeline
-
-   In many processing pipelines it is sometimes required that the cpu can access
-   the data in a dma-buf (e.g. for thumbnail creation, snapshots, ...). To avoid
-   the need to handle this specially in userspace frameworks for buffer sharing
-   it's ideal if the dma_buf fd itself can be used to access the backing storage
-   from userspace using mmap.
-
-   Furthermore Android's ION framework already supports this (and is otherwise
-   rather similar to dma-buf from a userspace consumer side with using fds as
-   handles, too). So it's beneficial to support this in a similar fashion on
-   dma-buf to have a good transition path for existing Android userspace.
-
-   No special interfaces, userspace simply calls mmap on the dma-buf fd.
-
-2. Supporting existing mmap interfaces in exporters
-
-   Similar to the motivation for kernel cpu access it is again important that
-   the userspace code of a given importing subsystem can use the same interfaces
-   with a imported dma-buf buffer object as with a native buffer object. This is
-   especially important for drm where the userspace part of contemporary OpenGL,
-   X, and other drivers is huge, and reworking them to use a different way to
-   mmap a buffer rather invasive.
-
-   The assumption in the current dma-buf interfaces is that redirecting the
-   initial mmap is all that's needed. A survey of some of the existing
-   subsystems shows that no driver seems to do any nefarious thing like syncing
-   up with outstanding asynchronous processing on the device or allocating
-   special resources at fault time. So hopefully this is good enough, since
-   adding interfaces to intercept pagefaults and allow pte shootdowns would
-   increase the complexity quite a bit.
-
-   Interface:
-      int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
-		       unsigned long);
-
-   If the importing subsystem simply provides a special-purpose mmap call to set
-   up a mapping in userspace, calling do_mmap with dma_buf->file will equally
-   achieve that for a dma-buf object.
-
-3. Implementation notes for exporters
-
-   Because dma-buf buffers have invariant size over their lifetime, the dma-buf
-   core checks whether a vma is too large and rejects such mappings. The
-   exporter hence does not need to duplicate this check.
-
-   Because existing importing subsystems might presume coherent mappings for
-   userspace, the exporter needs to set up a coherent mapping. If that's not
-   possible, it needs to fake coherency by manually shooting down ptes when
-   leaving the cpu domain and flushing caches at fault time. Note that all the
-   dma_buf files share the same anon inode, hence the exporter needs to replace
-   the dma_buf file stored in vma->vm_file with it's own if pte shootdown is
-   required. This is because the kernel uses the underlying inode's address_space
-   for vma tracking (and hence pte tracking at shootdown time with
-   unmap_mapping_range).
-
-   If the above shootdown dance turns out to be too expensive in certain
-   scenarios, we can extend dma-buf with a more explicit cache tracking scheme
-   for userspace mappings. But the current assumption is that using mmap is
-   always a slower path, so some inefficiencies should be acceptable.
-
-   Exporters that shoot down mappings (for any reasons) shall not do any
-   synchronization at fault time with outstanding device operations.
-   Synchronization is an orthogonal issue to sharing the backing storage of a
-   buffer and hence should not be handled by dma-buf itself. This is explicitly
-   mentioned here because many people seem to want something like this, but if
-   different exporters handle this differently, buffer sharing can fail in
-   interesting ways depending upong the exporter (if userspace starts depending
-   upon this implicit synchronization).
-
-Other Interfaces Exposed to Userspace on the dma-buf FD
-------------------------------------------------------
-
-- Since kernel 3.12 the dma-buf FD supports the llseek system call, but only
-  with offset=0 and whence=SEEK_END|SEEK_SET. SEEK_SET is supported to allow
-  the usual size discover pattern size = SEEK_END(0); SEEK_SET(0). Every other
-  llseek operation will report -EINVAL.
-
-  If llseek on dma-buf FDs isn't support the kernel will report -ESPIPE for all
-  cases. Userspace can use this to detect support for discovering the dma-buf
-  size using llseek.
-
-Miscellaneous notes
--------------------
-
-- Any exporters or users of the dma-buf buffer sharing framework must have
-  a 'select DMA_SHARED_BUFFER' in their respective Kconfigs.
-
-- In order to avoid fd leaks on exec, the FD_CLOEXEC flag must be set
-  on the file descriptor.  This is not just a resource leak, but a
-  potential security hole.  It could give the newly exec'd application
-  access to buffers, via the leaked fd, to which it should otherwise
-  not be permitted access.
-
-  The problem with doing this via a separate fcntl() call, versus doing it
-  atomically when the fd is created, is that this is inherently racy in a
-  multi-threaded app[3].  The issue is made worse when it is library code
-  opening/creating the file descriptor, as the application may not even be
-  aware of the fd's.
-
-  To avoid this problem, userspace must have a way to request O_CLOEXEC
-  flag be set when the dma-buf fd is created.  So any API provided by
-  the exporting driver to create a dmabuf fd must provide a way to let
-  userspace control setting of O_CLOEXEC flag passed in to dma_buf_fd().
-
-- If an exporter needs to manually flush caches and hence needs to fake
-  coherency for mmap support, it needs to be able to zap all the ptes pointing
-  at the backing storage. Now linux mm needs a struct address_space associated
-  with the struct file stored in vma->vm_file to do that with the function
-  unmap_mapping_range. But the dma_buf framework only backs every dma_buf fd
-  with the anon_file struct file, i.e. all dma_bufs share the same file.
-
-  Hence exporters need to setup their own file (and address_space) association
-  by setting vma->vm_file and adjusting vma->vm_pgoff in the dma_buf mmap
-  callback. In the specific case of a gem driver the exporter could use the
-  shmem file already provided by gem (and set vm_pgoff = 0). Exporters can then
-  zap ptes by unmapping the corresponding range of the struct address_space
-  associated with their own file.
-
-References:
-[1] struct dma_buf_ops in include/linux/dma-buf.h
-[2] All interfaces mentioned above defined in include/linux/dma-buf.h
-[3] https://lwn.net/Articles/236486/
diff --git a/Documentation/dma/DMA-API-HOWTO.txt b/Documentation/dma/DMA-API-HOWTO.txt
new file mode 100644
index 0000000..5e98303
--- /dev/null
+++ b/Documentation/dma/DMA-API-HOWTO.txt
@@ -0,0 +1,915 @@
+		     Dynamic DMA mapping Guide
+		     =========================
+
+		 David S. Miller <davem@redhat.com>
+		 Richard Henderson <rth@cygnus.com>
+		  Jakub Jelinek <jakub@redhat.com>
+
+This is a guide to device driver writers on how to use the DMA API
+with example pseudo-code.  For a concise description of the API, see
+DMA-API.txt.
+
+Most of the 64bit platforms have special hardware that translates bus
+addresses (DMA addresses) into physical addresses.  This is similar to
+how page tables and/or a TLB translates virtual addresses to physical
+addresses on a CPU.  This is needed so that e.g. PCI devices can
+access with a Single Address Cycle (32bit DMA address) any page in the
+64bit physical address space.  Previously in Linux those 64bit
+platforms had to set artificial limits on the maximum RAM size in the
+system, so that the virt_to_bus() static scheme works (the DMA address
+translation tables were simply filled on bootup to map each bus
+address to the physical page __pa(bus_to_virt())).
+
+So that Linux can use the dynamic DMA mapping, it needs some help from the
+drivers, namely it has to take into account that DMA addresses should be
+mapped only for the time they are actually used and unmapped after the DMA
+transfer.
+
+The following API will work of course even on platforms where no such
+hardware exists.
+
+Note that the DMA API works with any bus independent of the underlying
+microprocessor architecture. You should use the DMA API rather than
+the bus specific DMA API (e.g. pci_dma_*).
+
+First of all, you should make sure
+
+#include <linux/dma-mapping.h>
+
+is in your driver. This file will obtain for you the definition of the
+dma_addr_t (which can hold any valid DMA address for the platform)
+type which should be used everywhere you hold a DMA (bus) address
+returned from the DMA mapping functions.
+
+			 What memory is DMA'able?
+
+The first piece of information you must know is what kernel memory can
+be used with the DMA mapping facilities.  There has been an unwritten
+set of rules regarding this, and this text is an attempt to finally
+write them down.
+
+If you acquired your memory via the page allocator
+(i.e. __get_free_page*()) or the generic memory allocators
+(i.e. kmalloc() or kmem_cache_alloc()) then you may DMA to/from
+that memory using the addresses returned from those routines.
+
+This means specifically that you may _not_ use the memory/addresses
+returned from vmalloc() for DMA.  It is possible to DMA to the
+_underlying_ memory mapped into a vmalloc() area, but this requires
+walking page tables to get the physical addresses, and then
+translating each of those pages back to a kernel address using
+something like __va().  [ EDIT: Update this when we integrate
+Gerd Knorr's generic code which does this. ]
+
+This rule also means that you may use neither kernel image addresses
+(items in data/text/bss segments), nor module image addresses, nor
+stack addresses for DMA.  These could all be mapped somewhere entirely
+different than the rest of physical memory.  Even if those classes of
+memory could physically work with DMA, you'd need to ensure the I/O
+buffers were cacheline-aligned.  Without that, you'd see cacheline
+sharing problems (data corruption) on CPUs with DMA-incoherent caches.
+(The CPU could write to one word, DMA would write to a different one
+in the same cache line, and one of them could be overwritten.)
+
+Also, this means that you cannot take the return of a kmap()
+call and DMA to/from that.  This is similar to vmalloc().
+
+What about block I/O and networking buffers?  The block I/O and
+networking subsystems make sure that the buffers they use are valid
+for you to DMA from/to.
+
+			DMA addressing limitations
+
+Does your device have any DMA addressing limitations?  For example, is
+your device only capable of driving the low order 24-bits of address?
+If so, you need to inform the kernel of this fact.
+
+By default, the kernel assumes that your device can address the full
+32-bits.  For a 64-bit capable device, this needs to be increased.
+And for a device with limitations, as discussed in the previous
+paragraph, it needs to be decreased.
+
+Special note about PCI: PCI-X specification requires PCI-X devices to
+support 64-bit addressing (DAC) for all transactions.  And at least
+one platform (SGI SN2) requires 64-bit consistent allocations to
+operate correctly when the IO bus is in PCI-X mode.
+
+For correct operation, you must interrogate the kernel in your device
+probe routine to see if the DMA controller on the machine can properly
+support the DMA addressing limitation your device has.  It is good
+style to do this even if your device holds the default setting,
+because this shows that you did think about these issues wrt. your
+device.
+
+The query is performed via a call to dma_set_mask_and_coherent():
+
+	int dma_set_mask_and_coherent(struct device *dev, u64 mask);
+
+which will query the mask for both streaming and coherent APIs together.
+If you have some special requirements, then the following two separate
+queries can be used instead:
+
+	The query for streaming mappings is performed via a call to
+	dma_set_mask():
+
+		int dma_set_mask(struct device *dev, u64 mask);
+
+	The query for consistent allocations is performed via a call
+	to dma_set_coherent_mask():
+
+		int dma_set_coherent_mask(struct device *dev, u64 mask);
+
+Here, dev is a pointer to the device struct of your device, and mask
+is a bit mask describing which bits of an address your device
+supports.  It returns zero if your card can perform DMA properly on
+the machine given the address mask you provided.  In general, the
+device struct of your device is embedded in the bus specific device
+struct of your device.  For example, a pointer to the device struct of
+your PCI device is pdev->dev (pdev is a pointer to the PCI device
+struct of your device).
+
+If it returns non-zero, your device cannot perform DMA properly on
+this platform, and attempting to do so will result in undefined
+behavior.  You must either use a different mask, or not use DMA.
+
+This means that in the failure case, you have three options:
+
+1) Use another DMA mask, if possible (see below).
+2) Use some non-DMA mode for data transfer, if possible.
+3) Ignore this device and do not initialize it.
+
+It is recommended that your driver print a kernel KERN_WARNING message
+when you end up performing either #2 or #3.  In this manner, if a user
+of your driver reports that performance is bad or that the device is not
+even detected, you can ask them for the kernel messages to find out
+exactly why.
+
+The standard 32-bit addressing device would do something like this:
+
+	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
+		printk(KERN_WARNING
+		       "mydev: No suitable DMA available.\n");
+		goto ignore_this_device;
+	}
+
+Another common scenario is a 64-bit capable device.  The approach here
+is to try for 64-bit addressing, but back down to a 32-bit mask that
+should not fail.  The kernel may fail the 64-bit mask not because the
+platform is not capable of 64-bit addressing.  Rather, it may fail in
+this case simply because 32-bit addressing is done more efficiently
+than 64-bit addressing.  For example, Sparc64 PCI SAC addressing is
+more efficient than DAC addressing.
+
+Here is how you would handle a 64-bit capable device which can drive
+all 64-bits when accessing streaming DMA:
+
+	int using_dac;
+
+	if (!dma_set_mask(dev, DMA_BIT_MASK(64))) {
+		using_dac = 1;
+	} else if (!dma_set_mask(dev, DMA_BIT_MASK(32))) {
+		using_dac = 0;
+	} else {
+		printk(KERN_WARNING
+		       "mydev: No suitable DMA available.\n");
+		goto ignore_this_device;
+	}
+
+If a card is capable of using 64-bit consistent allocations as well,
+the case would look like this:
+
+	int using_dac, consistent_using_dac;
+
+	if (!dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64))) {
+		using_dac = 1;
+	   	consistent_using_dac = 1;
+	} else if (!dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
+		using_dac = 0;
+		consistent_using_dac = 0;
+	} else {
+		printk(KERN_WARNING
+		       "mydev: No suitable DMA available.\n");
+		goto ignore_this_device;
+	}
+
+The coherent coherent mask will always be able to set the same or a
+smaller mask as the streaming mask. However for the rare case that a
+device driver only uses consistent allocations, one would have to
+check the return value from dma_set_coherent_mask().
+
+Finally, if your device can only drive the low 24-bits of
+address you might do something like:
+
+	if (dma_set_mask(dev, DMA_BIT_MASK(24))) {
+		printk(KERN_WARNING
+		       "mydev: 24-bit DMA addressing not available.\n");
+		goto ignore_this_device;
+	}
+
+When dma_set_mask() or dma_set_mask_and_coherent() is successful, and
+returns zero, the kernel saves away this mask you have provided.  The
+kernel will use this information later when you make DMA mappings.
+
+There is a case which we are aware of at this time, which is worth
+mentioning in this documentation.  If your device supports multiple
+functions (for example a sound card provides playback and record
+functions) and the various different functions have _different_
+DMA addressing limitations, you may wish to probe each mask and
+only provide the functionality which the machine can handle.  It
+is important that the last call to dma_set_mask() be for the
+most specific mask.
+
+Here is pseudo-code showing how this might be done:
+
+	#define PLAYBACK_ADDRESS_BITS	DMA_BIT_MASK(32)
+	#define RECORD_ADDRESS_BITS	DMA_BIT_MASK(24)
+
+	struct my_sound_card *card;
+	struct device *dev;
+
+	...
+	if (!dma_set_mask(dev, PLAYBACK_ADDRESS_BITS)) {
+		card->playback_enabled = 1;
+	} else {
+		card->playback_enabled = 0;
+		printk(KERN_WARNING "%s: Playback disabled due to DMA limitations.\n",
+		       card->name);
+	}
+	if (!dma_set_mask(dev, RECORD_ADDRESS_BITS)) {
+		card->record_enabled = 1;
+	} else {
+		card->record_enabled = 0;
+		printk(KERN_WARNING "%s: Record disabled due to DMA limitations.\n",
+		       card->name);
+	}
+
+A sound card was used as an example here because this genre of PCI
+devices seems to be littered with ISA chips given a PCI front end,
+and thus retaining the 16MB DMA addressing limitations of ISA.
+
+			Types of DMA mappings
+
+There are two types of DMA mappings:
+
+- Consistent DMA mappings which are usually mapped at driver
+  initialization, unmapped at the end and for which the hardware should
+  guarantee that the device and the CPU can access the data
+  in parallel and will see updates made by each other without any
+  explicit software flushing.
+
+  Think of "consistent" as "synchronous" or "coherent".
+
+  The current default is to return consistent memory in the low 32
+  bits of the bus space.  However, for future compatibility you should
+  set the consistent mask even if this default is fine for your
+  driver.
+
+  Good examples of what to use consistent mappings for are:
+
+	- Network card DMA ring descriptors.
+	- SCSI adapter mailbox command data structures.
+	- Device firmware microcode executed out of
+	  main memory.
+
+  The invariant these examples all require is that any CPU store
+  to memory is immediately visible to the device, and vice
+  versa.  Consistent mappings guarantee this.
+
+  IMPORTANT: Consistent DMA memory does not preclude the usage of
+             proper memory barriers.  The CPU may reorder stores to
+	     consistent memory just as it may normal memory.  Example:
+	     if it is important for the device to see the first word
+	     of a descriptor updated before the second, you must do
+	     something like:
+
+		desc->word0 = address;
+		wmb();
+		desc->word1 = DESC_VALID;
+
+             in order to get correct behavior on all platforms.
+
+	     Also, on some platforms your driver may need to flush CPU write
+	     buffers in much the same way as it needs to flush write buffers
+	     found in PCI bridges (such as by reading a register's value
+	     after writing it).
+
+- Streaming DMA mappings which are usually mapped for one DMA
+  transfer, unmapped right after it (unless you use dma_sync_* below)
+  and for which hardware can optimize for sequential accesses.
+
+  This of "streaming" as "asynchronous" or "outside the coherency
+  domain".
+
+  Good examples of what to use streaming mappings for are:
+
+	- Networking buffers transmitted/received by a device.
+	- Filesystem buffers written/read by a SCSI device.
+
+  The interfaces for using this type of mapping were designed in
+  such a way that an implementation can make whatever performance
+  optimizations the hardware allows.  To this end, when using
+  such mappings you must be explicit about what you want to happen.
+
+Neither type of DMA mapping has alignment restrictions that come from
+the underlying bus, although some devices may have such restrictions.
+Also, systems with caches that aren't DMA-coherent will work better
+when the underlying buffers don't share cache lines with other data.
+
+
+		 Using Consistent DMA mappings.
+
+To allocate and map large (PAGE_SIZE or so) consistent DMA regions,
+you should do:
+
+	dma_addr_t dma_handle;
+
+	cpu_addr = dma_alloc_coherent(dev, size, &dma_handle, gfp);
+
+where device is a struct device *. This may be called in interrupt
+context with the GFP_ATOMIC flag.
+
+Size is the length of the region you want to allocate, in bytes.
+
+This routine will allocate RAM for that region, so it acts similarly to
+__get_free_pages (but takes size instead of a page order).  If your
+driver needs regions sized smaller than a page, you may prefer using
+the dma_pool interface, described below.
+
+The consistent DMA mapping interfaces, for non-NULL dev, will by
+default return a DMA address which is 32-bit addressable.  Even if the
+device indicates (via DMA mask) that it may address the upper 32-bits,
+consistent allocation will only return > 32-bit addresses for DMA if
+the consistent DMA mask has been explicitly changed via
+dma_set_coherent_mask().  This is true of the dma_pool interface as
+well.
+
+dma_alloc_coherent returns two values: the virtual address which you
+can use to access it from the CPU and dma_handle which you pass to the
+card.
+
+The cpu return address and the DMA bus master address are both
+guaranteed to be aligned to the smallest PAGE_SIZE order which
+is greater than or equal to the requested size.  This invariant
+exists (for example) to guarantee that if you allocate a chunk
+which is smaller than or equal to 64 kilobytes, the extent of the
+buffer you receive will not cross a 64K boundary.
+
+To unmap and free such a DMA region, you call:
+
+	dma_free_coherent(dev, size, cpu_addr, dma_handle);
+
+where dev, size are the same as in the above call and cpu_addr and
+dma_handle are the values dma_alloc_coherent returned to you.
+This function may not be called in interrupt context.
+
+If your driver needs lots of smaller memory regions, you can write
+custom code to subdivide pages returned by dma_alloc_coherent,
+or you can use the dma_pool API to do that.  A dma_pool is like
+a kmem_cache, but it uses dma_alloc_coherent not __get_free_pages.
+Also, it understands common hardware constraints for alignment,
+like queue heads needing to be aligned on N byte boundaries.
+
+Create a dma_pool like this:
+
+	struct dma_pool *pool;
+
+	pool = dma_pool_create(name, dev, size, align, alloc);
+
+The "name" is for diagnostics (like a kmem_cache name); dev and size
+are as above.  The device's hardware alignment requirement for this
+type of data is "align" (which is expressed in bytes, and must be a
+power of two).  If your device has no boundary crossing restrictions,
+pass 0 for alloc; passing 4096 says memory allocated from this pool
+must not cross 4KByte boundaries (but at that time it may be better to
+go for dma_alloc_coherent directly instead).
+
+Allocate memory from a dma pool like this:
+
+	cpu_addr = dma_pool_alloc(pool, flags, &dma_handle);
+
+flags are SLAB_KERNEL if blocking is permitted (not in_interrupt nor
+holding SMP locks), SLAB_ATOMIC otherwise.  Like dma_alloc_coherent,
+this returns two values, cpu_addr and dma_handle.
+
+Free memory that was allocated from a dma_pool like this:
+
+	dma_pool_free(pool, cpu_addr, dma_handle);
+
+where pool is what you passed to dma_pool_alloc, and cpu_addr and
+dma_handle are the values dma_pool_alloc returned. This function
+may be called in interrupt context.
+
+Destroy a dma_pool by calling:
+
+	dma_pool_destroy(pool);
+
+Make sure you've called dma_pool_free for all memory allocated
+from a pool before you destroy the pool. This function may not
+be called in interrupt context.
+
+			DMA Direction
+
+The interfaces described in subsequent portions of this document
+take a DMA direction argument, which is an integer and takes on
+one of the following values:
+
+ DMA_BIDIRECTIONAL
+ DMA_TO_DEVICE
+ DMA_FROM_DEVICE
+ DMA_NONE
+
+One should provide the exact DMA direction if you know it.
+
+DMA_TO_DEVICE means "from main memory to the device"
+DMA_FROM_DEVICE means "from the device to main memory"
+It is the direction in which the data moves during the DMA
+transfer.
+
+You are _strongly_ encouraged to specify this as precisely
+as you possibly can.
+
+If you absolutely cannot know the direction of the DMA transfer,
+specify DMA_BIDIRECTIONAL.  It means that the DMA can go in
+either direction.  The platform guarantees that you may legally
+specify this, and that it will work, but this may be at the
+cost of performance for example.
+
+The value DMA_NONE is to be used for debugging.  One can
+hold this in a data structure before you come to know the
+precise direction, and this will help catch cases where your
+direction tracking logic has failed to set things up properly.
+
+Another advantage of specifying this value precisely (outside of
+potential platform-specific optimizations of such) is for debugging.
+Some platforms actually have a write permission boolean which DMA
+mappings can be marked with, much like page protections in the user
+program address space.  Such platforms can and do report errors in the
+kernel logs when the DMA controller hardware detects violation of the
+permission setting.
+
+Only streaming mappings specify a direction, consistent mappings
+implicitly have a direction attribute setting of
+DMA_BIDIRECTIONAL.
+
+The SCSI subsystem tells you the direction to use in the
+'sc_data_direction' member of the SCSI command your driver is
+working on.
+
+For Networking drivers, it's a rather simple affair.  For transmit
+packets, map/unmap them with the DMA_TO_DEVICE direction
+specifier.  For receive packets, just the opposite, map/unmap them
+with the DMA_FROM_DEVICE direction specifier.
+
+		  Using Streaming DMA mappings
+
+The streaming DMA mapping routines can be called from interrupt
+context.  There are two versions of each map/unmap, one which will
+map/unmap a single memory region, and one which will map/unmap a
+scatterlist.
+
+To map a single region, you do:
+
+	struct device *dev = &my_dev->dev;
+	dma_addr_t dma_handle;
+	void *addr = buffer->ptr;
+	size_t size = buffer->len;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dma_handle)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling;
+	}
+
+and to unmap it:
+
+	dma_unmap_single(dev, dma_handle, size, direction);
+
+You should call dma_mapping_error() as dma_map_single() could fail and return
+error. Not all dma implementations support dma_mapping_error() interface.
+However, it is a good practice to call dma_mapping_error() interface, which
+will invoke the generic mapping error check interface. Doing so will ensure
+that the mapping code will work correctly on all dma implementations without
+any dependency on the specifics of the underlying implementation. Using the
+returned address without checking for errors could result in failures ranging
+from panics to silent data corruption. A couple of examples of incorrect ways
+to check for errors that make assumptions about the underlying dma
+implementation are as follows and these are applicable to dma_map_page() as
+well.
+
+Incorrect example 1:
+	dma_addr_t dma_handle;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if ((dma_handle & 0xffff != 0) || (dma_handle >= 0x1000000)) {
+		goto map_error;
+	}
+
+Incorrect example 2:
+	dma_addr_t dma_handle;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (dma_handle == DMA_ERROR_CODE) {
+		goto map_error;
+	}
+
+You should call dma_unmap_single when the DMA activity is finished, e.g.
+from the interrupt which told you that the DMA transfer is done.
+
+Using cpu pointers like this for single mappings has a disadvantage,
+you cannot reference HIGHMEM memory in this way.  Thus, there is a
+map/unmap interface pair akin to dma_{map,unmap}_single.  These
+interfaces deal with page/offset pairs instead of cpu pointers.
+Specifically:
+
+	struct device *dev = &my_dev->dev;
+	dma_addr_t dma_handle;
+	struct page *page = buffer->page;
+	unsigned long offset = buffer->offset;
+	size_t size = buffer->len;
+
+	dma_handle = dma_map_page(dev, page, offset, size, direction);
+	if (dma_mapping_error(dma_handle)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling;
+	}
+
+	...
+
+	dma_unmap_page(dev, dma_handle, size, direction);
+
+Here, "offset" means byte offset within the given page.
+
+You should call dma_mapping_error() as dma_map_page() could fail and return
+error as outlined under the dma_map_single() discussion.
+
+You should call dma_unmap_page when the DMA activity is finished, e.g.
+from the interrupt which told you that the DMA transfer is done.
+
+With scatterlists, you map a region gathered from several regions by:
+
+	int i, count = dma_map_sg(dev, sglist, nents, direction);
+	struct scatterlist *sg;
+
+	for_each_sg(sglist, sg, count, i) {
+		hw_address[i] = sg_dma_address(sg);
+		hw_len[i] = sg_dma_len(sg);
+	}
+
+where nents is the number of entries in the sglist.
+
+The implementation is free to merge several consecutive sglist entries
+into one (e.g. if DMA mapping is done with PAGE_SIZE granularity, any
+consecutive sglist entries can be merged into one provided the first one
+ends and the second one starts on a page boundary - in fact this is a huge
+advantage for cards which either cannot do scatter-gather or have very
+limited number of scatter-gather entries) and returns the actual number
+of sg entries it mapped them to. On failure 0 is returned.
+
+Then you should loop count times (note: this can be less than nents times)
+and use sg_dma_address() and sg_dma_len() macros where you previously
+accessed sg->address and sg->length as shown above.
+
+To unmap a scatterlist, just call:
+
+	dma_unmap_sg(dev, sglist, nents, direction);
+
+Again, make sure DMA activity has already finished.
+
+PLEASE NOTE:  The 'nents' argument to the dma_unmap_sg call must be
+              the _same_ one you passed into the dma_map_sg call,
+	      it should _NOT_ be the 'count' value _returned_ from the
+              dma_map_sg call.
+
+Every dma_map_{single,sg} call should have its dma_unmap_{single,sg}
+counterpart, because the bus address space is a shared resource (although
+in some ports the mapping is per each BUS so less devices contend for the
+same bus address space) and you could render the machine unusable by eating
+all bus addresses.
+
+If you need to use the same streaming DMA region multiple times and touch
+the data in between the DMA transfers, the buffer needs to be synced
+properly in order for the cpu and device to see the most uptodate and
+correct copy of the DMA buffer.
+
+So, firstly, just map it with dma_map_{single,sg}, and after each DMA
+transfer call either:
+
+	dma_sync_single_for_cpu(dev, dma_handle, size, direction);
+
+or:
+
+	dma_sync_sg_for_cpu(dev, sglist, nents, direction);
+
+as appropriate.
+
+Then, if you wish to let the device get at the DMA area again,
+finish accessing the data with the cpu, and then before actually
+giving the buffer to the hardware call either:
+
+	dma_sync_single_for_device(dev, dma_handle, size, direction);
+
+or:
+
+	dma_sync_sg_for_device(dev, sglist, nents, direction);
+
+as appropriate.
+
+After the last DMA transfer call one of the DMA unmap routines
+dma_unmap_{single,sg}. If you don't touch the data from the first dma_map_*
+call till dma_unmap_*, then you don't have to call the dma_sync_*
+routines at all.
+
+Here is pseudo code which shows a situation in which you would need
+to use the dma_sync_*() interfaces.
+
+	my_card_setup_receive_buffer(struct my_card *cp, char *buffer, int len)
+	{
+		dma_addr_t mapping;
+
+		mapping = dma_map_single(cp->dev, buffer, len, DMA_FROM_DEVICE);
+		if (dma_mapping_error(dma_handle)) {
+			/*
+			 * reduce current DMA mapping usage,
+			 * delay and try again later or
+			 * reset driver.
+			 */
+			goto map_error_handling;
+		}
+
+		cp->rx_buf = buffer;
+		cp->rx_len = len;
+		cp->rx_dma = mapping;
+
+		give_rx_buf_to_card(cp);
+	}
+
+	...
+
+	my_card_interrupt_handler(int irq, void *devid, struct pt_regs *regs)
+	{
+		struct my_card *cp = devid;
+
+		...
+		if (read_card_status(cp) == RX_BUF_TRANSFERRED) {
+			struct my_card_header *hp;
+
+			/* Examine the header to see if we wish
+			 * to accept the data.  But synchronize
+			 * the DMA transfer with the CPU first
+			 * so that we see updated contents.
+			 */
+			dma_sync_single_for_cpu(&cp->dev, cp->rx_dma,
+						cp->rx_len,
+						DMA_FROM_DEVICE);
+
+			/* Now it is safe to examine the buffer. */
+			hp = (struct my_card_header *) cp->rx_buf;
+			if (header_is_ok(hp)) {
+				dma_unmap_single(&cp->dev, cp->rx_dma, cp->rx_len,
+						 DMA_FROM_DEVICE);
+				pass_to_upper_layers(cp->rx_buf);
+				make_and_setup_new_rx_buf(cp);
+			} else {
+				/* CPU should not write to
+				 * DMA_FROM_DEVICE-mapped area,
+				 * so dma_sync_single_for_device() is
+				 * not needed here. It would be required
+				 * for DMA_BIDIRECTIONAL mapping if
+				 * the memory was modified.
+				 */
+				give_rx_buf_to_card(cp);
+			}
+		}
+	}
+
+Drivers converted fully to this interface should not use virt_to_bus any
+longer, nor should they use bus_to_virt. Some drivers have to be changed a
+little bit, because there is no longer an equivalent to bus_to_virt in the
+dynamic DMA mapping scheme - you have to always store the DMA addresses
+returned by the dma_alloc_coherent, dma_pool_alloc, and dma_map_single
+calls (dma_map_sg stores them in the scatterlist itself if the platform
+supports dynamic DMA mapping in hardware) in your driver structures and/or
+in the card registers.
+
+All drivers should be using these interfaces with no exceptions.  It
+is planned to completely remove virt_to_bus() and bus_to_virt() as
+they are entirely deprecated.  Some ports already do not provide these
+as it is impossible to correctly support them.
+
+			Handling Errors
+
+DMA address space is limited on some architectures and an allocation
+failure can be determined by:
+
+- checking if dma_alloc_coherent returns NULL or dma_map_sg returns 0
+
+- checking the returned dma_addr_t of dma_map_single and dma_map_page
+  by using dma_mapping_error():
+
+	dma_addr_t dma_handle;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dev, dma_handle)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling;
+	}
+
+- unmap pages that are already mapped, when mapping error occurs in the middle
+  of a multiple page mapping attempt. These example are applicable to
+  dma_map_page() as well.
+
+Example 1:
+	dma_addr_t dma_handle1;
+	dma_addr_t dma_handle2;
+
+	dma_handle1 = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dev, dma_handle1)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling1;
+	}
+	dma_handle2 = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dev, dma_handle2)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling2;
+	}
+
+	...
+
+	map_error_handling2:
+		dma_unmap_single(dma_handle1);
+	map_error_handling1:
+
+Example 2: (if buffers are allocated in a loop, unmap all mapped buffers when
+	    mapping error is detected in the middle)
+
+	dma_addr_t dma_addr;
+	dma_addr_t array[DMA_BUFFERS];
+	int save_index = 0;
+
+	for (i = 0; i < DMA_BUFFERS; i++) {
+
+		...
+
+		dma_addr = dma_map_single(dev, addr, size, direction);
+		if (dma_mapping_error(dev, dma_addr)) {
+			/*
+			 * reduce current DMA mapping usage,
+			 * delay and try again later or
+			 * reset driver.
+			 */
+			goto map_error_handling;
+		}
+		array[i].dma_addr = dma_addr;
+		save_index++;
+	}
+
+	...
+
+	map_error_handling:
+
+	for (i = 0; i < save_index; i++) {
+
+		...
+
+		dma_unmap_single(array[i].dma_addr);
+	}
+
+Networking drivers must call dev_kfree_skb to free the socket buffer
+and return NETDEV_TX_OK if the DMA mapping fails on the transmit hook
+(ndo_start_xmit). This means that the socket buffer is just dropped in
+the failure case.
+
+SCSI drivers must return SCSI_MLQUEUE_HOST_BUSY if the DMA mapping
+fails in the queuecommand hook. This means that the SCSI subsystem
+passes the command to the driver again later.
+
+		Optimizing Unmap State Space Consumption
+
+On many platforms, dma_unmap_{single,page}() is simply a nop.
+Therefore, keeping track of the mapping address and length is a waste
+of space.  Instead of filling your drivers up with ifdefs and the like
+to "work around" this (which would defeat the whole purpose of a
+portable API) the following facilities are provided.
+
+Actually, instead of describing the macros one by one, we'll
+transform some example code.
+
+1) Use DEFINE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
+   Example, before:
+
+	struct ring_state {
+		struct sk_buff *skb;
+		dma_addr_t mapping;
+		__u32 len;
+	};
+
+   after:
+
+	struct ring_state {
+		struct sk_buff *skb;
+		DEFINE_DMA_UNMAP_ADDR(mapping);
+		DEFINE_DMA_UNMAP_LEN(len);
+	};
+
+2) Use dma_unmap_{addr,len}_set to set these values.
+   Example, before:
+
+	ringp->mapping = FOO;
+	ringp->len = BAR;
+
+   after:
+
+	dma_unmap_addr_set(ringp, mapping, FOO);
+	dma_unmap_len_set(ringp, len, BAR);
+
+3) Use dma_unmap_{addr,len} to access these values.
+   Example, before:
+
+	dma_unmap_single(dev, ringp->mapping, ringp->len,
+			 DMA_FROM_DEVICE);
+
+   after:
+
+	dma_unmap_single(dev,
+			 dma_unmap_addr(ringp, mapping),
+			 dma_unmap_len(ringp, len),
+			 DMA_FROM_DEVICE);
+
+It really should be self-explanatory.  We treat the ADDR and LEN
+separately, because it is possible for an implementation to only
+need the address in order to perform the unmap operation.
+
+			Platform Issues
+
+If you are just writing drivers for Linux and do not maintain
+an architecture port for the kernel, you can safely skip down
+to "Closing".
+
+1) Struct scatterlist requirements.
+
+   Don't invent the architecture specific struct scatterlist; just use
+   <asm-generic/scatterlist.h>. You need to enable
+   CONFIG_NEED_SG_DMA_LENGTH if the architecture supports IOMMUs
+   (including software IOMMU).
+
+2) ARCH_DMA_MINALIGN
+
+   Architectures must ensure that kmalloc'ed buffer is
+   DMA-safe. Drivers and subsystems depend on it. If an architecture
+   isn't fully DMA-coherent (i.e. hardware doesn't ensure that data in
+   the CPU cache is identical to data in main memory),
+   ARCH_DMA_MINALIGN must be set so that the memory allocator
+   makes sure that kmalloc'ed buffer doesn't share a cache line with
+   the others. See arch/arm/include/asm/cache.h as an example.
+
+   Note that ARCH_DMA_MINALIGN is about DMA memory alignment
+   constraints. You don't need to worry about the architecture data
+   alignment constraints (e.g. the alignment constraints about 64-bit
+   objects).
+
+3) Supporting multiple types of IOMMUs
+
+   If your architecture needs to support multiple types of IOMMUs, you
+   can use include/linux/asm-generic/dma-mapping-common.h. It's a
+   library to support the DMA API with multiple types of IOMMUs. Lots
+   of architectures (x86, powerpc, sh, alpha, ia64, microblaze and
+   sparc) use it. Choose one to see how it can be used. If you need to
+   support multiple types of IOMMUs in a single system, the example of
+   x86 or powerpc helps.
+
+			   Closing
+
+This document, and the API itself, would not be in its current
+form without the feedback and suggestions from numerous individuals.
+We would like to specifically mention, in no particular order, the
+following people:
+
+	Russell King <rmk@arm.linux.org.uk>
+	Leo Dagum <dagum@barrel.engr.sgi.com>
+	Ralf Baechle <ralf@oss.sgi.com>
+	Grant Grundler <grundler@cup.hp.com>
+	Jay Estabrook <Jay.Estabrook@compaq.com>
+	Thomas Sailer <sailer@ife.ee.ethz.ch>
+	Andrea Arcangeli <andrea@suse.de>
+	Jens Axboe <jens.axboe@oracle.com>
+	David Mosberger-Tang <davidm@hpl.hp.com>
diff --git a/Documentation/dma/DMA-API.txt b/Documentation/dma/DMA-API.txt
new file mode 100644
index 0000000..e865279
--- /dev/null
+++ b/Documentation/dma/DMA-API.txt
@@ -0,0 +1,700 @@
+               Dynamic DMA mapping using the generic device
+               ============================================
+
+        James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
+
+This document describes the DMA API.  For a more gentle introduction
+of the API (and actual examples) see
+Documentation/DMA-API-HOWTO.txt.
+
+This API is split into two pieces.  Part I describes the API.  Part II
+describes the extensions to the API for supporting non-consistent
+memory machines.  Unless you know that your driver absolutely has to
+support non-consistent platforms (this is usually only legacy
+platforms) you should only use the API described in part I.
+
+Part I - dma_ API
+-------------------------------------
+
+To get the dma_ API, you must #include <linux/dma-mapping.h>
+
+
+Part Ia - Using large dma-coherent buffers
+------------------------------------------
+
+void *
+dma_alloc_coherent(struct device *dev, size_t size,
+			     dma_addr_t *dma_handle, gfp_t flag)
+
+Consistent memory is memory for which a write by either the device or
+the processor can immediately be read by the processor or device
+without having to worry about caching effects.  (You may however need
+to make sure to flush the processor's write buffers before telling
+devices to read that memory.)
+
+This routine allocates a region of <size> bytes of consistent memory.
+It also returns a <dma_handle> which may be cast to an unsigned
+integer the same width as the bus and used as the physical address
+base of the region.
+
+Returns: a pointer to the allocated region (in the processor's virtual
+address space) or NULL if the allocation failed.
+
+Note: consistent memory can be expensive on some platforms, and the
+minimum allocation length may be as big as a page, so you should
+consolidate your requests for consistent memory as much as possible.
+The simplest way to do that is to use the dma_pool calls (see below).
+
+The flag parameter (dma_alloc_coherent only) allows the caller to
+specify the GFP_ flags (see kmalloc) for the allocation (the
+implementation may choose to ignore flags that affect the location of
+the returned memory, like GFP_DMA).
+
+void *
+dma_zalloc_coherent(struct device *dev, size_t size,
+			     dma_addr_t *dma_handle, gfp_t flag)
+
+Wraps dma_alloc_coherent() and also zeroes the returned memory if the
+allocation attempt succeeded.
+
+void
+dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
+			   dma_addr_t dma_handle)
+
+Free the region of consistent memory you previously allocated.  dev,
+size and dma_handle must all be the same as those passed into the
+consistent allocate.  cpu_addr must be the virtual address returned by
+the consistent allocate.
+
+Note that unlike their sibling allocation calls, these routines
+may only be called with IRQs enabled.
+
+
+Part Ib - Using small dma-coherent buffers
+------------------------------------------
+
+To get this part of the dma_ API, you must #include <linux/dmapool.h>
+
+Many drivers need lots of small dma-coherent memory regions for DMA
+descriptors or I/O buffers.  Rather than allocating in units of a page
+or more using dma_alloc_coherent(), you can use DMA pools.  These work
+much like a struct kmem_cache, except that they use the dma-coherent allocator,
+not __get_free_pages().  Also, they understand common hardware constraints
+for alignment, like queue heads needing to be aligned on N-byte boundaries.
+
+
+	struct dma_pool *
+	dma_pool_create(const char *name, struct device *dev,
+			size_t size, size_t align, size_t alloc);
+
+The pool create() routines initialize a pool of dma-coherent buffers
+for use with a given device.  It must be called in a context which
+can sleep.
+
+The "name" is for diagnostics (like a struct kmem_cache name); dev and size
+are like what you'd pass to dma_alloc_coherent().  The device's hardware
+alignment requirement for this type of data is "align" (which is expressed
+in bytes, and must be a power of two).  If your device has no boundary
+crossing restrictions, pass 0 for alloc; passing 4096 says memory allocated
+from this pool must not cross 4KByte boundaries.
+
+
+	void *dma_pool_alloc(struct dma_pool *pool, gfp_t gfp_flags,
+			dma_addr_t *dma_handle);
+
+This allocates memory from the pool; the returned memory will meet the size
+and alignment requirements specified at creation time.  Pass GFP_ATOMIC to
+prevent blocking, or if it's permitted (not in_interrupt, not holding SMP locks),
+pass GFP_KERNEL to allow blocking.  Like dma_alloc_coherent(), this returns
+two values:  an address usable by the cpu, and the dma address usable by the
+pool's device.
+
+
+	void dma_pool_free(struct dma_pool *pool, void *vaddr,
+			dma_addr_t addr);
+
+This puts memory back into the pool.  The pool is what was passed to
+the pool allocation routine; the cpu (vaddr) and dma addresses are what
+were returned when that routine allocated the memory being freed.
+
+
+	void dma_pool_destroy(struct dma_pool *pool);
+
+The pool destroy() routines free the resources of the pool.  They must be
+called in a context which can sleep.  Make sure you've freed all allocated
+memory back to the pool before you destroy it.
+
+
+Part Ic - DMA addressing limitations
+------------------------------------
+
+int
+dma_supported(struct device *dev, u64 mask)
+
+Checks to see if the device can support DMA to the memory described by
+mask.
+
+Returns: 1 if it can and 0 if it can't.
+
+Notes: This routine merely tests to see if the mask is possible.  It
+won't change the current mask settings.  It is more intended as an
+internal API for use by the platform than an external API for use by
+driver writers.
+
+int
+dma_set_mask_and_coherent(struct device *dev, u64 mask)
+
+Checks to see if the mask is possible and updates the device
+streaming and coherent DMA mask parameters if it is.
+
+Returns: 0 if successful and a negative error if not.
+
+int
+dma_set_mask(struct device *dev, u64 mask)
+
+Checks to see if the mask is possible and updates the device
+parameters if it is.
+
+Returns: 0 if successful and a negative error if not.
+
+int
+dma_set_coherent_mask(struct device *dev, u64 mask)
+
+Checks to see if the mask is possible and updates the device
+parameters if it is.
+
+Returns: 0 if successful and a negative error if not.
+
+u64
+dma_get_required_mask(struct device *dev)
+
+This API returns the mask that the platform requires to
+operate efficiently.  Usually this means the returned mask
+is the minimum required to cover all of memory.  Examining the
+required mask gives drivers with variable descriptor sizes the
+opportunity to use smaller descriptors as necessary.
+
+Requesting the required mask does not alter the current mask.  If you
+wish to take advantage of it, you should issue a dma_set_mask()
+call to set the mask to the value returned.
+
+
+Part Id - Streaming DMA mappings
+--------------------------------
+
+dma_addr_t
+dma_map_single(struct device *dev, void *cpu_addr, size_t size,
+		      enum dma_data_direction direction)
+
+Maps a piece of processor virtual memory so it can be accessed by the
+device and returns the physical handle of the memory.
+
+The direction for both api's may be converted freely by casting.
+However the dma_ API uses a strongly typed enumerator for its
+direction:
+
+DMA_NONE		no direction (used for debugging)
+DMA_TO_DEVICE		data is going from the memory to the device
+DMA_FROM_DEVICE		data is coming from the device to the memory
+DMA_BIDIRECTIONAL	direction isn't known
+
+Notes:  Not all memory regions in a machine can be mapped by this
+API.  Further, regions that appear to be physically contiguous in
+kernel virtual space may not be contiguous as physical memory.  Since
+this API does not provide any scatter/gather capability, it will fail
+if the user tries to map a non-physically contiguous piece of memory.
+For this reason, it is recommended that memory mapped by this API be
+obtained only from sources which guarantee it to be physically contiguous
+(like kmalloc).
+
+Further, the physical address of the memory must be within the
+dma_mask of the device (the dma_mask represents a bit mask of the
+addressable region for the device.  I.e., if the physical address of
+the memory anded with the dma_mask is still equal to the physical
+address, then the device can perform DMA to the memory).  In order to
+ensure that the memory allocated by kmalloc is within the dma_mask,
+the driver may specify various platform-dependent flags to restrict
+the physical memory range of the allocation (e.g. on x86, GFP_DMA
+guarantees to be within the first 16Mb of available physical memory,
+as required by ISA devices).
+
+Note also that the above constraints on physical contiguity and
+dma_mask may not apply if the platform has an IOMMU (a device which
+supplies a physical to virtual mapping between the I/O memory bus and
+the device).  However, to be portable, device driver writers may *not*
+assume that such an IOMMU exists.
+
+Warnings:  Memory coherency operates at a granularity called the cache
+line width.  In order for memory mapped by this API to operate
+correctly, the mapped region must begin exactly on a cache line
+boundary and end exactly on one (to prevent two separately mapped
+regions from sharing a single cache line).  Since the cache line size
+may not be known at compile time, the API will not enforce this
+requirement.  Therefore, it is recommended that driver writers who
+don't take special care to determine the cache line size at run time
+only map virtual regions that begin and end on page boundaries (which
+are guaranteed also to be cache line boundaries).
+
+DMA_TO_DEVICE synchronisation must be done after the last modification
+of the memory region by the software and before it is handed off to
+the driver.  Once this primitive is used, memory covered by this
+primitive should be treated as read-only by the device.  If the device
+may write to it at any point, it should be DMA_BIDIRECTIONAL (see
+below).
+
+DMA_FROM_DEVICE synchronisation must be done before the driver
+accesses data that may be changed by the device.  This memory should
+be treated as read-only by the driver.  If the driver needs to write
+to it at any point, it should be DMA_BIDIRECTIONAL (see below).
+
+DMA_BIDIRECTIONAL requires special handling: it means that the driver
+isn't sure if the memory was modified before being handed off to the
+device and also isn't sure if the device will also modify it.  Thus,
+you must always sync bidirectional memory twice: once before the
+memory is handed off to the device (to make sure all memory changes
+are flushed from the processor) and once before the data may be
+accessed after being used by the device (to make sure any processor
+cache lines are updated with data that the device may have changed).
+
+void
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		 enum dma_data_direction direction)
+
+Unmaps the region previously mapped.  All the parameters passed in
+must be identical to those passed in (and returned) by the mapping
+API.
+
+dma_addr_t
+dma_map_page(struct device *dev, struct page *page,
+		    unsigned long offset, size_t size,
+		    enum dma_data_direction direction)
+void
+dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+	       enum dma_data_direction direction)
+
+API for mapping and unmapping for pages.  All the notes and warnings
+for the other mapping APIs apply here.  Also, although the <offset>
+and <size> parameters are provided to do partial page mapping, it is
+recommended that you never use these unless you really know what the
+cache width is.
+
+int
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+
+In some circumstances dma_map_single and dma_map_page will fail to create
+a mapping. A driver can check for these errors by testing the returned
+dma address with dma_mapping_error(). A non-zero return value means the mapping
+could not be created and the driver should take appropriate action (e.g.
+reduce current DMA mapping usage or delay and try again later).
+
+	int
+	dma_map_sg(struct device *dev, struct scatterlist *sg,
+		int nents, enum dma_data_direction direction)
+
+Returns: the number of physical segments mapped (this may be shorter
+than <nents> passed in if some elements of the scatter/gather list are
+physically or virtually adjacent and an IOMMU maps them with a single
+entry).
+
+Please note that the sg cannot be mapped again if it has been mapped once.
+The mapping process is allowed to destroy information in the sg.
+
+As with the other mapping interfaces, dma_map_sg can fail. When it
+does, 0 is returned and a driver must take appropriate action. It is
+critical that the driver do something, in the case of a block driver
+aborting the request or even oopsing is better than doing nothing and
+corrupting the filesystem.
+
+With scatterlists, you use the resulting mapping like this:
+
+	int i, count = dma_map_sg(dev, sglist, nents, direction);
+	struct scatterlist *sg;
+
+	for_each_sg(sglist, sg, count, i) {
+		hw_address[i] = sg_dma_address(sg);
+		hw_len[i] = sg_dma_len(sg);
+	}
+
+where nents is the number of entries in the sglist.
+
+The implementation is free to merge several consecutive sglist entries
+into one (e.g. with an IOMMU, or if several pages just happen to be
+physically contiguous) and returns the actual number of sg entries it
+mapped them to. On failure 0, is returned.
+
+Then you should loop count times (note: this can be less than nents times)
+and use sg_dma_address() and sg_dma_len() macros where you previously
+accessed sg->address and sg->length as shown above.
+
+	void
+	dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+		int nhwentries, enum dma_data_direction direction)
+
+Unmap the previously mapped scatter/gather list.  All the parameters
+must be the same as those and passed in to the scatter/gather mapping
+API.
+
+Note: <nents> must be the number you passed in, *not* the number of
+physical entries returned.
+
+void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction direction)
+void
+dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
+			   enum dma_data_direction direction)
+void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		    enum dma_data_direction direction)
+void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
+		       enum dma_data_direction direction)
+
+Synchronise a single contiguous or scatter/gather mapping for the cpu
+and device. With the sync_sg API, all the parameters must be the same
+as those passed into the single mapping API. With the sync_single API,
+you can use dma_handle and size parameters that aren't identical to
+those passed into the single mapping API to do a partial sync.
+
+Notes:  You must do this:
+
+- Before reading values that have been written by DMA from the device
+  (use the DMA_FROM_DEVICE direction)
+- After writing values that will be written to the device using DMA
+  (use the DMA_TO_DEVICE) direction
+- before *and* after handing memory to the device if the memory is
+  DMA_BIDIRECTIONAL
+
+See also dma_map_single().
+
+dma_addr_t
+dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
+		     enum dma_data_direction dir,
+		     struct dma_attrs *attrs)
+
+void
+dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
+		       size_t size, enum dma_data_direction dir,
+		       struct dma_attrs *attrs)
+
+int
+dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
+		 int nents, enum dma_data_direction dir,
+		 struct dma_attrs *attrs)
+
+void
+dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
+		   int nents, enum dma_data_direction dir,
+		   struct dma_attrs *attrs)
+
+The four functions above are just like the counterpart functions
+without the _attrs suffixes, except that they pass an optional
+struct dma_attrs*.
+
+struct dma_attrs encapsulates a set of "dma attributes". For the
+definition of struct dma_attrs see linux/dma-attrs.h.
+
+The interpretation of dma attributes is architecture-specific, and
+each attribute should be documented in Documentation/DMA-attributes.txt.
+
+If struct dma_attrs* is NULL, the semantics of each of these
+functions is identical to those of the corresponding function
+without the _attrs suffix. As a result dma_map_single_attrs()
+can generally replace dma_map_single(), etc.
+
+As an example of the use of the *_attrs functions, here's how
+you could pass an attribute DMA_ATTR_FOO when mapping memory
+for DMA:
+
+#include <linux/dma-attrs.h>
+/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h and
+ * documented in Documentation/DMA-attributes.txt */
+...
+
+	DEFINE_DMA_ATTRS(attrs);
+	dma_set_attr(DMA_ATTR_FOO, &attrs);
+	....
+	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
+	....
+
+Architectures that care about DMA_ATTR_FOO would check for its
+presence in their implementations of the mapping and unmapping
+routines, e.g.:
+
+void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
+			     size_t size, enum dma_data_direction dir,
+			     struct dma_attrs *attrs)
+{
+	....
+	int foo =  dma_get_attr(DMA_ATTR_FOO, attrs);
+	....
+	if (foo)
+		/* twizzle the frobnozzle */
+	....
+
+
+Part II - Advanced dma_ usage
+-----------------------------
+
+Warning: These pieces of the DMA API should not be used in the
+majority of cases, since they cater for unlikely corner cases that
+don't belong in usual drivers.
+
+If you don't understand how cache line coherency works between a
+processor and an I/O device, you should not be using this part of the
+API at all.
+
+void *
+dma_alloc_noncoherent(struct device *dev, size_t size,
+			       dma_addr_t *dma_handle, gfp_t flag)
+
+Identical to dma_alloc_coherent() except that the platform will
+choose to return either consistent or non-consistent memory as it sees
+fit.  By using this API, you are guaranteeing to the platform that you
+have all the correct and necessary sync points for this memory in the
+driver should it choose to return non-consistent memory.
+
+Note: where the platform can return consistent memory, it will
+guarantee that the sync points become nops.
+
+Warning:  Handling non-consistent memory is a real pain.  You should
+only ever use this API if you positively know your driver will be
+required to work on one of the rare (usually non-PCI) architectures
+that simply cannot make consistent memory.
+
+void
+dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
+			      dma_addr_t dma_handle)
+
+Free memory allocated by the nonconsistent API.  All parameters must
+be identical to those passed in (and returned by
+dma_alloc_noncoherent()).
+
+int
+dma_get_cache_alignment(void)
+
+Returns the processor cache alignment.  This is the absolute minimum
+alignment *and* width that you must observe when either mapping
+memory or doing partial flushes.
+
+Notes: This API may return a number *larger* than the actual cache
+line, but it will guarantee that one or more cache lines fit exactly
+into the width returned by this call.  It will also always be a power
+of two for easy alignment.
+
+void
+dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+	       enum dma_data_direction direction)
+
+Do a partial sync of memory that was allocated by
+dma_alloc_noncoherent(), starting at virtual address vaddr and
+continuing on for size.  Again, you *must* observe the cache line
+boundaries when doing this.
+
+int
+dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+			    dma_addr_t device_addr, size_t size, int
+			    flags)
+
+Declare region of memory to be handed out by dma_alloc_coherent when
+it's asked for coherent memory for this device.
+
+bus_addr is the physical address to which the memory is currently
+assigned in the bus responding region (this will be used by the
+platform to perform the mapping).
+
+device_addr is the physical address the device needs to be programmed
+with actually to address this memory (this will be handed out as the
+dma_addr_t in dma_alloc_coherent()).
+
+size is the size of the area (must be multiples of PAGE_SIZE).
+
+flags can be or'd together and are:
+
+DMA_MEMORY_MAP - request that the memory returned from
+dma_alloc_coherent() be directly writable.
+
+DMA_MEMORY_IO - request that the memory returned from
+dma_alloc_coherent() be addressable using read/write/memcpy_toio etc.
+
+One or both of these flags must be present.
+
+DMA_MEMORY_INCLUDES_CHILDREN - make the declared memory be allocated by
+dma_alloc_coherent of any child devices of this one (for memory residing
+on a bridge).
+
+DMA_MEMORY_EXCLUSIVE - only allocate memory from the declared regions. 
+Do not allow dma_alloc_coherent() to fall back to system memory when
+it's out of memory in the declared region.
+
+The return value will be either DMA_MEMORY_MAP or DMA_MEMORY_IO and
+must correspond to a passed in flag (i.e. no returning DMA_MEMORY_IO
+if only DMA_MEMORY_MAP were passed in) for success or zero for
+failure.
+
+Note, for DMA_MEMORY_IO returns, all subsequent memory returned by
+dma_alloc_coherent() may no longer be accessed directly, but instead
+must be accessed using the correct bus functions.  If your driver
+isn't prepared to handle this contingency, it should not specify
+DMA_MEMORY_IO in the input flags.
+
+As a simplification for the platforms, only *one* such region of
+memory may be declared per device.
+
+For reasons of efficiency, most platforms choose to track the declared
+region only at the granularity of a page.  For smaller allocations,
+you should use the dma_pool() API.
+
+void
+dma_release_declared_memory(struct device *dev)
+
+Remove the memory region previously declared from the system.  This
+API performs *no* in-use checking for this region and will return
+unconditionally having removed all the required structures.  It is the
+driver's job to ensure that no parts of this memory region are
+currently in use.
+
+void *
+dma_mark_declared_memory_occupied(struct device *dev,
+				  dma_addr_t device_addr, size_t size)
+
+This is used to occupy specific regions of the declared space
+(dma_alloc_coherent() will hand out the first free region it finds).
+
+device_addr is the *device* address of the region requested.
+
+size is the size (and should be a page-sized multiple).
+
+The return value will be either a pointer to the processor virtual
+address of the memory, or an error (via PTR_ERR()) if any part of the
+region is occupied.
+
+Part III - Debug drivers use of the DMA-API
+-------------------------------------------
+
+The DMA-API as described above as some constraints. DMA addresses must be
+released with the corresponding function with the same size for example. With
+the advent of hardware IOMMUs it becomes more and more important that drivers
+do not violate those constraints. In the worst case such a violation can
+result in data corruption up to destroyed filesystems.
+
+To debug drivers and find bugs in the usage of the DMA-API checking code can
+be compiled into the kernel which will tell the developer about those
+violations. If your architecture supports it you can select the "Enable
+debugging of DMA-API usage" option in your kernel configuration. Enabling this
+option has a performance impact. Do not enable it in production kernels.
+
+If you boot the resulting kernel will contain code which does some bookkeeping
+about what DMA memory was allocated for which device. If this code detects an
+error it prints a warning message with some details into your kernel log. An
+example warning message may look like this:
+
+------------[ cut here ]------------
+WARNING: at /data2/repos/linux-2.6-iommu/lib/dma-debug.c:448
+	check_unmap+0x203/0x490()
+Hardware name:
+forcedeth 0000:00:08.0: DMA-API: device driver frees DMA memory with wrong
+	function [device address=0x00000000640444be] [size=66 bytes] [mapped as
+single] [unmapped as page]
+Modules linked in: nfsd exportfs bridge stp llc r8169
+Pid: 0, comm: swapper Tainted: G        W  2.6.28-dmatest-09289-g8bb99c0 #1
+Call Trace:
+ <IRQ>  [<ffffffff80240b22>] warn_slowpath+0xf2/0x130
+ [<ffffffff80647b70>] _spin_unlock+0x10/0x30
+ [<ffffffff80537e75>] usb_hcd_link_urb_to_ep+0x75/0xc0
+ [<ffffffff80647c22>] _spin_unlock_irqrestore+0x12/0x40
+ [<ffffffff8055347f>] ohci_urb_enqueue+0x19f/0x7c0
+ [<ffffffff80252f96>] queue_work+0x56/0x60
+ [<ffffffff80237e10>] enqueue_task_fair+0x20/0x50
+ [<ffffffff80539279>] usb_hcd_submit_urb+0x379/0xbc0
+ [<ffffffff803b78c3>] cpumask_next_and+0x23/0x40
+ [<ffffffff80235177>] find_busiest_group+0x207/0x8a0
+ [<ffffffff8064784f>] _spin_lock_irqsave+0x1f/0x50
+ [<ffffffff803c7ea3>] check_unmap+0x203/0x490
+ [<ffffffff803c8259>] debug_dma_unmap_page+0x49/0x50
+ [<ffffffff80485f26>] nv_tx_done_optimized+0xc6/0x2c0
+ [<ffffffff80486c13>] nv_nic_irq_optimized+0x73/0x2b0
+ [<ffffffff8026df84>] handle_IRQ_event+0x34/0x70
+ [<ffffffff8026ffe9>] handle_edge_irq+0xc9/0x150
+ [<ffffffff8020e3ab>] do_IRQ+0xcb/0x1c0
+ [<ffffffff8020c093>] ret_from_intr+0x0/0xa
+ <EOI> <4>---[ end trace f6435a98e2a38c0e ]---
+
+The driver developer can find the driver and the device including a stacktrace
+of the DMA-API call which caused this warning.
+
+Per default only the first error will result in a warning message. All other
+errors will only silently counted. This limitation exist to prevent the code
+from flooding your kernel log. To support debugging a device driver this can
+be disabled via debugfs. See the debugfs interface documentation below for
+details.
+
+The debugfs directory for the DMA-API debugging code is called dma-api/. In
+this directory the following files can currently be found:
+
+	dma-api/all_errors	This file contains a numeric value. If this
+				value is not equal to zero the debugging code
+				will print a warning for every error it finds
+				into the kernel log. Be careful with this
+				option, as it can easily flood your logs.
+
+	dma-api/disabled	This read-only file contains the character 'Y'
+				if the debugging code is disabled. This can
+				happen when it runs out of memory or if it was
+				disabled at boot time
+
+	dma-api/error_count	This file is read-only and shows the total
+				numbers of errors found.
+
+	dma-api/num_errors	The number in this file shows how many
+				warnings will be printed to the kernel log
+				before it stops. This number is initialized to
+				one at system boot and be set by writing into
+				this file
+
+	dma-api/min_free_entries
+				This read-only file can be read to get the
+				minimum number of free dma_debug_entries the
+				allocator has ever seen. If this value goes
+				down to zero the code will disable itself
+				because it is not longer reliable.
+
+	dma-api/num_free_entries
+				The current number of free dma_debug_entries
+				in the allocator.
+
+	dma-api/driver-filter
+				You can write a name of a driver into this file
+				to limit the debug output to requests from that
+				particular driver. Write an empty string to
+				that file to disable the filter and see
+				all errors again.
+
+If you have this code compiled into your kernel it will be enabled by default.
+If you want to boot without the bookkeeping anyway you can provide
+'dma_debug=off' as a boot parameter. This will disable DMA-API debugging.
+Notice that you can not enable it again at runtime. You have to reboot to do
+so.
+
+If you want to see debug messages only for a special device driver you can
+specify the dma_debug_driver=<drivername> parameter. This will enable the
+driver filter at boot time. The debug code will only print errors for that
+driver afterwards. This filter can be disabled or changed later using debugfs.
+
+When the code disables itself at runtime this is most likely because it ran
+out of dma_debug_entries. These entries are preallocated at boot. The number
+of preallocated entries is defined per architecture. If it is too low for you
+boot with 'dma_debug_entries=<your_desired_number>' to overwrite the
+architectural default.
+
+void debug_dmap_mapping_error(struct device *dev, dma_addr_t dma_addr);
+
+dma-debug interface debug_dma_mapping_error() to debug drivers that fail
+to check dma mapping errors on addresses returned by dma_map_single() and
+dma_map_page() interfaces. This interface clears a flag set by
+debug_dma_map_page() to indicate that dma_mapping_error() has been called by
+the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
+this flag is still set, prints warning message that includes call trace that
+leads up to the unmap. This interface can be called from dma_mapping_error()
+routines to enable dma mapping error check debugging.
+
diff --git a/Documentation/dma/DMA-ISA-LPC.txt b/Documentation/dma/DMA-ISA-LPC.txt
new file mode 100644
index 0000000..e767805
--- /dev/null
+++ b/Documentation/dma/DMA-ISA-LPC.txt
@@ -0,0 +1,151 @@
+                        DMA with ISA and LPC devices
+                        ============================
+
+                      Pierre Ossman <drzeus@drzeus.cx>
+
+This document describes how to do DMA transfers using the old ISA DMA
+controller. Even though ISA is more or less dead today the LPC bus
+uses the same DMA system so it will be around for quite some time.
+
+Part I - Headers and dependencies
+---------------------------------
+
+To do ISA style DMA you need to include two headers:
+
+#include <linux/dma-mapping.h>
+#include <asm/dma.h>
+
+The first is the generic DMA API used to convert virtual addresses to
+physical addresses (see Documentation/DMA-API.txt for details).
+
+The second contains the routines specific to ISA DMA transfers. Since
+this is not present on all platforms make sure you construct your
+Kconfig to be dependent on ISA_DMA_API (not ISA) so that nobody tries
+to build your driver on unsupported platforms.
+
+Part II - Buffer allocation
+---------------------------
+
+The ISA DMA controller has some very strict requirements on which
+memory it can access so extra care must be taken when allocating
+buffers.
+
+(You usually need a special buffer for DMA transfers instead of
+transferring directly to and from your normal data structures.)
+
+The DMA-able address space is the lowest 16 MB of _physical_ memory.
+Also the transfer block may not cross page boundaries (which are 64
+or 128 KiB depending on which channel you use).
+
+In order to allocate a piece of memory that satisfies all these
+requirements you pass the flag GFP_DMA to kmalloc.
+
+Unfortunately the memory available for ISA DMA is scarce so unless you
+allocate the memory during boot-up it's a good idea to also pass
+__GFP_REPEAT and __GFP_NOWARN to make the allocater try a bit harder.
+
+(This scarcity also means that you should allocate the buffer as
+early as possible and not release it until the driver is unloaded.)
+
+Part III - Address translation
+------------------------------
+
+To translate the virtual address to a physical use the normal DMA
+API. Do _not_ use isa_virt_to_phys() even though it does the same
+thing. The reason for this is that the function isa_virt_to_phys()
+will require a Kconfig dependency to ISA, not just ISA_DMA_API which
+is really all you need. Remember that even though the DMA controller
+has its origins in ISA it is used elsewhere.
+
+Note: x86_64 had a broken DMA API when it came to ISA but has since
+been fixed. If your arch has problems then fix the DMA API instead of
+reverting to the ISA functions.
+
+Part IV - Channels
+------------------
+
+A normal ISA DMA controller has 8 channels. The lower four are for
+8-bit transfers and the upper four are for 16-bit transfers.
+
+(Actually the DMA controller is really two separate controllers where
+channel 4 is used to give DMA access for the second controller (0-3).
+This means that of the four 16-bits channels only three are usable.)
+
+You allocate these in a similar fashion as all basic resources:
+
+extern int request_dma(unsigned int dmanr, const char * device_id);
+extern void free_dma(unsigned int dmanr);
+
+The ability to use 16-bit or 8-bit transfers is _not_ up to you as a
+driver author but depends on what the hardware supports. Check your
+specs or test different channels.
+
+Part V - Transfer data
+----------------------
+
+Now for the good stuff, the actual DMA transfer. :)
+
+Before you use any ISA DMA routines you need to claim the DMA lock
+using claim_dma_lock(). The reason is that some DMA operations are
+not atomic so only one driver may fiddle with the registers at a
+time.
+
+The first time you use the DMA controller you should call
+clear_dma_ff(). This clears an internal register in the DMA
+controller that is used for the non-atomic operations. As long as you
+(and everyone else) uses the locking functions then you only need to
+reset this once.
+
+Next, you tell the controller in which direction you intend to do the
+transfer using set_dma_mode(). Currently you have the options
+DMA_MODE_READ and DMA_MODE_WRITE.
+
+Set the address from where the transfer should start (this needs to
+be 16-bit aligned for 16-bit transfers) and how many bytes to
+transfer. Note that it's _bytes_. The DMA routines will do all the
+required translation to values that the DMA controller understands.
+
+The final step is enabling the DMA channel and releasing the DMA
+lock.
+
+Once the DMA transfer is finished (or timed out) you should disable
+the channel again. You should also check get_dma_residue() to make
+sure that all data has been transferred.
+
+Example:
+
+int flags, residue;
+
+flags = claim_dma_lock();
+
+clear_dma_ff();
+
+set_dma_mode(channel, DMA_MODE_WRITE);
+set_dma_addr(channel, phys_addr);
+set_dma_count(channel, num_bytes);
+
+dma_enable(channel);
+
+release_dma_lock(flags);
+
+while (!device_done());
+
+flags = claim_dma_lock();
+
+dma_disable(channel);
+
+residue = dma_get_residue(channel);
+if (residue != 0)
+	printk(KERN_ERR "driver: Incomplete DMA transfer!"
+		" %d bytes left!\n", residue);
+
+release_dma_lock(flags);
+
+Part VI - Suspend/resume
+------------------------
+
+It is the driver's responsibility to make sure that the machine isn't
+suspended while a DMA transfer is in progress. Also, all DMA settings
+are lost when the system suspends so if your driver relies on the DMA
+controller being in a certain state then you have to restore these
+registers upon resume.
diff --git a/Documentation/dma/DMA-attributes.txt b/Documentation/dma/DMA-attributes.txt
new file mode 100644
index 0000000..cc2450d
--- /dev/null
+++ b/Documentation/dma/DMA-attributes.txt
@@ -0,0 +1,102 @@
+			DMA attributes
+			==============
+
+This document describes the semantics of the DMA attributes that are
+defined in linux/dma-attrs.h.
+
+DMA_ATTR_WRITE_BARRIER
+----------------------
+
+DMA_ATTR_WRITE_BARRIER is a (write) barrier attribute for DMA.  DMA
+to a memory region with the DMA_ATTR_WRITE_BARRIER attribute forces
+all pending DMA writes to complete, and thus provides a mechanism to
+strictly order DMA from a device across all intervening busses and
+bridges.  This barrier is not specific to a particular type of
+interconnect, it applies to the system as a whole, and so its
+implementation must account for the idiosyncrasies of the system all
+the way from the DMA device to memory.
+
+As an example of a situation where DMA_ATTR_WRITE_BARRIER would be
+useful, suppose that a device does a DMA write to indicate that data is
+ready and available in memory.  The DMA of the "completion indication"
+could race with data DMA.  Mapping the memory used for completion
+indications with DMA_ATTR_WRITE_BARRIER would prevent the race.
+
+DMA_ATTR_WEAK_ORDERING
+----------------------
+
+DMA_ATTR_WEAK_ORDERING specifies that reads and writes to the mapping
+may be weakly ordered, that is that reads and writes may pass each other.
+
+Since it is optional for platforms to implement DMA_ATTR_WEAK_ORDERING,
+those that do not will simply ignore the attribute and exhibit default
+behavior.
+
+DMA_ATTR_WRITE_COMBINE
+----------------------
+
+DMA_ATTR_WRITE_COMBINE specifies that writes to the mapping may be
+buffered to improve performance.
+
+Since it is optional for platforms to implement DMA_ATTR_WRITE_COMBINE,
+those that do not will simply ignore the attribute and exhibit default
+behavior.
+
+DMA_ATTR_NON_CONSISTENT
+-----------------------
+
+DMA_ATTR_NON_CONSISTENT lets the platform to choose to return either
+consistent or non-consistent memory as it sees fit.  By using this API,
+you are guaranteeing to the platform that you have all the correct and
+necessary sync points for this memory in the driver.
+
+DMA_ATTR_NO_KERNEL_MAPPING
+--------------------------
+
+DMA_ATTR_NO_KERNEL_MAPPING lets the platform to avoid creating a kernel
+virtual mapping for the allocated buffer. On some architectures creating
+such mapping is non-trivial task and consumes very limited resources
+(like kernel virtual address space or dma consistent address space).
+Buffers allocated with this attribute can be only passed to user space
+by calling dma_mmap_attrs(). By using this API, you are guaranteeing
+that you won't dereference the pointer returned by dma_alloc_attr(). You
+can treat it as a cookie that must be passed to dma_mmap_attrs() and
+dma_free_attrs(). Make sure that both of these also get this attribute
+set on each call.
+
+Since it is optional for platforms to implement
+DMA_ATTR_NO_KERNEL_MAPPING, those that do not will simply ignore the
+attribute and exhibit default behavior.
+
+DMA_ATTR_SKIP_CPU_SYNC
+----------------------
+
+By default dma_map_{single,page,sg} functions family transfer a given
+buffer from CPU domain to device domain. Some advanced use cases might
+require sharing a buffer between more than one device. This requires
+having a mapping created separately for each device and is usually
+performed by calling dma_map_{single,page,sg} function more than once
+for the given buffer with device pointer to each device taking part in
+the buffer sharing. The first call transfers a buffer from 'CPU' domain
+to 'device' domain, what synchronizes CPU caches for the given region
+(usually it means that the cache has been flushed or invalidated
+depending on the dma direction). However, next calls to
+dma_map_{single,page,sg}() for other devices will perform exactly the
+same synchronization operation on the CPU cache. CPU cache synchronization
+might be a time consuming operation, especially if the buffers are
+large, so it is highly recommended to avoid it if possible.
+DMA_ATTR_SKIP_CPU_SYNC allows platform code to skip synchronization of
+the CPU cache for the given buffer assuming that it has been already
+transferred to 'device' domain. This attribute can be also used for
+dma_unmap_{single,page,sg} functions family to force buffer to stay in
+device domain after releasing a mapping for it. Use this attribute with
+care!
+
+DMA_ATTR_FORCE_CONTIGUOUS
+-------------------------
+
+By default DMA-mapping subsystem is allowed to assemble the buffer
+allocated by dma_alloc_attrs() function from individual pages if it can
+be mapped as contiguous chunk into device dma address space. By
+specifing this attribute the allocated buffer is forced to be contiguous
+also in physical memory.
diff --git a/Documentation/dma/dma-buf-sharing.txt b/Documentation/dma/dma-buf-sharing.txt
new file mode 100644
index 0000000..505e711
--- /dev/null
+++ b/Documentation/dma/dma-buf-sharing.txt
@@ -0,0 +1,462 @@
+                    DMA Buffer Sharing API Guide
+                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+                            Sumit Semwal
+                <sumit dot semwal at linaro dot org>
+                 <sumit dot semwal at ti dot com>
+
+This document serves as a guide to device-driver writers on what is the dma-buf
+buffer sharing API, how to use it for exporting and using shared buffers.
+
+Any device driver which wishes to be a part of DMA buffer sharing, can do so as
+either the 'exporter' of buffers, or the 'user' of buffers.
+
+Say a driver A wants to use buffers created by driver B, then we call B as the
+exporter, and A as buffer-user.
+
+The exporter
+- implements and manages operations[1] for the buffer
+- allows other users to share the buffer by using dma_buf sharing APIs,
+- manages the details of buffer allocation,
+- decides about the actual backing storage where this allocation happens,
+- takes care of any migration of scatterlist - for all (shared) users of this
+   buffer,
+
+The buffer-user
+- is one of (many) sharing users of the buffer.
+- doesn't need to worry about how the buffer is allocated, or where.
+- needs a mechanism to get access to the scatterlist that makes up this buffer
+   in memory, mapped into its own address space, so it can access the same area
+   of memory.
+
+dma-buf operations for device dma only
+--------------------------------------
+
+The dma_buf buffer sharing API usage contains the following steps:
+
+1. Exporter announces that it wishes to export a buffer
+2. Userspace gets the file descriptor associated with the exported buffer, and
+   passes it around to potential buffer-users based on use case
+3. Each buffer-user 'connects' itself to the buffer
+4. When needed, buffer-user requests access to the buffer from exporter
+5. When finished with its use, the buffer-user notifies end-of-DMA to exporter
+6. when buffer-user is done using this buffer completely, it 'disconnects'
+   itself from the buffer.
+
+
+1. Exporter's announcement of buffer export
+
+   The buffer exporter announces its wish to export a buffer. In this, it
+   connects its own private buffer data, provides implementation for operations
+   that can be performed on the exported dma_buf, and flags for the file
+   associated with this buffer.
+
+   Interface:
+      struct dma_buf *dma_buf_export_named(void *priv, struct dma_buf_ops *ops,
+				     size_t size, int flags,
+				     const char *exp_name)
+
+   If this succeeds, dma_buf_export allocates a dma_buf structure, and returns a
+   pointer to the same. It also associates an anonymous file with this buffer,
+   so it can be exported. On failure to allocate the dma_buf object, it returns
+   NULL.
+
+   'exp_name' is the name of exporter - to facilitate information while
+   debugging.
+
+   Exporting modules which do not wish to provide any specific name may use the
+   helper define 'dma_buf_export()', with the same arguments as above, but
+   without the last argument; a __FILE__ pre-processor directive will be
+   inserted in place of 'exp_name' instead.
+
+2. Userspace gets a handle to pass around to potential buffer-users
+
+   Userspace entity requests for a file-descriptor (fd) which is a handle to the
+   anonymous file associated with the buffer. It can then share the fd with other
+   drivers and/or processes.
+
+   Interface:
+      int dma_buf_fd(struct dma_buf *dmabuf)
+
+   This API installs an fd for the anonymous file associated with this buffer;
+   returns either 'fd', or error.
+
+3. Each buffer-user 'connects' itself to the buffer
+
+   Each buffer-user now gets a reference to the buffer, using the fd passed to
+   it.
+
+   Interface:
+      struct dma_buf *dma_buf_get(int fd)
+
+   This API will return a reference to the dma_buf, and increment refcount for
+   it.
+
+   After this, the buffer-user needs to attach its device with the buffer, which
+   helps the exporter to know of device buffer constraints.
+
+   Interface:
+      struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
+                                                struct device *dev)
+
+   This API returns reference to an attachment structure, which is then used
+   for scatterlist operations. It will optionally call the 'attach' dma_buf
+   operation, if provided by the exporter.
+
+   The dma-buf sharing framework does the bookkeeping bits related to managing
+   the list of all attachments to a buffer.
+
+Until this stage, the buffer-exporter has the option to choose not to actually
+allocate the backing storage for this buffer, but wait for the first buffer-user
+to request use of buffer for allocation.
+
+
+4. When needed, buffer-user requests access to the buffer
+
+   Whenever a buffer-user wants to use the buffer for any DMA, it asks for
+   access to the buffer using dma_buf_map_attachment API. At least one attach to
+   the buffer must have happened before map_dma_buf can be called.
+
+   Interface:
+      struct sg_table * dma_buf_map_attachment(struct dma_buf_attachment *,
+                                         enum dma_data_direction);
+
+   This is a wrapper to dma_buf->ops->map_dma_buf operation, which hides the
+   "dma_buf->ops->" indirection from the users of this interface.
+
+   In struct dma_buf_ops, map_dma_buf is defined as
+      struct sg_table * (*map_dma_buf)(struct dma_buf_attachment *,
+                                                enum dma_data_direction);
+
+   It is one of the buffer operations that must be implemented by the exporter.
+   It should return the sg_table containing scatterlist for this buffer, mapped
+   into caller's address space.
+
+   If this is being called for the first time, the exporter can now choose to
+   scan through the list of attachments for this buffer, collate the requirements
+   of the attached devices, and choose an appropriate backing storage for the
+   buffer.
+
+   Based on enum dma_data_direction, it might be possible to have multiple users
+   accessing at the same time (for reading, maybe), or any other kind of sharing
+   that the exporter might wish to make available to buffer-users.
+
+   map_dma_buf() operation can return -EINTR if it is interrupted by a signal.
+
+
+5. When finished, the buffer-user notifies end-of-DMA to exporter
+
+   Once the DMA for the current buffer-user is over, it signals 'end-of-DMA' to
+   the exporter using the dma_buf_unmap_attachment API.
+
+   Interface:
+      void dma_buf_unmap_attachment(struct dma_buf_attachment *,
+                                    struct sg_table *);
+
+   This is a wrapper to dma_buf->ops->unmap_dma_buf() operation, which hides the
+   "dma_buf->ops->" indirection from the users of this interface.
+
+   In struct dma_buf_ops, unmap_dma_buf is defined as
+      void (*unmap_dma_buf)(struct dma_buf_attachment *, struct sg_table *);
+
+   unmap_dma_buf signifies the end-of-DMA for the attachment provided. Like
+   map_dma_buf, this API also must be implemented by the exporter.
+
+
+6. when buffer-user is done using this buffer, it 'disconnects' itself from the
+   buffer.
+
+   After the buffer-user has no more interest in using this buffer, it should
+   disconnect itself from the buffer:
+
+   - it first detaches itself from the buffer.
+
+   Interface:
+      void dma_buf_detach(struct dma_buf *dmabuf,
+                          struct dma_buf_attachment *dmabuf_attach);
+
+   This API removes the attachment from the list in dmabuf, and optionally calls
+   dma_buf->ops->detach(), if provided by exporter, for any housekeeping bits.
+
+   - Then, the buffer-user returns the buffer reference to exporter.
+
+   Interface:
+     void dma_buf_put(struct dma_buf *dmabuf);
+
+   This API then reduces the refcount for this buffer.
+
+   If, as a result of this call, the refcount becomes 0, the 'release' file
+   operation related to this fd is called. It calls the dmabuf->ops->release()
+   operation in turn, and frees the memory allocated for dmabuf when exported.
+
+NOTES:
+- Importance of attach-detach and {map,unmap}_dma_buf operation pairs
+   The attach-detach calls allow the exporter to figure out backing-storage
+   constraints for the currently-interested devices. This allows preferential
+   allocation, and/or migration of pages across different types of storage
+   available, if possible.
+
+   Bracketing of DMA access with {map,unmap}_dma_buf operations is essential
+   to allow just-in-time backing of storage, and migration mid-way through a
+   use-case.
+
+- Migration of backing storage if needed
+   If after
+   - at least one map_dma_buf has happened,
+   - and the backing storage has been allocated for this buffer,
+   another new buffer-user intends to attach itself to this buffer, it might
+   be allowed, if possible for the exporter.
+
+   In case it is allowed by the exporter:
+    if the new buffer-user has stricter 'backing-storage constraints', and the
+    exporter can handle these constraints, the exporter can just stall on the
+    map_dma_buf until all outstanding access is completed (as signalled by
+    unmap_dma_buf).
+    Once all users have finished accessing and have unmapped this buffer, the
+    exporter could potentially move the buffer to the stricter backing-storage,
+    and then allow further {map,unmap}_dma_buf operations from any buffer-user
+    from the migrated backing-storage.
+
+   If the exporter cannot fulfil the backing-storage constraints of the new
+   buffer-user device as requested, dma_buf_attach() would return an error to
+   denote non-compatibility of the new buffer-sharing request with the current
+   buffer.
+
+   If the exporter chooses not to allow an attach() operation once a
+   map_dma_buf() API has been called, it simply returns an error.
+
+Kernel cpu access to a dma-buf buffer object
+--------------------------------------------
+
+The motivation to allow cpu access from the kernel to a dma-buf object from the
+importers side are:
+- fallback operations, e.g. if the devices is connected to a usb bus and the
+  kernel needs to shuffle the data around first before sending it away.
+- full transparency for existing users on the importer side, i.e. userspace
+  should not notice the difference between a normal object from that subsystem
+  and an imported one backed by a dma-buf. This is really important for drm
+  opengl drivers that expect to still use all the existing upload/download
+  paths.
+
+Access to a dma_buf from the kernel context involves three steps:
+
+1. Prepare access, which invalidate any necessary caches and make the object
+   available for cpu access.
+2. Access the object page-by-page with the dma_buf map apis
+3. Finish access, which will flush any necessary cpu caches and free reserved
+   resources.
+
+1. Prepare access
+
+   Before an importer can access a dma_buf object with the cpu from the kernel
+   context, it needs to notify the exporter of the access that is about to
+   happen.
+
+   Interface:
+      int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
+				   size_t start, size_t len,
+				   enum dma_data_direction direction)
+
+   This allows the exporter to ensure that the memory is actually available for
+   cpu access - the exporter might need to allocate or swap-in and pin the
+   backing storage. The exporter also needs to ensure that cpu access is
+   coherent for the given range and access direction. The range and access
+   direction can be used by the exporter to optimize the cache flushing, i.e.
+   access outside of the range or with a different direction (read instead of
+   write) might return stale or even bogus data (e.g. when the exporter needs to
+   copy the data to temporary storage).
+
+   This step might fail, e.g. in oom conditions.
+
+2. Accessing the buffer
+
+   To support dma_buf objects residing in highmem cpu access is page-based using
+   an api similar to kmap. Accessing a dma_buf is done in aligned chunks of
+   PAGE_SIZE size. Before accessing a chunk it needs to be mapped, which returns
+   a pointer in kernel virtual address space. Afterwards the chunk needs to be
+   unmapped again. There is no limit on how often a given chunk can be mapped
+   and unmapped, i.e. the importer does not need to call begin_cpu_access again
+   before mapping the same chunk again.
+
+   Interfaces:
+      void *dma_buf_kmap(struct dma_buf *, unsigned long);
+      void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
+
+   There are also atomic variants of these interfaces. Like for kmap they
+   facilitate non-blocking fast-paths. Neither the importer nor the exporter (in
+   the callback) is allowed to block when using these.
+
+   Interfaces:
+      void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
+      void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
+
+   For importers all the restrictions of using kmap apply, like the limited
+   supply of kmap_atomic slots. Hence an importer shall only hold onto at most 2
+   atomic dma_buf kmaps at the same time (in any given process context).
+
+   dma_buf kmap calls outside of the range specified in begin_cpu_access are
+   undefined. If the range is not PAGE_SIZE aligned, kmap needs to succeed on
+   the partial chunks at the beginning and end but may return stale or bogus
+   data outside of the range (in these partial chunks).
+
+   Note that these calls need to always succeed. The exporter needs to complete
+   any preparations that might fail in begin_cpu_access.
+
+   For some cases the overhead of kmap can be too high, a vmap interface
+   is introduced. This interface should be used very carefully, as vmalloc
+   space is a limited resources on many architectures.
+
+   Interfaces:
+      void *dma_buf_vmap(struct dma_buf *dmabuf)
+      void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
+
+   The vmap call can fail if there is no vmap support in the exporter, or if it
+   runs out of vmalloc space. Fallback to kmap should be implemented. Note that
+   the dma-buf layer keeps a reference count for all vmap access and calls down
+   into the exporter's vmap function only when no vmapping exists, and only
+   unmaps it once. Protection against concurrent vmap/vunmap calls is provided
+   by taking the dma_buf->lock mutex.
+
+3. Finish access
+
+   When the importer is done accessing the range specified in begin_cpu_access,
+   it needs to announce this to the exporter (to facilitate cache flushing and
+   unpinning of any pinned resources). The result of any dma_buf kmap calls
+   after end_cpu_access is undefined.
+
+   Interface:
+      void dma_buf_end_cpu_access(struct dma_buf *dma_buf,
+				  size_t start, size_t len,
+				  enum dma_data_direction dir);
+
+
+Direct Userspace Access/mmap Support
+------------------------------------
+
+Being able to mmap an export dma-buf buffer object has 2 main use-cases:
+- CPU fallback processing in a pipeline and
+- supporting existing mmap interfaces in importers.
+
+1. CPU fallback processing in a pipeline
+
+   In many processing pipelines it is sometimes required that the cpu can access
+   the data in a dma-buf (e.g. for thumbnail creation, snapshots, ...). To avoid
+   the need to handle this specially in userspace frameworks for buffer sharing
+   it's ideal if the dma_buf fd itself can be used to access the backing storage
+   from userspace using mmap.
+
+   Furthermore Android's ION framework already supports this (and is otherwise
+   rather similar to dma-buf from a userspace consumer side with using fds as
+   handles, too). So it's beneficial to support this in a similar fashion on
+   dma-buf to have a good transition path for existing Android userspace.
+
+   No special interfaces, userspace simply calls mmap on the dma-buf fd.
+
+2. Supporting existing mmap interfaces in exporters
+
+   Similar to the motivation for kernel cpu access it is again important that
+   the userspace code of a given importing subsystem can use the same interfaces
+   with a imported dma-buf buffer object as with a native buffer object. This is
+   especially important for drm where the userspace part of contemporary OpenGL,
+   X, and other drivers is huge, and reworking them to use a different way to
+   mmap a buffer rather invasive.
+
+   The assumption in the current dma-buf interfaces is that redirecting the
+   initial mmap is all that's needed. A survey of some of the existing
+   subsystems shows that no driver seems to do any nefarious thing like syncing
+   up with outstanding asynchronous processing on the device or allocating
+   special resources at fault time. So hopefully this is good enough, since
+   adding interfaces to intercept pagefaults and allow pte shootdowns would
+   increase the complexity quite a bit.
+
+   Interface:
+      int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
+		       unsigned long);
+
+   If the importing subsystem simply provides a special-purpose mmap call to set
+   up a mapping in userspace, calling do_mmap with dma_buf->file will equally
+   achieve that for a dma-buf object.
+
+3. Implementation notes for exporters
+
+   Because dma-buf buffers have invariant size over their lifetime, the dma-buf
+   core checks whether a vma is too large and rejects such mappings. The
+   exporter hence does not need to duplicate this check.
+
+   Because existing importing subsystems might presume coherent mappings for
+   userspace, the exporter needs to set up a coherent mapping. If that's not
+   possible, it needs to fake coherency by manually shooting down ptes when
+   leaving the cpu domain and flushing caches at fault time. Note that all the
+   dma_buf files share the same anon inode, hence the exporter needs to replace
+   the dma_buf file stored in vma->vm_file with it's own if pte shootdown is
+   required. This is because the kernel uses the underlying inode's address_space
+   for vma tracking (and hence pte tracking at shootdown time with
+   unmap_mapping_range).
+
+   If the above shootdown dance turns out to be too expensive in certain
+   scenarios, we can extend dma-buf with a more explicit cache tracking scheme
+   for userspace mappings. But the current assumption is that using mmap is
+   always a slower path, so some inefficiencies should be acceptable.
+
+   Exporters that shoot down mappings (for any reasons) shall not do any
+   synchronization at fault time with outstanding device operations.
+   Synchronization is an orthogonal issue to sharing the backing storage of a
+   buffer and hence should not be handled by dma-buf itself. This is explicitly
+   mentioned here because many people seem to want something like this, but if
+   different exporters handle this differently, buffer sharing can fail in
+   interesting ways depending upong the exporter (if userspace starts depending
+   upon this implicit synchronization).
+
+Other Interfaces Exposed to Userspace on the dma-buf FD
+------------------------------------------------------
+
+- Since kernel 3.12 the dma-buf FD supports the llseek system call, but only
+  with offset=0 and whence=SEEK_END|SEEK_SET. SEEK_SET is supported to allow
+  the usual size discover pattern size = SEEK_END(0); SEEK_SET(0). Every other
+  llseek operation will report -EINVAL.
+
+  If llseek on dma-buf FDs isn't support the kernel will report -ESPIPE for all
+  cases. Userspace can use this to detect support for discovering the dma-buf
+  size using llseek.
+
+Miscellaneous notes
+-------------------
+
+- Any exporters or users of the dma-buf buffer sharing framework must have
+  a 'select DMA_SHARED_BUFFER' in their respective Kconfigs.
+
+- In order to avoid fd leaks on exec, the FD_CLOEXEC flag must be set
+  on the file descriptor.  This is not just a resource leak, but a
+  potential security hole.  It could give the newly exec'd application
+  access to buffers, via the leaked fd, to which it should otherwise
+  not be permitted access.
+
+  The problem with doing this via a separate fcntl() call, versus doing it
+  atomically when the fd is created, is that this is inherently racy in a
+  multi-threaded app[3].  The issue is made worse when it is library code
+  opening/creating the file descriptor, as the application may not even be
+  aware of the fd's.
+
+  To avoid this problem, userspace must have a way to request O_CLOEXEC
+  flag be set when the dma-buf fd is created.  So any API provided by
+  the exporting driver to create a dmabuf fd must provide a way to let
+  userspace control setting of O_CLOEXEC flag passed in to dma_buf_fd().
+
+- If an exporter needs to manually flush caches and hence needs to fake
+  coherency for mmap support, it needs to be able to zap all the ptes pointing
+  at the backing storage. Now linux mm needs a struct address_space associated
+  with the struct file stored in vma->vm_file to do that with the function
+  unmap_mapping_range. But the dma_buf framework only backs every dma_buf fd
+  with the anon_file struct file, i.e. all dma_bufs share the same file.
+
+  Hence exporters need to setup their own file (and address_space) association
+  by setting vma->vm_file and adjusting vma->vm_pgoff in the dma_buf mmap
+  callback. In the specific case of a gem driver the exporter could use the
+  shmem file already provided by gem (and set vm_pgoff = 0). Exporters can then
+  zap ptes by unmapping the corresponding range of the struct address_space
+  associated with their own file.
+
+References:
+[1] struct dma_buf_ops in include/linux/dma-buf.h
+[2] All interfaces mentioned above defined in include/linux/dma-buf.h
+[3] https://lwn.net/Articles/236486/
diff --git a/Documentation/dma/dmaengine.txt b/Documentation/dma/dmaengine.txt
new file mode 100644
index 0000000..879b6e3
--- /dev/null
+++ b/Documentation/dma/dmaengine.txt
@@ -0,0 +1,198 @@
+			DMA Engine API Guide
+			====================
+
+		 Vinod Koul <vinod dot koul at intel.com>
+
+NOTE: For DMA Engine usage in async_tx please see:
+	Documentation/crypto/async-tx-api.txt
+
+
+Below is a guide to device driver writers on how to use the Slave-DMA API of the
+DMA Engine. This is applicable only for slave DMA usage only.
+
+The slave DMA usage consists of following steps:
+1. Allocate a DMA slave channel
+2. Set slave and controller specific parameters
+3. Get a descriptor for transaction
+4. Submit the transaction
+5. Issue pending requests and wait for callback notification
+
+1. Allocate a DMA slave channel
+
+   Channel allocation is slightly different in the slave DMA context,
+   client drivers typically need a channel from a particular DMA
+   controller only and even in some cases a specific channel is desired.
+   To request a channel dma_request_channel() API is used.
+
+   Interface:
+	struct dma_chan *dma_request_channel(dma_cap_mask_t mask,
+			dma_filter_fn filter_fn,
+			void *filter_param);
+   where dma_filter_fn is defined as:
+	typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
+
+   The 'filter_fn' parameter is optional, but highly recommended for
+   slave and cyclic channels as they typically need to obtain a specific
+   DMA channel.
+
+   When the optional 'filter_fn' parameter is NULL, dma_request_channel()
+   simply returns the first channel that satisfies the capability mask.
+
+   Otherwise, the 'filter_fn' routine will be called once for each free
+   channel which has a capability in 'mask'.  'filter_fn' is expected to
+   return 'true' when the desired DMA channel is found.
+
+   A channel allocated via this interface is exclusive to the caller,
+   until dma_release_channel() is called.
+
+2. Set slave and controller specific parameters
+
+   Next step is always to pass some specific information to the DMA
+   driver.  Most of the generic information which a slave DMA can use
+   is in struct dma_slave_config.  This allows the clients to specify
+   DMA direction, DMA addresses, bus widths, DMA burst lengths etc
+   for the peripheral.
+
+   If some DMA controllers have more parameters to be sent then they
+   should try to embed struct dma_slave_config in their controller
+   specific structure. That gives flexibility to client to pass more
+   parameters, if required.
+
+   Interface:
+	int dmaengine_slave_config(struct dma_chan *chan,
+				  struct dma_slave_config *config)
+
+   Please see the dma_slave_config structure definition in dmaengine.h
+   for a detailed explanation of the struct members.  Please note
+   that the 'direction' member will be going away as it duplicates the
+   direction given in the prepare call.
+
+3. Get a descriptor for transaction
+
+   For slave usage the various modes of slave transfers supported by the
+   DMA-engine are:
+
+   slave_sg	- DMA a list of scatter gather buffers from/to a peripheral
+   dma_cyclic	- Perform a cyclic DMA operation from/to a peripheral till the
+		  operation is explicitly stopped.
+   interleaved_dma - This is common to Slave as well as M2M clients. For slave
+		 address of devices' fifo could be already known to the driver.
+		 Various types of operations could be expressed by setting
+		 appropriate values to the 'dma_interleaved_template' members.
+
+   A non-NULL return of this transfer API represents a "descriptor" for
+   the given transaction.
+
+   Interface:
+	struct dma_async_tx_descriptor *(*chan->device->device_prep_slave_sg)(
+		struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned long flags);
+
+	struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_cyclic)(
+		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+		size_t period_len, enum dma_data_direction direction);
+
+	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
+		struct dma_chan *chan, struct dma_interleaved_template *xt,
+		unsigned long flags);
+
+   The peripheral driver is expected to have mapped the scatterlist for
+   the DMA operation prior to calling device_prep_slave_sg, and must
+   keep the scatterlist mapped until the DMA operation has completed.
+   The scatterlist must be mapped using the DMA struct device.  So,
+   normal setup should look like this:
+
+	nr_sg = dma_map_sg(chan->device->dev, sgl, sg_len);
+	if (nr_sg == 0)
+		/* error */
+
+	desc = chan->device->device_prep_slave_sg(chan, sgl, nr_sg,
+			direction, flags);
+
+   Once a descriptor has been obtained, the callback information can be
+   added and the descriptor must then be submitted.  Some DMA engine
+   drivers may hold a spinlock between a successful preparation and
+   submission so it is important that these two operations are closely
+   paired.
+
+   Note:
+	Although the async_tx API specifies that completion callback
+	routines cannot submit any new operations, this is not the
+	case for slave/cyclic DMA.
+
+	For slave DMA, the subsequent transaction may not be available
+	for submission prior to callback function being invoked, so
+	slave DMA callbacks are permitted to prepare and submit a new
+	transaction.
+
+	For cyclic DMA, a callback function may wish to terminate the
+	DMA via dmaengine_terminate_all().
+
+	Therefore, it is important that DMA engine drivers drop any
+	locks before calling the callback function which may cause a
+	deadlock.
+
+	Note that callbacks will always be invoked from the DMA
+	engines tasklet, never from interrupt context.
+
+4. Submit the transaction
+
+   Once the descriptor has been prepared and the callback information
+   added, it must be placed on the DMA engine drivers pending queue.
+
+   Interface:
+	dma_cookie_t dmaengine_submit(struct dma_async_tx_descriptor *desc)
+
+   This returns a cookie can be used to check the progress of DMA engine
+   activity via other DMA engine calls not covered in this document.
+
+   dmaengine_submit() will not start the DMA operation, it merely adds
+   it to the pending queue.  For this, see step 5, dma_async_issue_pending.
+
+5. Issue pending DMA requests and wait for callback notification
+
+   The transactions in the pending queue can be activated by calling the
+   issue_pending API. If channel is idle then the first transaction in
+   queue is started and subsequent ones queued up.
+
+   On completion of each DMA operation, the next in queue is started and
+   a tasklet triggered. The tasklet will then call the client driver
+   completion callback routine for notification, if set.
+
+   Interface:
+	void dma_async_issue_pending(struct dma_chan *chan);
+
+Further APIs:
+
+1. int dmaengine_terminate_all(struct dma_chan *chan)
+
+   This causes all activity for the DMA channel to be stopped, and may
+   discard data in the DMA FIFO which hasn't been fully transferred.
+   No callback functions will be called for any incomplete transfers.
+
+2. int dmaengine_pause(struct dma_chan *chan)
+
+   This pauses activity on the DMA channel without data loss.
+
+3. int dmaengine_resume(struct dma_chan *chan)
+
+   Resume a previously paused DMA channel.  It is invalid to resume a
+   channel which is not currently paused.
+
+4. enum dma_status dma_async_is_tx_complete(struct dma_chan *chan,
+        dma_cookie_t cookie, dma_cookie_t *last, dma_cookie_t *used)
+
+   This can be used to check the status of the channel.  Please see
+   the documentation in include/linux/dmaengine.h for a more complete
+   description of this API.
+
+   This can be used in conjunction with dma_async_is_complete() and
+   the cookie returned from 'descriptor->submit()' to check for
+   completion of a specific DMA transaction.
+
+   Note:
+	Not all DMA engine drivers can return reliable information for
+	a running DMA channel.  It is recommended that DMA engine users
+	pause or stop (via dmaengine_terminate_all) the channel before
+	using this API.
diff --git a/Documentation/dma/dmatest.txt b/Documentation/dma/dmatest.txt
new file mode 100644
index 0000000..dd77a81
--- /dev/null
+++ b/Documentation/dma/dmatest.txt
@@ -0,0 +1,92 @@
+				DMA Test Guide
+				==============
+
+		Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+
+This small document introduces how to test DMA drivers using dmatest module.
+
+	Part 1 - How to build the test module
+
+The menuconfig contains an option that could be found by following path:
+	Device Drivers -> DMA Engine support -> DMA Test client
+
+In the configuration file the option called CONFIG_DMATEST. The dmatest could
+be built as module or inside kernel. Let's consider those cases.
+
+	Part 2 - When dmatest is built as a module...
+
+Example of usage:
+	% modprobe dmatest channel=dma0chan0 timeout=2000 iterations=1 run=1
+
+...or:
+	% modprobe dmatest
+	% echo dma0chan0 > /sys/module/dmatest/parameters/channel
+	% echo 2000 > /sys/module/dmatest/parameters/timeout
+	% echo 1 > /sys/module/dmatest/parameters/iterations
+	% echo 1 > /sys/module/dmatest/parameters/run
+
+...or on the kernel command line:
+
+	dmatest.channel=dma0chan0 dmatest.timeout=2000 dmatest.iterations=1 dmatest.run=1
+
+Hint: available channel list could be extracted by running the following
+command:
+	% ls -1 /sys/class/dma/
+
+Once started a message like "dmatest: Started 1 threads using dma0chan0" is
+emitted.  After that only test failure messages are reported until the test
+stops.
+
+Note that running a new test will not stop any in progress test.
+
+The following command returns the state of the test.
+	% cat /sys/module/dmatest/parameters/run
+
+To wait for test completion userpace can poll 'run' until it is false, or use
+the wait parameter.  Specifying 'wait=1' when loading the module causes module
+initialization to pause until a test run has completed, while reading
+/sys/module/dmatest/parameters/wait waits for any running test to complete
+before returning.  For example, the following scripts wait for 42 tests
+to complete before exiting.  Note that if 'iterations' is set to 'infinite' then
+waiting is disabled.
+
+Example:
+	% modprobe dmatest run=1 iterations=42 wait=1
+	% modprobe -r dmatest
+...or:
+	% modprobe dmatest run=1 iterations=42
+	% cat /sys/module/dmatest/parameters/wait
+	% modprobe -r dmatest
+
+	Part 3 - When built-in in the kernel...
+
+The module parameters that is supplied to the kernel command line will be used
+for the first performed test. After user gets a control, the test could be
+re-run with the same or different parameters. For the details see the above
+section "Part 2 - When dmatest is built as a module..."
+
+In both cases the module parameters are used as the actual values for the test
+case. You always could check them at run-time by running
+	% grep -H . /sys/module/dmatest/parameters/*
+
+	Part 4 - Gathering the test results
+
+Test results are printed to the kernel log buffer with the format:
+
+"dmatest: result <channel>: <test id>: '<error msg>' with src_off=<val> dst_off=<val> len=<val> (<err code>)"
+
+Example of output:
+	% dmesg | tail -n 1
+	dmatest: result dma0chan0-copy0: #1: No errors with src_off=0x7bf dst_off=0x8ad len=0x3fea (0)
+
+The message format is unified across the different types of errors. A number in
+the parens represents additional information, e.g. error code, error counter,
+or status.  A test thread also emits a summary line at completion listing the
+number of tests executed, number that failed, and a result code.
+
+Example:
+	% dmesg | tail -n 1
+	dmatest: dma0chan0-copy0: summary 1 test, 0 failures 1000 iops 100000 KB/s (0)
+
+The details of a data miscompare error are also emitted, but do not follow the
+above format.
diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
deleted file mode 100644
index 879b6e3..0000000
--- a/Documentation/dmaengine.txt
+++ /dev/null
@@ -1,198 +0,0 @@
-			DMA Engine API Guide
-			====================
-
-		 Vinod Koul <vinod dot koul at intel.com>
-
-NOTE: For DMA Engine usage in async_tx please see:
-	Documentation/crypto/async-tx-api.txt
-
-
-Below is a guide to device driver writers on how to use the Slave-DMA API of the
-DMA Engine. This is applicable only for slave DMA usage only.
-
-The slave DMA usage consists of following steps:
-1. Allocate a DMA slave channel
-2. Set slave and controller specific parameters
-3. Get a descriptor for transaction
-4. Submit the transaction
-5. Issue pending requests and wait for callback notification
-
-1. Allocate a DMA slave channel
-
-   Channel allocation is slightly different in the slave DMA context,
-   client drivers typically need a channel from a particular DMA
-   controller only and even in some cases a specific channel is desired.
-   To request a channel dma_request_channel() API is used.
-
-   Interface:
-	struct dma_chan *dma_request_channel(dma_cap_mask_t mask,
-			dma_filter_fn filter_fn,
-			void *filter_param);
-   where dma_filter_fn is defined as:
-	typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
-
-   The 'filter_fn' parameter is optional, but highly recommended for
-   slave and cyclic channels as they typically need to obtain a specific
-   DMA channel.
-
-   When the optional 'filter_fn' parameter is NULL, dma_request_channel()
-   simply returns the first channel that satisfies the capability mask.
-
-   Otherwise, the 'filter_fn' routine will be called once for each free
-   channel which has a capability in 'mask'.  'filter_fn' is expected to
-   return 'true' when the desired DMA channel is found.
-
-   A channel allocated via this interface is exclusive to the caller,
-   until dma_release_channel() is called.
-
-2. Set slave and controller specific parameters
-
-   Next step is always to pass some specific information to the DMA
-   driver.  Most of the generic information which a slave DMA can use
-   is in struct dma_slave_config.  This allows the clients to specify
-   DMA direction, DMA addresses, bus widths, DMA burst lengths etc
-   for the peripheral.
-
-   If some DMA controllers have more parameters to be sent then they
-   should try to embed struct dma_slave_config in their controller
-   specific structure. That gives flexibility to client to pass more
-   parameters, if required.
-
-   Interface:
-	int dmaengine_slave_config(struct dma_chan *chan,
-				  struct dma_slave_config *config)
-
-   Please see the dma_slave_config structure definition in dmaengine.h
-   for a detailed explanation of the struct members.  Please note
-   that the 'direction' member will be going away as it duplicates the
-   direction given in the prepare call.
-
-3. Get a descriptor for transaction
-
-   For slave usage the various modes of slave transfers supported by the
-   DMA-engine are:
-
-   slave_sg	- DMA a list of scatter gather buffers from/to a peripheral
-   dma_cyclic	- Perform a cyclic DMA operation from/to a peripheral till the
-		  operation is explicitly stopped.
-   interleaved_dma - This is common to Slave as well as M2M clients. For slave
-		 address of devices' fifo could be already known to the driver.
-		 Various types of operations could be expressed by setting
-		 appropriate values to the 'dma_interleaved_template' members.
-
-   A non-NULL return of this transfer API represents a "descriptor" for
-   the given transaction.
-
-   Interface:
-	struct dma_async_tx_descriptor *(*chan->device->device_prep_slave_sg)(
-		struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
-		unsigned long flags);
-
-	struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_cyclic)(
-		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-		size_t period_len, enum dma_data_direction direction);
-
-	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
-		struct dma_chan *chan, struct dma_interleaved_template *xt,
-		unsigned long flags);
-
-   The peripheral driver is expected to have mapped the scatterlist for
-   the DMA operation prior to calling device_prep_slave_sg, and must
-   keep the scatterlist mapped until the DMA operation has completed.
-   The scatterlist must be mapped using the DMA struct device.  So,
-   normal setup should look like this:
-
-	nr_sg = dma_map_sg(chan->device->dev, sgl, sg_len);
-	if (nr_sg == 0)
-		/* error */
-
-	desc = chan->device->device_prep_slave_sg(chan, sgl, nr_sg,
-			direction, flags);
-
-   Once a descriptor has been obtained, the callback information can be
-   added and the descriptor must then be submitted.  Some DMA engine
-   drivers may hold a spinlock between a successful preparation and
-   submission so it is important that these two operations are closely
-   paired.
-
-   Note:
-	Although the async_tx API specifies that completion callback
-	routines cannot submit any new operations, this is not the
-	case for slave/cyclic DMA.
-
-	For slave DMA, the subsequent transaction may not be available
-	for submission prior to callback function being invoked, so
-	slave DMA callbacks are permitted to prepare and submit a new
-	transaction.
-
-	For cyclic DMA, a callback function may wish to terminate the
-	DMA via dmaengine_terminate_all().
-
-	Therefore, it is important that DMA engine drivers drop any
-	locks before calling the callback function which may cause a
-	deadlock.
-
-	Note that callbacks will always be invoked from the DMA
-	engines tasklet, never from interrupt context.
-
-4. Submit the transaction
-
-   Once the descriptor has been prepared and the callback information
-   added, it must be placed on the DMA engine drivers pending queue.
-
-   Interface:
-	dma_cookie_t dmaengine_submit(struct dma_async_tx_descriptor *desc)
-
-   This returns a cookie can be used to check the progress of DMA engine
-   activity via other DMA engine calls not covered in this document.
-
-   dmaengine_submit() will not start the DMA operation, it merely adds
-   it to the pending queue.  For this, see step 5, dma_async_issue_pending.
-
-5. Issue pending DMA requests and wait for callback notification
-
-   The transactions in the pending queue can be activated by calling the
-   issue_pending API. If channel is idle then the first transaction in
-   queue is started and subsequent ones queued up.
-
-   On completion of each DMA operation, the next in queue is started and
-   a tasklet triggered. The tasklet will then call the client driver
-   completion callback routine for notification, if set.
-
-   Interface:
-	void dma_async_issue_pending(struct dma_chan *chan);
-
-Further APIs:
-
-1. int dmaengine_terminate_all(struct dma_chan *chan)
-
-   This causes all activity for the DMA channel to be stopped, and may
-   discard data in the DMA FIFO which hasn't been fully transferred.
-   No callback functions will be called for any incomplete transfers.
-
-2. int dmaengine_pause(struct dma_chan *chan)
-
-   This pauses activity on the DMA channel without data loss.
-
-3. int dmaengine_resume(struct dma_chan *chan)
-
-   Resume a previously paused DMA channel.  It is invalid to resume a
-   channel which is not currently paused.
-
-4. enum dma_status dma_async_is_tx_complete(struct dma_chan *chan,
-        dma_cookie_t cookie, dma_cookie_t *last, dma_cookie_t *used)
-
-   This can be used to check the status of the channel.  Please see
-   the documentation in include/linux/dmaengine.h for a more complete
-   description of this API.
-
-   This can be used in conjunction with dma_async_is_complete() and
-   the cookie returned from 'descriptor->submit()' to check for
-   completion of a specific DMA transaction.
-
-   Note:
-	Not all DMA engine drivers can return reliable information for
-	a running DMA channel.  It is recommended that DMA engine users
-	pause or stop (via dmaengine_terminate_all) the channel before
-	using this API.
diff --git a/Documentation/dmatest.txt b/Documentation/dmatest.txt
deleted file mode 100644
index dd77a81..0000000
--- a/Documentation/dmatest.txt
+++ /dev/null
@@ -1,92 +0,0 @@
-				DMA Test Guide
-				==============
-
-		Andy Shevchenko <andriy.shevchenko@linux.intel.com>
-
-This small document introduces how to test DMA drivers using dmatest module.
-
-	Part 1 - How to build the test module
-
-The menuconfig contains an option that could be found by following path:
-	Device Drivers -> DMA Engine support -> DMA Test client
-
-In the configuration file the option called CONFIG_DMATEST. The dmatest could
-be built as module or inside kernel. Let's consider those cases.
-
-	Part 2 - When dmatest is built as a module...
-
-Example of usage:
-	% modprobe dmatest channel=dma0chan0 timeout=2000 iterations=1 run=1
-
-...or:
-	% modprobe dmatest
-	% echo dma0chan0 > /sys/module/dmatest/parameters/channel
-	% echo 2000 > /sys/module/dmatest/parameters/timeout
-	% echo 1 > /sys/module/dmatest/parameters/iterations
-	% echo 1 > /sys/module/dmatest/parameters/run
-
-...or on the kernel command line:
-
-	dmatest.channel=dma0chan0 dmatest.timeout=2000 dmatest.iterations=1 dmatest.run=1
-
-Hint: available channel list could be extracted by running the following
-command:
-	% ls -1 /sys/class/dma/
-
-Once started a message like "dmatest: Started 1 threads using dma0chan0" is
-emitted.  After that only test failure messages are reported until the test
-stops.
-
-Note that running a new test will not stop any in progress test.
-
-The following command returns the state of the test.
-	% cat /sys/module/dmatest/parameters/run
-
-To wait for test completion userpace can poll 'run' until it is false, or use
-the wait parameter.  Specifying 'wait=1' when loading the module causes module
-initialization to pause until a test run has completed, while reading
-/sys/module/dmatest/parameters/wait waits for any running test to complete
-before returning.  For example, the following scripts wait for 42 tests
-to complete before exiting.  Note that if 'iterations' is set to 'infinite' then
-waiting is disabled.
-
-Example:
-	% modprobe dmatest run=1 iterations=42 wait=1
-	% modprobe -r dmatest
-...or:
-	% modprobe dmatest run=1 iterations=42
-	% cat /sys/module/dmatest/parameters/wait
-	% modprobe -r dmatest
-
-	Part 3 - When built-in in the kernel...
-
-The module parameters that is supplied to the kernel command line will be used
-for the first performed test. After user gets a control, the test could be
-re-run with the same or different parameters. For the details see the above
-section "Part 2 - When dmatest is built as a module..."
-
-In both cases the module parameters are used as the actual values for the test
-case. You always could check them at run-time by running
-	% grep -H . /sys/module/dmatest/parameters/*
-
-	Part 4 - Gathering the test results
-
-Test results are printed to the kernel log buffer with the format:
-
-"dmatest: result <channel>: <test id>: '<error msg>' with src_off=<val> dst_off=<val> len=<val> (<err code>)"
-
-Example of output:
-	% dmesg | tail -n 1
-	dmatest: result dma0chan0-copy0: #1: No errors with src_off=0x7bf dst_off=0x8ad len=0x3fea (0)
-
-The message format is unified across the different types of errors. A number in
-the parens represents additional information, e.g. error code, error counter,
-or status.  A test thread also emits a summary line at completion listing the
-number of tests executed, number that failed, and a result code.
-
-Example:
-	% dmesg | tail -n 1
-	dmatest: dma0chan0-copy0: summary 1 test, 0 failures 1000 iops 100000 KB/s (0)
-
-The details of a data miscompare error are also emitted, but do not follow the
-above format.
-- 
1.7.9.5



