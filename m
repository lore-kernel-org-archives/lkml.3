Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3ANC3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:29:39 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59277 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3ANC3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:29:36 -0500
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: gregkh@linuxfoundation.org, greg@kroah.com
Cc: Cruz Julian Bishop <cruzjbishop@gmail.com>, liodot@gmail.com,
        charrer@alacritech.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: slicoss: Fix space-related checkpatch.pl warnings
Date: Mon, 14 Jan 2013 12:29:09 +1000
Message-Id: <1358130549-10969-4-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358130549-10969-1-git-send-email-cruzjbishop@gmail.com>
References: <1358130549-10969-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes all instances of
	"Please, no spaces at start of a new line"
	"Please, no spaces before tabs"

Please note that I probably got the warning names wrong,
but they should be close enough for usage here :)

Additional post-commit note: There is one comment on line 230ish in slic.h
that appears to have lost it's formatting. It was fine when I was working
in Geany, but it caught my eye in the below diff. Sorry if it actually happened!

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/slicoss/slic.h    |  504 ++++++++++++++++++-------------------
 drivers/staging/slicoss/slichw.h  |    6 +-
 drivers/staging/slicoss/slicoss.c |   22 +-
 3 files changed, 266 insertions(+), 266 deletions(-)

diff --git a/drivers/staging/slicoss/slic.h b/drivers/staging/slicoss/slic.h
index ebdcc6f..4c7822b 100644
--- a/drivers/staging/slicoss/slic.h
+++ b/drivers/staging/slicoss/slic.h
@@ -43,15 +43,15 @@
 
 /* firmware stuff */
 #define OASIS_UCODE_VERS_STRING	"1.2"
-#define OASIS_UCODE_VERS_DATE  	"2006/03/27 15:10:37"
-#define OASIS_UCODE_HOSTIF_ID  	3
+#define OASIS_UCODE_VERS_DATE	"2006/03/27 15:10:37"
+#define OASIS_UCODE_HOSTIF_ID	3
 
 #define MOJAVE_UCODE_VERS_STRING	"1.2"
-#define MOJAVE_UCODE_VERS_DATE  	"2006/03/27 15:12:22"
-#define MOJAVE_UCODE_HOSTIF_ID  	3
+#define MOJAVE_UCODE_VERS_DATE		"2006/03/27 15:12:22"
+#define MOJAVE_UCODE_HOSTIF_ID		3
 
 #define GB_RCVUCODE_VERS_STRING	"1.2"
-#define GB_RCVUCODE_VERS_DATE  	"2006/03/27 15:12:15"
+#define GB_RCVUCODE_VERS_DATE	"2006/03/27 15:12:15"
 static u32 OasisRcvUCodeLen = 512;
 static u32 GBRcvUCodeLen = 512;
 #define SECTION_SIZE 65536
@@ -65,12 +65,12 @@ struct slic_spinlock {
 #define SLIC_RSPQ_BUFSINPAGE      (PAGE_SIZE / SLIC_RSPBUF_SIZE)
 
 struct slic_rspqueue {
-    u32             offset;
-    u32             pageindex;
-    u32             num_pages;
-    struct slic_rspbuf *rspbuf;
-    u32 *vaddr[SLIC_RSPQ_PAGES_GB];
-    dma_addr_t          paddr[SLIC_RSPQ_PAGES_GB];
+	u32             offset;
+	u32             pageindex;
+	u32             num_pages;
+	struct slic_rspbuf *rspbuf;
+	u32 *vaddr[SLIC_RSPQ_PAGES_GB];
+	dma_addr_t          paddr[SLIC_RSPQ_PAGES_GB];
 };
 
 #define SLIC_RCVQ_EXPANSION         1
@@ -82,20 +82,20 @@ struct slic_rspqueue {
 #define SLIC_RCVQ_FILLTHRESH        (SLIC_RCVQ_ENTRIES - SLIC_RCVQ_FILLENTRIES)
 
 struct slic_rcvqueue {
-    struct sk_buff    *head;
-    struct sk_buff    *tail;
-    u32            count;
-    u32            size;
-    u32            errors;
+	struct sk_buff    *head;
+	struct sk_buff    *tail;
+	u32            count;
+	u32            size;
+	u32            errors;
 };
 
 struct slic_rcvbuf_info {
-    u32     id;
-    u32     starttime;
-    u32     stoptime;
-    u32     slicworld;
-    u32     lasttime;
-    u32     lastid;
+	u32     id;
+	u32     starttime;
+	u32     stoptime;
+	u32     slicworld;
+	u32     lasttime;
+	u32     lastid;
 };
 /*
  SLIC Handle structure.  Used to restrict handle values to
@@ -113,12 +113,12 @@ struct slic_handle_word {
 };
 
 struct slic_handle {
-    struct slic_handle_word  token;  /* token passed between host and card*/
-    ushort                      type;
-    void *address;    /* actual address of the object*/
-    ushort                      offset;
-    struct slic_handle       *other_handle;
-    struct slic_handle       *next;
+	struct slic_handle_word  token;  /* token passed between host and card*/
+	ushort                      type;
+	void *address;    /* actual address of the object*/
+	ushort                      offset;
+	struct slic_handle       *other_handle;
+	struct slic_handle       *next;
 };
 
 #define SLIC_HANDLE_FREE        0x0000
@@ -134,17 +134,17 @@ struct slic_handle {
 #define SLIC_HOSTCMD_SIZE    512
 
 struct slic_hostcmd {
-    struct slic_host64_cmd  cmd64;
-    u32                    type;
-    struct sk_buff            *skb;
-    u32                    paddrl;
-    u32                    paddrh;
-    u32                    busy;
-    u32                    cmdsize;
-    ushort                     numbufs;
-    struct slic_handle    *pslic_handle;/* handle associated with command */
-    struct slic_hostcmd    *next;
-    struct slic_hostcmd    *next_all;
+	struct slic_host64_cmd  cmd64;
+	u32                    type;
+	struct sk_buff            *skb;
+	u32                    paddrl;
+	u32                    paddrh;
+	u32                    busy;
+	u32                    cmdsize;
+	ushort                     numbufs;
+	struct slic_handle    *pslic_handle;/* handle associated with command */
+	struct slic_hostcmd    *next;
+	struct slic_hostcmd    *next_all;
 };
 
 #define SLIC_CMDQ_CMDSINPAGE    (PAGE_SIZE / SLIC_HOSTCMD_SIZE)
@@ -228,35 +228,35 @@ struct mcast_address {
 #define SLIC_CARD_STATE(x)    ((x == CARD_UP) ? "UP" : "Down")
 
 struct slic_iface_stats {
-    /*
-     * Stats
-     */
-    u64        xmt_bytes;
-    u64        xmt_ucast;
-    u64        xmt_mcast;
-    u64        xmt_bcast;
-    u64        xmt_errors;
-    u64        xmt_discards;
-    u64        xmit_collisions;
-    u64        xmit_excess_xmit_collisions;
-    u64        rcv_bytes;
-    u64        rcv_ucast;
-    u64        rcv_mcast;
-    u64        rcv_bcast;
-    u64        rcv_errors;
-    u64        rcv_discards;
+	/*
+	* Stats
+	*/
+	u64        xmt_bytes;
+	u64        xmt_ucast;
+	u64        xmt_mcast;
+	u64        xmt_bcast;
+	u64        xmt_errors;
+	u64        xmt_discards;
+	u64        xmit_collisions;
+	u64        xmit_excess_xmit_collisions;
+	u64        rcv_bytes;
+	u64        rcv_ucast;
+	u64        rcv_mcast;
+	u64        rcv_bcast;
+	u64        rcv_errors;
+	u64        rcv_discards;
 };
 
 struct sliccp_stats {
-    u64        xmit_tcp_segs;
-    u64        xmit_tcp_bytes;
-    u64        rcv_tcp_segs;
-    u64        rcv_tcp_bytes;
+	u64        xmit_tcp_segs;
+	u64        xmit_tcp_bytes;
+	u64        rcv_tcp_segs;
+	u64        rcv_tcp_bytes;
 };
 
 struct slicnet_stats {
-    struct sliccp_stats        tcp;
-    struct slic_iface_stats      iface;
+	struct sliccp_stats        tcp;
+	struct slic_iface_stats      iface;
 };
 
 #define SLIC_LOADTIMER_PERIOD     1
@@ -285,51 +285,51 @@ struct slicnet_stats {
 #define SLIC_INTAGG_5GB           100
 
 struct ether_header {
-    unsigned char    ether_dhost[6];
-    unsigned char    ether_shost[6];
-    ushort   ether_type;
+	unsigned char    ether_dhost[6];
+	unsigned char    ether_shost[6];
+	ushort   ether_type;
 };
 
 struct sliccard {
-    uint              busnumber;
-    uint              slotnumber;
-    uint              state;
-    uint              cardnum;
-    uint              card_size;
-    uint              adapters_activated;
-    uint              adapters_allocated;
-    uint              adapters_sleeping;
-    uint              gennumber;
-    u32           events;
-    u32           loadlevel_current;
-    u32           load;
-    uint              reset_in_progress;
-    u32           pingstatus;
-    u32           bad_pingstatus;
-    struct timer_list loadtimer;
-    u32           loadtimerset;
-    uint              config_set;
-    struct slic_config  config;
-    struct dentry      *debugfs_dir;
-    struct dentry      *debugfs_cardinfo;
-    struct adapter  *master;
-    struct adapter  *adapter[SLIC_MAX_PORTS];
-    struct sliccard *next;
-    u32             error_interrupts;
-    u32             error_rmiss_interrupts;
-    u32             rcv_interrupts;
-    u32             xmit_interrupts;
-    u32             num_isrs;
-    u32             false_interrupts;
-    u32             max_isr_rcvs;
-    u32             max_isr_xmits;
-    u32             rcv_interrupt_yields;
-    u32             tx_packets;
-    u32             debug_ix;
-    ushort              reg_type[32];
-    ushort              reg_offset[32];
-    u32             reg_value[32];
-    u32             reg_valueh[32];
+	uint              busnumber;
+	uint              slotnumber;
+	uint              state;
+	uint              cardnum;
+	uint              card_size;
+	uint              adapters_activated;
+	uint              adapters_allocated;
+	uint              adapters_sleeping;
+	uint              gennumber;
+	u32           events;
+	u32           loadlevel_current;
+	u32           load;
+	uint              reset_in_progress;
+	u32           pingstatus;
+	u32           bad_pingstatus;
+	struct timer_list loadtimer;
+	u32           loadtimerset;
+	uint              config_set;
+	struct slic_config  config;
+	struct dentry      *debugfs_dir;
+	struct dentry      *debugfs_cardinfo;
+	struct adapter  *master;
+	struct adapter  *adapter[SLIC_MAX_PORTS];
+	struct sliccard *next;
+	u32             error_interrupts;
+	u32             error_rmiss_interrupts;
+	u32             rcv_interrupts;
+	u32             xmit_interrupts;
+	u32             num_isrs;
+	u32             false_interrupts;
+	u32             max_isr_rcvs;
+	u32             max_isr_xmits;
+	u32             rcv_interrupt_yields;
+	u32             tx_packets;
+	u32             debug_ix;
+	ushort              reg_type[32];
+	ushort              reg_offset[32];
+	u32             reg_value[32];
+	u32             reg_valueh[32];
 };
 
 #define NUM_CFG_SPACES      2
@@ -337,182 +337,182 @@ struct sliccard {
 #define NUM_CFG_REG_ULONGS  (NUM_CFG_REGS / sizeof(u32))
 
 struct physcard {
-    struct adapter  *adapter[SLIC_MAX_PORTS];
-    struct physcard *next;
-    uint                adapters_allocd;
+	struct adapter  *adapter[SLIC_MAX_PORTS];
+	struct physcard *next;
+	uint                adapters_allocd;
 
- /*  the following is not currently needed
-    u32               bridge_busnum;
-    u32               bridge_cfg[NUM_CFG_SPACES][NUM_CFG_REG_ULONGS];
- */
+/*  the following is not currently needed
+	u32              bridge_busnum;
+	u32              bridge_cfg[NUM_CFG_SPACES][NUM_CFG_REG_ULONGS];
+*/
 };
 
 struct base_driver {
-    struct slic_spinlock driver_lock;
-    u32              num_slic_cards;
-    u32              num_slic_ports;
-    u32              num_slic_ports_active;
-    u32              dynamic_intagg;
-    struct sliccard  *slic_card;
-    struct physcard  *phys_card;
-    uint                 cardnuminuse[SLIC_MAX_CARDS];
+	struct slic_spinlock driver_lock;
+	u32              num_slic_cards;
+	u32              num_slic_ports;
+	u32              num_slic_ports_active;
+	u32              dynamic_intagg;
+	struct sliccard  *slic_card;
+	struct physcard  *phys_card;
+	uint                 cardnuminuse[SLIC_MAX_CARDS];
 };
 
 struct slic_shmem {
-    volatile u32          isr;
-    volatile u32          linkstatus;
-    volatile struct slic_stats     inicstats;
+	volatile u32          isr;
+	volatile u32          linkstatus;
+	volatile struct slic_stats     inicstats;
 };
 
 struct slic_reg_params {
-    u32       linkspeed;
-    u32       linkduplex;
-    u32       fail_on_bad_eeprom;
+	u32       linkspeed;
+	u32       linkduplex;
+	u32       fail_on_bad_eeprom;
 };
 
 struct slic_upr {
-    uint               adapter;
-    u32            upr_request;
-    u32            upr_data;
-    u32            upr_data_h;
-    u32            upr_buffer;
-    u32            upr_buffer_h;
-    struct slic_upr *next;
+	uint               adapter;
+	u32            upr_request;
+	u32            upr_data;
+	u32            upr_data_h;
+	u32            upr_buffer;
+	u32            upr_buffer_h;
+	struct slic_upr *next;
 };
 
 struct slic_ifevents {
-    uint        oflow802;
-    uint        uflow802;
-    uint        Tprtoflow;
-    uint        rcvearly;
-    uint        Bufov;
-    uint        Carre;
-    uint        Longe;
-    uint        Invp;
-    uint        Crc;
-    uint        Drbl;
-    uint        Code;
-    uint        IpHlen;
-    uint        IpLen;
-    uint        IpCsum;
-    uint        TpCsum;
-    uint        TpHlen;
+	uint        oflow802;
+	uint        uflow802;
+	uint        Tprtoflow;
+	uint        rcvearly;
+	uint        Bufov;
+	uint        Carre;
+	uint        Longe;
+	uint        Invp;
+	uint        Crc;
+	uint        Drbl;
+	uint        Code;
+	uint        IpHlen;
+	uint        IpLen;
+	uint        IpCsum;
+	uint        TpCsum;
+	uint        TpHlen;
 };
 
 struct adapter {
-    void *ifp;
-    struct sliccard *card;
-    uint                port;
-    struct physcard *physcard;
-    uint                physport;
-    uint                cardindex;
-    uint                card_size;
-    uint                chipid;
-    struct net_device  *netdev;
-    struct net_device  *next_netdevice;
-    struct slic_spinlock     adapter_lock;
-    struct slic_spinlock     reset_lock;
-    struct pci_dev     *pcidev;
-    uint                busnumber;
-    uint                slotnumber;
-    uint                functionnumber;
-    ushort              vendid;
-    ushort              devid;
-    ushort              subsysid;
-    u32             irq;
-    void __iomem *memorybase;
-    u32             memorylength;
-    u32             drambase;
-    u32             dramlength;
-    uint                queues_initialized;
-    uint                allocated;
-    uint                activated;
-    u32             intrregistered;
-    uint                isp_initialized;
-    uint                gennumber;
-    u32             curaddrupper;
-    struct slic_shmem      *pshmem;
-    dma_addr_t          phys_shmem;
-    u32             isrcopy;
-    __iomem struct slic_regs       *slic_regs;
-    unsigned char               state;
-    unsigned char               linkstate;
-    unsigned char               linkspeed;
-    unsigned char               linkduplex;
-    uint                flags;
-    unsigned char               macaddr[6];
-    unsigned char               currmacaddr[6];
-    u32             macopts;
-    ushort              devflags_prev;
-    u64             mcastmask;
-    struct mcast_address   *mcastaddrs;
-    struct slic_upr   *upr_list;
-    uint                upr_busy;
-    struct timer_list   pingtimer;
-    u32             pingtimerset;
-    struct timer_list   loadtimer;
-    u32             loadtimerset;
-    struct dentry      *debugfs_entry;
-    struct slic_spinlock     upr_lock;
-    struct slic_spinlock     bit64reglock;
-    struct slic_rspqueue     rspqueue;
-    struct slic_rcvqueue     rcvqueue;
-    struct slic_cmdqueue     cmdq_free;
-    struct slic_cmdqueue     cmdq_done;
-    struct slic_cmdqueue     cmdq_all;
-    struct slic_cmdqmem      cmdqmem;
-    /*
-     *  SLIC Handles
-    */
-    struct slic_handle slic_handles[SLIC_CMDQ_MAXCMDS+1]; /* Object handles*/
-    struct slic_handle *pfree_slic_handles;          /* Free object handles*/
-    struct slic_spinlock     handle_lock;           /* Object handle list lock*/
-    ushort              slic_handle_ix;
-
-    u32             xmitq_full;
-    u32             all_reg_writes;
-    u32             icr_reg_writes;
-    u32             isr_reg_writes;
-    u32             error_interrupts;
-    u32             error_rmiss_interrupts;
-    u32             rx_errors;
-    u32             rcv_drops;
-    u32             rcv_interrupts;
-    u32             xmit_interrupts;
-    u32             linkevent_interrupts;
-    u32             upr_interrupts;
-    u32             num_isrs;
-    u32             false_interrupts;
-    u32             tx_packets;
-    u32             xmit_completes;
-    u32             tx_drops;
-    u32             rcv_broadcasts;
-    u32             rcv_multicasts;
-    u32             rcv_unicasts;
-    u32             max_isr_rcvs;
-    u32             max_isr_xmits;
-    u32             rcv_interrupt_yields;
-    u32             intagg_period;
-    struct inicpm_state    *inicpm_info;
-    void *pinicpm_info;
-    struct slic_reg_params   reg_params;
-    struct slic_ifevents  if_events;
-    struct slic_stats        inicstats_prev;
-    struct slicnet_stats     slic_stats;
+	void *ifp;
+	struct sliccard *card;
+	uint                port;
+	struct physcard *physcard;
+	uint                physport;
+	uint                cardindex;
+	uint                card_size;
+	uint                chipid;
+	struct net_device  *netdev;
+	struct net_device  *next_netdevice;
+	struct slic_spinlock     adapter_lock;
+	struct slic_spinlock     reset_lock;
+	struct pci_dev     *pcidev;
+	uint                busnumber;
+	uint                slotnumber;
+	uint                functionnumber;
+	ushort              vendid;
+	ushort              devid;
+	ushort              subsysid;
+	u32             irq;
+	void __iomem *memorybase;
+	u32             memorylength;
+	u32             drambase;
+	u32             dramlength;
+	uint                queues_initialized;
+	uint                allocated;
+	uint                activated;
+	u32             intrregistered;
+	uint                isp_initialized;
+	uint                gennumber;
+	u32             curaddrupper;
+	struct slic_shmem      *pshmem;
+	dma_addr_t          phys_shmem;
+	u32             isrcopy;
+	__iomem struct slic_regs       *slic_regs;
+	unsigned char               state;
+	unsigned char               linkstate;
+	unsigned char               linkspeed;
+	unsigned char               linkduplex;
+	uint                flags;
+	unsigned char               macaddr[6];
+	unsigned char               currmacaddr[6];
+	u32             macopts;
+	ushort              devflags_prev;
+	u64             mcastmask;
+	struct mcast_address   *mcastaddrs;
+	struct slic_upr   *upr_list;
+	uint                upr_busy;
+	struct timer_list   pingtimer;
+	u32             pingtimerset;
+	struct timer_list   loadtimer;
+	u32             loadtimerset;
+	struct dentry      *debugfs_entry;
+	struct slic_spinlock     upr_lock;
+	struct slic_spinlock     bit64reglock;
+	struct slic_rspqueue     rspqueue;
+	struct slic_rcvqueue     rcvqueue;
+	struct slic_cmdqueue     cmdq_free;
+	struct slic_cmdqueue     cmdq_done;
+	struct slic_cmdqueue     cmdq_all;
+	struct slic_cmdqmem      cmdqmem;
+	/*
+	*  SLIC Handles
+	*/
+	struct slic_handle slic_handles[SLIC_CMDQ_MAXCMDS+1]; /* Object handles*/
+	struct slic_handle *pfree_slic_handles;          /* Free object handles*/
+	struct slic_spinlock     handle_lock;           /* Object handle list lock*/
+	ushort              slic_handle_ix;
+
+	u32             xmitq_full;
+	u32             all_reg_writes;
+	u32             icr_reg_writes;
+	u32             isr_reg_writes;
+	u32             error_interrupts;
+	u32             error_rmiss_interrupts;
+	u32             rx_errors;
+	u32             rcv_drops;
+	u32             rcv_interrupts;
+	u32             xmit_interrupts;
+	u32             linkevent_interrupts;
+	u32             upr_interrupts;
+	u32             num_isrs;
+	u32             false_interrupts;
+	u32             tx_packets;
+	u32             xmit_completes;
+	u32             tx_drops;
+	u32             rcv_broadcasts;
+	u32             rcv_multicasts;
+	u32             rcv_unicasts;
+	u32             max_isr_rcvs;
+	u32             max_isr_xmits;
+	u32             rcv_interrupt_yields;
+	u32             intagg_period;
+	struct inicpm_state    *inicpm_info;
+	void *pinicpm_info;
+	struct slic_reg_params   reg_params;
+	struct slic_ifevents  if_events;
+	struct slic_stats        inicstats_prev;
+	struct slicnet_stats     slic_stats;
 };
 
 
 #define UPDATE_STATS(largestat, newstat, oldstat)                        \
 {                                                                        \
-    if ((newstat) < (oldstat))                                           \
-	(largestat) += ((newstat) + (0xFFFFFFFF - oldstat + 1));         \
-    else                                                                 \
-	(largestat) += ((newstat) - (oldstat));                          \
+	if ((newstat) < (oldstat))                                       \
+		(largestat) += ((newstat) + (0xFFFFFFFF - oldstat + 1)); \
+	else                                                             \
+		(largestat) += ((newstat) - (oldstat));                  \
 }
 
 #define UPDATE_STATS_GB(largestat, newstat, oldstat)                     \
 {                                                                        \
-    (largestat) += ((newstat) - (oldstat));                              \
+	(largestat) += ((newstat) - (oldstat));                          \
 }
 
 #if BITS_PER_LONG == 64
diff --git a/drivers/staging/slicoss/slichw.h b/drivers/staging/slicoss/slichw.h
index 6275d45..21cd02b 100644
--- a/drivers/staging/slicoss/slichw.h
+++ b/drivers/staging/slicoss/slichw.h
@@ -450,7 +450,7 @@ struct slic_regs {
 	u32	pad34;
 #define SLIC_DBAR64		0x0108
 
-	u32	slic_cbar64; 	/* 64 bit Xmt Cmd buf addr regs. */
+	u32	slic_cbar64;	/* 64 bit Xmt Cmd buf addr regs. */
 	u32	pad35;
 #define SLIC_CBAR64		0x0110
 
@@ -478,11 +478,11 @@ struct slic_regs {
 
 	u32	slic_read_xf_info;	/* Read Transformer info */
 	u32	pad41;
-#define SLIC_READ_XF_INFO 	0x0140
+#define SLIC_READ_XF_INFO	0x0140
 
 	u32	slic_write_xf_info;	/* Write Transformer info */
 	u32	pad42;
-#define SLIC_WRITE_XF_INFO 	0x0148
+#define SLIC_WRITE_XF_INFO	0x0148
 
 	u32	RSVD1;		/* TOE Only */
 	u32	pad43;
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index b6b99a3..76fc2e5 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -144,24 +144,24 @@ MODULE_DEVICE_TABLE(pci, slic_pci_tbl);
 
 #define SLIC_GET_SLIC_HANDLE(_adapter, _pslic_handle)                   \
 {                                                                       \
-    spin_lock_irqsave(&_adapter->handle_lock.lock,                      \
+	spin_lock_irqsave(&_adapter->handle_lock.lock,                  \
 			_adapter->handle_lock.flags);                   \
-    _pslic_handle  =  _adapter->pfree_slic_handles;                     \
-    if (_pslic_handle) {                                                \
-	_adapter->pfree_slic_handles = _pslic_handle->next;             \
-    }                                                                   \
-    spin_unlock_irqrestore(&_adapter->handle_lock.lock,                 \
+	_pslic_handle  =  _adapter->pfree_slic_handles;                 \
+	if (_pslic_handle) {                                            \
+		_adapter->pfree_slic_handles = _pslic_handle->next;     \
+	}                                                               \
+	spin_unlock_irqrestore(&_adapter->handle_lock.lock,             \
 			_adapter->handle_lock.flags);                   \
 }
 
 #define SLIC_FREE_SLIC_HANDLE(_adapter, _pslic_handle)                  \
 {                                                                       \
-    _pslic_handle->type = SLIC_HANDLE_FREE;                             \
-    spin_lock_irqsave(&_adapter->handle_lock.lock,                      \
+	_pslic_handle->type = SLIC_HANDLE_FREE;                         \
+	spin_lock_irqsave(&_adapter->handle_lock.lock,                  \
 			_adapter->handle_lock.flags);                   \
-    _pslic_handle->next = _adapter->pfree_slic_handles;                 \
-    _adapter->pfree_slic_handles = _pslic_handle;                       \
-    spin_unlock_irqrestore(&_adapter->handle_lock.lock,                 \
+	_pslic_handle->next = _adapter->pfree_slic_handles;             \
+	_adapter->pfree_slic_handles = _pslic_handle;                   \
+	spin_unlock_irqrestore(&_adapter->handle_lock.lock,             \
 			_adapter->handle_lock.flags);                   \
 }
 
-- 
1.7.10.4

