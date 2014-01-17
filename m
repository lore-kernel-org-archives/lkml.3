Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaAQTlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:41:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44678 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAQTln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:41:43 -0500
Message-ID: <52D9876C.3070705@infradead.org>
Date: Fri, 17 Jan 2014 11:41:32 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "David S. Miller" <davem@davemloft.net>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-zigbee-devel@lists.sourceforge.net,
        Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        netdev@vger.kernel.org,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] Bluetooth: remove direct compilation of 6lowpan_iphc.c
References: <1389986964-5177-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1389986964-5177-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 11:29 AM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> It's now built as a separate utility module, and enabling BT selects
> that module in Kconfig. This fixes:
> 
> net/ieee802154/built-in.o:(___ksymtab_gpl+lowpan_process_data+0x0): multiple definition of `__ksymtab_lowpan_process_data'
> net/bluetooth/built-in.o:(___ksymtab_gpl+lowpan_process_data+0x0): first defined here
> net/ieee802154/built-in.o:(___ksymtab_gpl+lowpan_header_compress+0x0): multiple definition of `__ksymtab_lowpan_header_compress'
> net/bluetooth/built-in.o:(___ksymtab_gpl+lowpan_header_compress+0x0): first defined here
> net/ieee802154/built-in.o: In function `lowpan_header_compress':
> net/ieee802154/6lowpan_iphc.c:606: multiple definition of `lowpan_header_compress'
> net/bluetooth/built-in.o:/home/swarren/shared/git_wa/kernel/kernel.git/net/bluetooth/../ieee802154/6lowpan_iphc.c:606: first defined here
> net/ieee802154/built-in.o: In function `lowpan_process_data':
> net/ieee802154/6lowpan_iphc.c:344: multiple definition of `lowpan_process_data'
> net/bluetooth/built-in.o:/home/swarren/shared/git_wa/kernel/kernel.git/net/bluetooth/../ieee802154/6lowpan_iphc.c:344: first defined here
> make[1]: *** [net/built-in.o] Error 1
> 
> (this change probably simply wasn't "git add"d to a53d34c3465b)
> 
> Fixes: a53d34c3465b ("net: move 6lowpan compression code to separate module")
> Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  net/bluetooth/Makefile | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
> index cc6827e2ce68..80cb215826e8 100644
> --- a/net/bluetooth/Makefile
> +++ b/net/bluetooth/Makefile
> @@ -12,8 +12,4 @@ bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
>  	hci_sock.o hci_sysfs.o l2cap_core.o l2cap_sock.o smp.o sco.o lib.o \
>  	a2mp.o amp.o 6lowpan.o
>  
> -ifeq ($(CONFIG_IEEE802154_6LOWPAN),)
> -  bluetooth-y +=  ../ieee802154/6lowpan_iphc.o
> -endif
> -
>  subdir-ccflags-y += -D__CHECK_ENDIAN__
> 


-- 
~Randy
