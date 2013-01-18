Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3AROOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:14:10 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:2134 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3AROOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:14:07 -0500
X-IronPort-AV: E=Sophos;i="4.84,492,1355126400"; 
   d="scan'208";a="16881790"
X-IronPort-AV: E=Sophos;i="4.84,492,1355126400"; 
   d="scan'208";a="379773537"
From: "Kondratiev, Vladimir" <vkondrat@qti.qualcomm.com>
To: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca_vkondrat <qca_vkondrat@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: RE: linux-next: build failure after merge of the driver-core tree
Thread-Topic: linux-next: build failure after merge of the driver-core tree
Thread-Index: AQHN9SOejfCyd0jZcUOuLlBC4NzkZ5hPACMAgAAZeKE=
Date: Fri, 18 Jan 2013 14:14:05 +0000
Message-ID: <A5CA08B46412E243958C77F3825F439517BBDA3B@NASANEXD02E.na.qualcomm.com>
References: <20130118132904.ec0677175f1191290f060776@canb.auug.org.au>,<20130118041322.GA25106@kroah.com>
In-Reply-To: <20130118041322.GA25106@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.115.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Jan 18, 2013 at 01:29:04PM +1100, Stephen Rothwell wrote:
> Hi Greg,
>
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> In file included from drivers/net/wireless/ath/wil6210/wil6210.h:24:0,
>                  from drivers/net/wireless/ath/wil6210/main.c:26:
> drivers/net/wireless/ath/wil6210/dbg_hexdump.h:21:0: error: "print_hex_dump_bytes" redefined [-Werror]
> include/linux/printk.h:322:0: note: this is the location of the previous definition
>
> Caused by commit 7a555613eb77 ("dynamic_debug: dynamic hex dump")
> interacting with commit 2be7d22f0625 ("wireless: add new wil6210 802.11ad
> 60GHz driver") that was added to Linus' tree in the last few days.
>
> I have applied the following merge fix patch for today:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 18 Jan 2013 13:24:32 +1100
> Subject: [PATCH] wireless: remove conflicting version of print_hex_dump_bytes
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks, I've merged 3.9-rc4 into my tree and applied this patch to fix
the build breakage.

greg k-h

Sorry for the mess; this conflicting file should disappear after the other commit, 
"dynamic_debug: dynamic hex dump", merged. It was intended as temporal replacement.

Patch by Stephen Rothwell is just fine in the mean time.

Unfortunately, this catches me on my way to the airport, going for 1 week ski vacation.

I'll submit patch to remove 
drivers/net/wireless/ath/wil6210/dbg_hexdump.h
and s/wil_print_hex_dump_debug/print_hex_dump_debug/ for the rest of the wil6210 driver.

Thanks, Vladimir.

