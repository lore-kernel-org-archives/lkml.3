Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbaAKDfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 22:35:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:35008 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbaAKDfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 22:35:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,642,1384329600"; 
   d="scan'208";a="457032187"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
Subject: RE: [PATCH] e1000: avoid potential deadlock in
 e1000_do_[read|write]_eeprom()
Thread-Topic: [PATCH] e1000: avoid potential deadlock in
 e1000_do_[read|write]_eeprom()
Thread-Index: AQHO/dKCxlCPtq3w/0KnQshnIHZSXpp+/7ww
Date: Sat, 11 Jan 2014 03:35:25 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B73129684@ORSMSX101.amr.corp.intel.com>
References: <1387578320-26525-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1387578320-26525-1-git-send-email-khoroshilov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Alexey Khoroshilov
> Sent: Friday, December 20, 2013 2:25 PM
> To: Kirsher, Jeffrey T
> Cc: Alexey Khoroshilov; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
> Carolyn; Skidmore, Donald C; Rose, Gregory V; Duyck, Alexander H; Ronciak,
> John; e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; ldv-project@linuxtesting.org
> Subject: [PATCH] e1000: avoid potential deadlock in
> e1000_do_[read|write]_eeprom()
> 
> If eeprom->word_size is zero, e1000_do_[read|write]_eeprom() invoke
> e1000_init_eeprom_params() to reinit eeprom params.
> That is not a good idea since e1000_init_eeprom_params() calls
> e1000_read_eeprom() if eeprom->type is e1000_eeprom_spi.
> That means a deadlock on e1000_eeprom_lock.
> 
> At the same time it is unclear if the reinit is needed at all.
> e1000_init_eeprom_params() is called from probe, so it should succeed
> before any activities of the module start.
> 
> The patch suggests to remove the try to reinit eeprom params.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Signed-off-by: Aaron Brown <aaron.f.brown@intel.com>
Tested by: Aaron Brown <aaron.f.brown@intel.com>

> ---
>  drivers/net/ethernet/intel/e1000/e1000_hw.c | 8 --------
>  1 file changed, 8 deletions(-)

