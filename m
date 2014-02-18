Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbaBRNiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:38:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaBRNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:38:48 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-8b-53036266330c
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
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
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v3 0/6] reserved-memory regions/CMA in devicetree, again
Date: Tue, 18 Feb 2014 14:37:55 +0100
Message-id: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAAzVRW0hTYQDuP7cdl6PT0jpqiCwLLPJSQT9kElrwYz2UYoQvOd1hSpuOTZf6
	oDI2y+UNJZxlzpXDGupqWV4qUlsX8lJT0SCtRMvbzIVdpOZKJ719V76Hj8aFJUQgnZGZzSkz
	xTIRxSf6PFPMfmkqnhjp+OwDV6te8KBLo8Oh0T5IwgqniYTd7g4AnWWXCdjZ+hXAAY2TB9tL
	DDz4fWQSg7apURKaihsJONxVR8EW+wQP3p3rwaB5zIHBhpdaErprguHrsWUKVta0EFD3xM6D
	q+02As73FBPQalggoKXLDY4FoOb6ZoD+/K4CaKG6EqDh8jIMdV6b4KFSp5ZENksJhcZHH1Po
	fmMheu+ZwtHIKw2JWt3zGKpYjUTlbRaAlm3B6N6NpNNMMj9awsky1JwyIiaFn168ZCUVl0Jz
	+0z9ZBHwBOmBD80yh1iP1oht4O3s2w9WSg/4tJC5CdgxzRtsg+gwdnH2EbmeopgoVr+op9ax
	H2MC7HI9sR7CmRqKvfVgyWtsYxCrvzLtLRDMbrZz6Jd3QrCmux42rRXotbkQtq4quhJsbgCb
	LMCfU6QpVKlS+YFwlViuysmUhqdlyW3Ae9CXoA5gKYK9gKGByFfg2oUlCkmxWpUn7wUsjYv8
	BGHJeKJQIBHn5XPKrPPKHBmn6gVBNCHaIejRHTkjZKTibO4Cxyk45X8Xo30Ci4AxTOLfdeIp
	LEwwaMMG+/tyY2MHhrrh7WeiT/E7W1x3vslEREfz3+vVFyNcIeqDs+N7Vk7GzLgZtbmi8aji
	6tYyo/W4NYY2OnwbSj/ymVBHQNxSwmSttaD6MEzRFsw8T8qYJpviaufsoyv7zuYbXJJ43amf
	5h9tfoq4c7Nb3okIVbo4ai+uVIn/AfYDWDOcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

This is yet another update of the second attempt to add basic support
for dynamic allocation of memory reserved regions defined in device
tree.

This time I've tried to address all the issues reported by Grant Likely.
The side-effect of it is a complete rewrite of memory reservation code,
which results in added support for for multiple tuples in 'reg' property
and complete support for 'size', 'align' and 'alloc-ranges' properties.

The initial code for this feature were posted here [1], merged as commit
9d8eab7af79cb4ce2de5de39f82c455b1f796963 ("drivers: of: add
initialization code for dma reserved memory") and later reverted by
commit 1931ee143b0ab72924944bc06e363d837ba05063. For more information,
see [2]. Finally a new bindings has been proposed [3] and Josh
Cartwright a few days ago prepared some code which implements those
bindings [4]. This finally pushed me again to find some time to finish
this task and review the code. Josh agreed to give me the ownership of
this series to continue preparing them for mainline inclusion.

For more information please refer to the changlelog below.

[1]: http://lkml.kernel.org/g/1377527959-5080-1-git-send-email-m.szyprowski@samsung.com
[2]: http://lkml.kernel.org/g/1381476448-14548-1-git-send-email-m.szyprowski@samsung.com
[3]: http://lkml.kernel.org/g/20131030134702.19B57C402A0@trevor.secretlab.ca
[4]: http://thread.gmane.org/gmane.linux.documentation/19579

Changelog:

v3:
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

Josh Cartwright (2):
  drivers: of: implement reserved-memory handling for dma
  drivers: of: implement reserved-memory handling for cma

Marek Szyprowski (3):
  base: dma-contiguous: add dma_contiguous_init_reserved_mem() function
  drivers: of: add initialization code for reserved memory
  ARM: init: add support for reserved memory defined by device tree

 .../bindings/reserved-memory/reserved-memory.txt   |  138 +++++++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/mm/init.c                                 |    3 +
 drivers/base/dma-contiguous.c                      |   70 ++--
 drivers/of/Kconfig                                 |   19 +
 drivers/of/Makefile                                |    3 +
 drivers/of/fdt.c                                   |    2 +
 drivers/of/of_reserved_mem.c                       |  390 ++++++++++++++++++++
 drivers/of/of_reserved_mem_cma.c                   |   68 ++++
 drivers/of/of_reserved_mem_dma.c                   |   65 ++++
 drivers/of/platform.c                              |    7 +
 include/asm-generic/vmlinux.lds.h                  |   11 +
 include/linux/dma-contiguous.h                     |    7 +
 include/linux/of_reserved_mem.h                    |   65 ++++
 14 files changed, 827 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
 create mode 100644 drivers/of/of_reserved_mem.c
 create mode 100644 drivers/of/of_reserved_mem_cma.c
 create mode 100644 drivers/of/of_reserved_mem_dma.c
 create mode 100644 include/linux/of_reserved_mem.h

-- 
1.7.9.5

