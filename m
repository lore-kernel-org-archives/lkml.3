Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaEOICR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:02:17 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:53828 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaEOICJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:02:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: nsekhar@ti.com, joelf@ti.com, linux@arm.linux.org.uk, vinod.koul@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, tony@atomide.com, bcousson@baylibre.com
Subject: Re: [PATCH v2 3/5] dt/bindings: ti,edma: Remove redundant properties from documentation
Date: Thu, 15 May 2014 10:01:57 +0200
Message-ID: <7468082.VY82PIo3ZY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399977032-26469-4-git-send-email-peter.ujfalusi@ti.com>
References: <1399977032-26469-1-git-send-email-peter.ujfalusi@ti.com> <1399977032-26469-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GdzsTUP1tiS/wAQpuDmp73ZzOQF+Ps6jdHfvmVFqtu+
 17ws4/1fHZYz+XoAsfgTygVWg/gmy9yhlwa8yfBIM62j//+mnt
 pZD2LyzARQXwBfT7bb2qU/+2XZ4uBRD62KTAKUfVp4r5iS2fHc
 fsozPBEkwvNU2y1Qd96NAi0fLedPQKipNzP7JBI+5gB8fAwRQa
 jiNQdUw8mlzuV948JaPjl+RMwdQ/oYPsrsCUzXhUBdrpRn3ORI
 yaWYubd+mB9gKTKDgD+enKBZzKe/hCU4RGrtfM7jSBTyJ8yggb
 y4ng096kHrbOEwJfFyw2jGsdHHYxmDJurBd12/XHmBQDxo8Noh
 2RQCA/vSXRLO4Jizd5JY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 13:30:30 Peter Ujfalusi wrote:
> From CCCFG register of eDMA3 we can get all the needed information for the
> driver about the IP:
> Number of channels: NUM_DMACH
> Number of regions: NUM_REGN
> Number of slots (PaRAM sets): NUM_PAENTRY
> Number of TC/EQ: NUM_EVQUE
> 
> The ti,edma-regions; ti,edma-slots and dma-channels in DT are
> redundant since the very same information can be obtained from the HW.
> The mentioned properties can be removed from the binding document.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

I wonder if we should keep them listed as "optional" properties so you
can have a dtb file that still works with older kernels which need them.

What you do is an incompatible change to the binding, which we shouldn't
do lightly. Any new dts files don't need this information of course, but
as a general rule, I'd rather keep things like this around unless we
already have to enforce an ABI break that is well documented.

	Arnd
