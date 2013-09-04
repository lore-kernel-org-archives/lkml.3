Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab3IDS6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:58:33 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60116 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759478Ab3IDS6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:58:32 -0400
Date: Wed, 4 Sep 2013 13:58:20 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH v3 0/2] rsxx: RSXX driver Bug fixes.
Message-ID: <20130904185820.GD24898@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090418-0320-0000-0000-000000E4690A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The incoming patch series contains 2 patches for the
rsxx driver (drivers/block/rsxx). 

Version 1:
A patch series containing 5 patches was sent out a few
weeks ago.

Version 2:
o This version decreased the number of patches for the patch
  series based on importance.
o Started using the function pci_dma_mapping_error to check
  the return status of pci_map_page.

Version 3:
o Fixes a compile error in patch 1.
o Changed the error handling for pci_map_page
  to cancel all dmas instead of just returning
  out.

Patch 1:
	The driver wasn't handling the return value
	of pci_map_page correctly for the PowerPC
	architecture. This also uncovered a double
	free scenario that is fixed here.

Patch 2:
	In this patch, the pci_map_page function has
	been moved into our issued workqueue to prevent
	an us running out of mappable addresses on non-
	HWWD PCIe x8 slots. The maximum amount that
	can possible be mapped at one time now is:
	255 dmas X 4 dma channels X 4096 Bytes.

Regards,
- Philip Kelleher
	

