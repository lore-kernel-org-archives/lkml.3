Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3CKPef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:34:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:13331 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3CKPed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:34:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,824,1355126400"; 
   d="scan'208";a="303956913"
Message-ID: <1363016099.3348.47.camel@sauron.fi.intel.com>
Subject: Dead mappings and drivers in MTD
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: linux-mtd@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Mar 2013 17:34:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MTD folks,

we have huge amount of drivers, espacially mapping drives in
'drivers/mtd', and for sure may of them are for ancient devices which
are long dead and not supported by modern kernels anyway. I would like
to do a small clean-up. It is difficult to judge which ones are dead for
me, so I am asking the community to help. Thanks!

There are few easy cases - some drivers depend on Kconfig symbols which
are not defined anywhere - I guess these are clear candidates for
removal. For example this one:

config MTD_DBOX2
        tristate "CFI Flash device mapped on D-Box2"
        depends on DBOX2 && MTD_CFI_INTELSTD && MTD_CFI_INTELEXT && MTD_CFI_AMDSTD
        help
          This enables access routines for the flash chips on the Nokia/Sagem
          D-Box 2 board. If you have one of these boards and would like to use

Grepping for "DBOX2" gives nothing.

-- 
Best Regards,
Artem Bityutskiy

