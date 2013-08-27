Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3H0W5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 18:57:10 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37231 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3H0W5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:57:09 -0400
Date: Tue, 27 Aug 2013 17:57:03 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH v2 0/2] rsxx: RSXX driver Bug fixes.
Message-ID: <20130827225703.GA7368@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082722-5518-0000-0000-0000118073F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The incoming patch series contains 2 patches for the
rsxx driver (drivers/block/rsxx). I sent a patch series
containing 5 patches a couple weeks ago, which contained
version 1 of the this series.

Version 2 changes:
o Patches 3 thru 5 were removed because of importance.
o pci_dma_mapping_error was added to check the return
  status of pci_map_page.

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
	

