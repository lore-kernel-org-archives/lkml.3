Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaANOxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:53:38 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.179]:44546 "EHLO
	mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:53:35 -0500
X-RZG-CLASS-ID: mo04
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ4Kkzc/qnW2/7rNbk=
Date: Tue, 14 Jan 2014 15:53:28 +0100
From: Olaf Hering <olaf@aepfle.de>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        xen-devel@lists.xen.org, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v2] xen-blkfront: remove type check from
 blkfront_setup_discard
Message-ID: <20140114145328.GA12888@aepfle.de>
References: <1389608052-7139-1-git-send-email-olaf@aepfle.de>
 <52D3DAEE0200007800112FD4@nat28.tlf.novell.com>
 <20140113120131.GA15623@aepfle.de>
 <52D3EB5F02000078001130B5@nat28.tlf.novell.com>
 <1389618054.13654.57.camel@kazak.uk.xensource.com>
 <52D3F535020000780011311B@nat28.tlf.novell.com>
 <52D3EE14.3080609@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D3EE14.3080609@citrix.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, David Vrabel wrote:

> Can we have a patch to blkif.h that clarifies this?

What about this change?

diff --git a/xen/include/public/io/blkif.h b/xen/include/public/io/blkif.h
index 84eb7fd..56e2faa 100644
--- a/xen/include/public/io/blkif.h
+++ b/xen/include/public/io/blkif.h
@@ -194,6 +194,7 @@
  * discard-secure
  *      Values:         0/1 (boolean)
  *      Default Value:  0
+ *      Notes:          10
  *
  *      A value of "1" indicates that the backend can process BLKIF_OP_DISCARD
  *      requests with the BLKIF_DISCARD_SECURE flag set.
@@ -323,9 +324,10 @@
  *     For full interoperability, block front and backends should publish
  *     identical ring parameters, adjusted for unit differences, to the
  *     XenStore nodes used in both schemes.
- * (4) Devices that support discard functionality may internally allocate
- *     space (discardable extents) in units that are larger than the
- *     exported logical block size.
+ * (4) Devices that support discard functionality may internally allocate space
+ *     (discardable extents) in units that are larger than the exported logical
+ *     block size. The properties discard-granularity and discard-alignment may
+ *     be present if the backing device has such requirments.
  * (5) The discard-alignment parameter allows a physical device to be
  *     partitioned into virtual devices that do not necessarily begin or
  *     end on a discardable extent boundary.
@@ -344,6 +346,8 @@
  *     grants that can be persistently mapped in the frontend driver, but
  *     due to the frontent driver implementation it should never be bigger
  *     than RING_SIZE * BLKIF_MAX_SEGMENTS_PER_REQUEST.
+ *(10) The discard-secure property may be present and will be set to 1 if the
+ *     backing device supports secure discard.
  */
 
 /*


Olaf

