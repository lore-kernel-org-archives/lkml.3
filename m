Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaBUM0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:26:14 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63423 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaBUM0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:10 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-7e-530745de7324
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v5 00/11] reserved-memory regions/CMA in devicetree, again
Date: Fri, 21 Feb 2014 13:25:16 +0100
Message-id: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRbUhTYQCFe+/ul6vBbVlcREQGBYZORcmXEBEqew0NYRBYga55UcPp2FXL
	/mimolPnmJBipi41Ym4ay3AuE7XlJLESTaPaStTUub6cUdi0mv57DjyH8+PQAvGWIIjOzS/k
	1PnyPAkpxCd3HG8iXGcoWdSTZ3FwWz9Owe/llQL47X4dgO32lwRs8BgIOOKzAuipr8bhYO9X
	AKfKPRQcqGmm4ObsAgYti3MENFR14XDG1kpCs91JwYdroxjsnp/GYIejgoC+phD4Yt5LQpO9
	k4K6JjMOK5/aKbg9YMGhe7QKh33N6zg02nwArv2YwBODkanNBNCfLT1A6406gGa09RgabHFS
	qM5TQSCLsYZEH+aGSPSoqxS931kUoNmJcgL1+twYatiOQndtWoC0/UaAvJaQtIMXhfFZXF5u
	MaeOTMgU5nidN4FqKfx6T/sIXgYMEg2gaZaJZX23AzQg4D8eYV+7+kgNENJiphuw7l8DxF6o
	xdhhrwfzWyQTzWq+aEg/BzIGwHrbcL8kYD6SbPV03a50iDnHvnL9BX7GmaPslOPObkHEnGU3
	Bp3E3nIo26qP14H9HWCfERzmihQq/kq2MlrKy5V8UX62VFGgtIC9vzatoHP85BhgaCA5IFKx
	pExMyIv5EuUYYGmBJFA0GknJxKIseckNTl2QoS7K4/gxgNEBQWVAwTcu9/Npirjl4RRdxlKQ
	VGZaSZ75rH/3swVMpE+a5cc3umJCuYRSt7WWL1y5rF0Ns0VuskPPL8Q/aDx1TL2weLXt8ekT
	n2rJ847wMFdw0vAQSq2gIxqmZQpVwqXgzORbSanjTIemwGouTv+9UKKJsadwemliYc/qvWtv
	YyU4nyOPPi5Q8/J/GaUS940CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

Ok, I hope that this is the last update of the patches which add basic
support for dynamic allocation of memory reserved regions defined in
device tree.

This time I've mainly sliced the main patch into several smaller pieces
to make the changes easier to understand and fixes some minor coding
style issues.

The initial code for this feature were posted here [1], merged as commit
9d8eab7af79cb4ce2de5de39f82c455b1f796963 ("drivers: of: add
initialization code for dma reserved memory") and later reverted by
commit 1931ee143b0ab72924944bc06e363d837ba05063. For more information,
see [2]. Finally a new bindings has been proposed [3] and Josh
Cartwright a few days ago prepared some code which implements those
bindings [4]. This finally pushed me again to find some time to finish
this task and review the code. Josh agreed to give me the ownership of
this series to continue preparing them for mainline inclusion.

For more information please refer to the changlelog and links below.

[1]: http://lkml.kernel.org/g/1377527959-5080-1-git-send-email-m.szyprowski@samsung.com
[2]: http://lkml.kernel.org/g/1381476448-14548-1-git-send-email-m.szyprowski@samsung.com
[3]: http://lkml.kernel.org/g/20131030134702.19B57C402A0@trevor.secretlab.ca
[4]: http://thread.gmane.org/gmane.linux.documentation/19579

Changelog:

v5:
- sliced main patch into several smaller patches on Grant's request
- fixed coding style issues pointed by Grant
- use node->phandle value directly instead of parsing properties manually

v4: https://lkml.org/lkml/2014/2/20/150
- dynamic allocations are processed after all static reservations has been
  done
- moved code for handling static reservations to drivers/of/fdt.c
- removed node matching by string comparison, now phandle values are used
  directly
- moved code for DMA and CMA handling directly to
  drivers/base/dma-{coherent,contiguous}.c
- added checks for proper #size-cells, #address-cells, ranges properties
  in /reserved-memory node
- even more code cleanup
- added init code for ARM64 and PowerPC

v3: http://article.gmane.org/gmane.linux.documentation/20169/
- refactored memory reservation code, created common code to parse reg, size,
  align, alloc-ranges properties
- added support for multiple tuples in 'reg' property
- memory is reserved regardless of presence of the driver for its compatible
- prepared arch specific hooks for memory reservation (defaults use memblock
  calls)
- removed node matching by string during device initialization
- CMA init code: added checks for required region alignment
- more code cleanup here and there

v2: http://thread.gmane.org/gmane.linux.documentation/19870/
- removed copying of the node name
- split shared-dma-pool handling into separate files (one for CMA and one
  for dma_declare_coherent based implementations) for making the code easier
  to understand
- added support for AMBA devices, changed prototypes to use struct decice
  instead of struct platform_device
- renamed some functions to better match other names used in drivers/of/
- restructured the rest of the code a bit for better readability
- added 'reusable' property to exmaple linux,cma node in documentation
- exclusive dma (dma_coherent) is used for only handling 'shared-dma-pool'
  regions without 'reusable' property and CMA is used only for handling
  'shared-dma-pool' regions with 'reusable' property.

v1: http://thread.gmane.org/gmane.linux.documentation/19579
- initial version prepared by Josh Cartwright

Summary:

Grant Likely (1):
  of: document bindings for reserved-memory nodes

Marek Szyprowski (10):
  drivers: of: add initialization code for static reserved memory
  drivers: of: add initialization code for dynamic reserved memory
  drivers: of: add support for custom reserved memory drivers
  drivers: of: add automated assignment of reserved regions to client
    devices
  drivers: of: initialize and assign reserved memory to newly created
    devices
  drivers: dma-coherent: add initialization from device tree
  drivers: dma-contiguous: add initialization from device tree
  arm: add support for reserved memory defined by device tree
  arm64: add support for reserved memory defined by device tree
  powerpc: add support for reserved memory defined by device tree

 .../bindings/reserved-memory/reserved-memory.txt   |  138 ++++++++++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/mm/init.c                                 |    2 +
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/mm/init.c                               |    1 +
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/kernel/prom.c                         |    3 +
 drivers/base/dma-coherent.c                        |   41 +++
 drivers/base/dma-contiguous.c                      |  130 +++++++--
 drivers/of/Kconfig                                 |    6 +
 drivers/of/Makefile                                |    1 +
 drivers/of/fdt.c                                   |  134 +++++++++
 drivers/of/of_reserved_mem.c                       |  291 ++++++++++++++++++++
 drivers/of/platform.c                              |    7 +
 include/asm-generic/vmlinux.lds.h                  |   11 +
 include/linux/of_fdt.h                             |    3 +
 include/linux/of_reserved_mem.h                    |   61 ++++
 17 files changed, 810 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
 create mode 100644 drivers/of/of_reserved_mem.c
 create mode 100644 include/linux/of_reserved_mem.h

-- 
1.7.9.5

