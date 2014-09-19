Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbaISW3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:29:08 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:16531
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757837AbaISW3F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:29:05 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Randy Dunlap <rdunlap@infradead.org>, Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: RE: linux-next: Tree for Sep 19
Thread-Topic: linux-next: Tree for Sep 19
Thread-Index: AQHP1E6ozuiqDeyYUEOIJuP0CTEAAZwJfPWA//+LhC8=
Date: Fri, 19 Sep 2014 22:28:07 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88EF5BD@nice.asicdesigners.com>
References: <20140919165817.225eb8b8@canb.auug.org.au>
 <20140919211404.GA24856@roeck-us.net>,<541CAC81.9040404@infradead.org>
In-Reply-To: <541CAC81.9040404@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.163.152]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it completely acceptable to have default configs that select menu entries 
but not their dependencies ? Since essentially earlier the select on 
SCSI_NETLINK select used to select NET but no longer does, so I'm wondering
 if this was an oversight earlier.  Is this something that's supposed to be 
automatically resolved ?
-Anish
________________________________________
From: Randy Dunlap [rdunlap@infradead.org]
Sent: Friday, September 19, 2014 3:21 PM
To: Guenter Roeck; Stephen Rothwell
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Anish Bhatt; David S. Miller; James E.J. Bottomley
Subject: Re: linux-next: Tree for Sep 19

On 09/19/14 14:14, Guenter Roeck wrote:
> On Fri, Sep 19, 2014 at 04:58:17PM +1000, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20140917:
>>
>> The fsl tree still had its build failure so I used the version from
>> next-20140917.
>>
>> The v4l-dvb tree lost its build failure.
>>
>> The security tree gained a conflict against the file-locks tree.
>>
>> Non-merge commits (relative to Linus' tree): 6014
>>  5488 files changed, 217522 insertions(+), 129375 deletions(-)
>>
>> ----------------------------------------------------------------------------
>>
> Guess this is most difficult one.
>
> mips:nlm_xlp_defconfig:
>
> warning: (SCSI_BNX2X_FCOE && LIBFCOE && TCM_QLA2XXX) selects LIBFC which has
> unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS)
> warning: (SCSI_BNX2X_FCOE && LIBFCOE && TCM_QLA2XXX) selects LIBFC which has
> unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS)

Yes, I have a patch sitting on my hard drive that makes LIBFCOE and TCM_QLA2XXX
and SCSI_BNX2X_FCOE depend on SCSI_FC_ATTRS, but I'm not entirely happy about
having to hunt these down (even with the help of kconfig warnings).

I'm pretty sure that I can fix these (above and build errors below), but
there is still a bunch of nasty kconfig warnings that I don't understand
and don't know how to fix:

(powerpc ppc64_defconfig) produced these warnings:

warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
warning: (PPC_CELL_NATIVE && AKEBONO && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)
warning: (PPC_CELL_NATIVE && AKEBONO && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM)


git bisect also points to the SCSI_NETLINK dependency commit for these (unless
I did the bisect incorrectly).

Does anyone have a clue on these?
Thanks.


> followed by:
>
> ERROR: "scsi_is_fc_rport" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "fc_get_event_number" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "skb_trim" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "fc_host_post_event" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "__alloc_skb" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "fc_remote_port_delete" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "kfree_skb" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "fc_block_scsi_eh" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "fc_remote_port_add" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "skb_put" [drivers/scsi/libfc/libfc.ko] undefined!
> ERROR: "skb_clone" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "dev_get_by_name" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "register_netdevice_notifier" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "unregister_netdevice_notifier" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "skb_trim" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "__netdev_alloc_skb" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "__pskb_pull_tail" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "skb_queue_purge" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "__ethtool_get_settings" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "skb_push" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "skb_pull" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "init_net" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "skb_queue_tail" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "kfree_skb" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "skb_dequeue" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "consume_skb" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "dev_queue_xmit" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "skb_put" [drivers/scsi/fcoe/libfcoe.ko] undefined!
> ERROR: "dev_get_stats" [drivers/scsi/fcoe/libfcoe.ko] undefined!
>
> The problem is that there are many different errors seen at various stages
> during bisect, making a bisect a bit tricky.
>
> --------
> At commit 'xfrm: Generate blackhole routes only from route lookup functions',
> the error is:
>
> drivers/scsi/scsi_transport_fc.c: In function 'fc_host_post_event':
> drivers/scsi/scsi_transport_fc.c:543:7: error: 'scsi_nl_sock' undeclared
> drivers/scsi/scsi_transport_fc.c: In function 'fc_host_post_vendor_event':
> drivers/scsi/scsi_transport_fc.c:611:7: error: 'scsi_nl_sock' undeclared
>
> --------
> At commit 'bnx2i/bnx2fc : fix randconfig error in next-20140909' and
> 'scsi_netlink : Make SCSI_NETLINK dependent on NET instead of selecting NET',
> the error is:
>
> drivers/built-in.o: In function `scsi_nl_rcv_msg':
> drivers/scsi/scsi_netlink.c:114: undefined reference to `netlink_ack'
> drivers/scsi/scsi_netlink.c:116: undefined reference to `skb_pull'
> drivers/scsi/scsi_netlink.c:80: undefined reference to `netlink_capable'
> drivers/built-in.o: In function `netlink_kernel_create':
> include/linux/netlink.h:60: undefined reference to `init_net'
> include/linux/netlink.h:60: undefined reference to `init_net'
> include/linux/netlink.h:60: undefined reference to `__netlink_kernel_create'
> drivers/built-in.o: In function `scsi_netlink_exit':
> drivers/scsi/scsi_netlink.c:153: undefined reference to `netlink_kernel_release'
>
> -------
>
> Bisect reports commit 5d6be6a5d486 ('scsi_netlink : Make SCSI_NETLINK dependent
> on NET instead of selecting NET') as first bad commit.


--
~Randy
