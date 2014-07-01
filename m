Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbaGALK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 07:10:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaGALK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 07:10:26 -0400
Message-ID: <53B296FE.8050701@canonical.com>
Date: Tue, 01 Jul 2014 13:09:50 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>, gregkh@linuxfoundation.org
CC: linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/9] dma-buf: move to drivers/dma-buf
References: <20140701103432.12718.82795.stgit@patser> <20140701105708.12718.50675.stgit@patser> <53B29619.60704@broadcom.com>
In-Reply-To: <53B29619.60704@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 01-07-14 13:06, Arend van Spriel schreef:
> On 01-07-14 12:57, Maarten Lankhorst wrote:
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> It would help to use '-M' option with format-patch for this kind of rework.
>
> Regards,
> Arend
>
Thanks, was looking for some option but didn't find it.

Have a rediff below. :-)
8< --------

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 Documentation/DocBook/device-drivers.tmpl | 3 +--
 MAINTAINERS                               | 4 ++--
 drivers/Makefile                          | 1 +
 drivers/base/Makefile                     | 1 -
 drivers/dma-buf/Makefile                  | 1 +
 drivers/{base => dma-buf}/dma-buf.c       | 0
 drivers/{base => dma-buf}/reservation.c   | 0
 7 files changed, 5 insertions(+), 5 deletions(-)
 create mode 100644 drivers/dma-buf/Makefile
 rename drivers/{base => dma-buf}/dma-buf.c (100%)
 rename drivers/{base => dma-buf}/reservation.c (100%)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index cc63f30de166..ac61ebd92875 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -128,8 +128,7 @@ X!Edrivers/base/interface.c
 !Edrivers/base/bus.c
      </sect1>
      <sect1><title>Device Drivers DMA Management</title>
-!Edrivers/base/dma-buf.c
-!Edrivers/base/reservation.c
+!Edrivers/dma-buf/dma-buf.c
 !Iinclude/linux/reservation.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
diff --git a/MAINTAINERS b/MAINTAINERS
index 134483f206e4..c948e53a4ee6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2882,8 +2882,8 @@ S:	Maintained
 L:	linux-media@vger.kernel.org
 L:	dri-devel@lists.freedesktop.org
 L:	linaro-mm-sig@lists.linaro.org
-F:	drivers/base/dma-buf*
-F:	include/linux/dma-buf*
+F:	drivers/dma-buf/
+F:	include/linux/dma-buf* include/linux/reservation.h
 F:	Documentation/dma-buf-sharing.txt
 T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
diff --git a/drivers/Makefile b/drivers/Makefile
index f98b50d8251d..c00337be5351 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_FB_INTEL)          += video/fbdev/intelfb/
 
 obj-$(CONFIG_PARPORT)		+= parport/
 obj-y				+= base/ block/ misc/ mfd/ nfc/
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 04b314e0fa51..4aab26ec0292 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o reservation.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
new file mode 100644
index 000000000000..4a4f4c9bacd0
--- /dev/null
+++ b/drivers/dma-buf/Makefile
@@ -0,0 +1 @@
+obj-y := dma-buf.o reservation.o
diff --git a/drivers/base/dma-buf.c b/drivers/dma-buf/dma-buf.c
similarity index 100%
rename from drivers/base/dma-buf.c
rename to drivers/dma-buf/dma-buf.c
diff --git a/drivers/base/reservation.c b/drivers/dma-buf/reservation.c
similarity index 100%
rename from drivers/base/reservation.c
rename to drivers/dma-buf/reservation.c
-- 
2.0.0


