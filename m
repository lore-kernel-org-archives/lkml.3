Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaHCAqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 20:46:52 -0400
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:34275 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750866AbaHCAqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 20:46:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:2:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1606:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3870:3871:4117:4250:4321:4362:4423:4605:5007:6117:6119:7652:7903:8603:8957:9040:10004:10226:10848:11026:11232:11473:11657:11658:11914:12043:12294:12438:12517:12519:12681:12740:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0
X-HE-Tag: chalk89_7585d8366685a
X-Filterd-Recvd-Size: 6131
Message-ID: <1407026806.1835.21.camel@joe-AO725>
Subject: Re: [PATCH 1/1] cris: fix %d confusingly prefixed with 0x in format
 string
From: Joe Perches <joe@perches.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: starvik@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, devel <devel@driverdev.osuosl.org>,
        linux-cifs@vger.kernel.org, alsa-devel@alsa-project.org
Date: Sat, 02 Aug 2014 17:46:46 -0700
In-Reply-To: <1407018043-648-1-git-send-email-hans@hanshq.net>
References: <1407018043-648-1-git-send-email-hans@hanshq.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-08-02 at 15:20 -0700, Hans Wennborg wrote:
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  arch/cris/arch-v32/drivers/cryptocop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
[]
> @@ -3155,7 +3155,7 @@ static void print_dma_descriptors(struct cryptocop_int_operation *iop)
>  	printk("print_dma_descriptors start\n");
>  
>  	printk("iop:\n");
> -	printk("\tsid: 0x%lld\n", iop->sid);
> +	printk("\tsid: 0x%llx\n", iop->sid);
>  
>  	printk("\tcdesc_out: 0x%p\n", iop->cdesc_out);
>  	printk("\tcdesc_in: 0x%p\n", iop->cdesc_in);

Thanks.

This is a surprisingly common error:

$ /usr/bin/git grep -P '0x\%(?!ull\b|ul\b|u\b|lu\b|llu\b|llux\b|lux\b|lx\b|lluX\b|luX\b|lX\b)[ul]*[ud]'
arch/arm/mach-omap2/id.c:               pr_warn("%s: unknown idcode=0x%08x (hawkeye=0x%08x,rev=0x%d)\n",
arch/cris/arch-v32/drivers/cryptocop.c: printk("\tsid: 0x%lld\n", iop->sid);
drivers/atm/eni.c:                      return sprintf(page,"tx[%d]:    0x%ld-0x%ld "
drivers/atm/eni.c:                              length += sprintf(page+length,"0x%ld-0x%ld "
drivers/block/DAC960.c:         DAC960_Error("IO port 0x%d busy for Controller at\n",
drivers/block/DAC960.c:         DAC960_Error("IO port 0x%d busy for Controller at\n",
drivers/block/cciss.c:  dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%d\n",
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:        mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d\n",
drivers/mfd/htc-i2cpld.c:       snprintf(client->name, I2C_NAME_SIZE, "Chip_0x%d", client->addr);
drivers/mfd/omap-usb-host.c:                     "USB HOST Rev:0x%d not recognized, assuming %d ports\n",
drivers/misc/sgi-gru/grumain.c: gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
drivers/net/ethernet/smsc/smc911x.c:    DBG(SMC_DEBUG_MISC, dev, "phy_id1=0x%x, phy_id2=0x%x phyaddr=0x%d\n",
drivers/net/wireless/ath/ath6kl/init.c:                            "found reserved ram size ie 0x%d\n",
drivers/net/wireless/ath/ath6kl/main.c:         ath6kl_err("failed to write 0x%x during diagnose window to 0x%d\n",
drivers/net/wireless/iwlegacy/4965-mac.c:                       IL_ERR("failed setting tx power (0x%d).\n", ret);
drivers/net/wireless/rtlwifi/pci.c:                              "more desc left, wake skb_queue@%d, ring->idx = %d, skb_queue_len = 0x%d\n",
drivers/net/wireless/rtlwifi/pci.c:                              "No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
drivers/net/wireless/rtlwifi/pci.c:                      "less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
drivers/net/wireless/rtlwifi/rtl8192de/phy.c:            "MCSTxPowerLevelOriginalOffset[%d][%d] = 0x%ulx\n",
drivers/net/wireless/rtlwifi/rtl8192de/phy.c:                   "ver 1 set RF-A, 5G,    0x28 = 0x%ulx !!\n", u4tmp);
drivers/net/wireless/rtlwifi/rtl8192de/phy.c:                   "ver 3 set RF-B, 2G, 0x28 = 0x%ulx !!\n", u4tmp);
drivers/net/wireless/rtlwifi/rtl8192de/phy.c:                   "ver 3 set RF-B, 2G, 0x28 = 0x%ulx !!\n",
drivers/parisc/dino.c:          printk(KERN_ERR "DINO: Hey! Someone took my MMIO space (0x%ld)!\n",
drivers/scsi/hpsa.c:    dev_info(dev, "   Max outstanding commands = 0x%d\n",
drivers/staging/nokia_h4p/nokia_core.c:         dev_err(info->dev, "Cannot get GPIO line 0x%d",
drivers/staging/rtl8192ee/pci.c:                                 ("more desc left, wake skb_queue@%d,ring->idx = %d, skb_queue_len = 0x%d\n",
drivers/staging/rtl8192ee/pci.c:                                 ("No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
drivers/staging/rtl8192ee/pci.c:                         ("less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
drivers/staging/rtl8821ae/pci.c:                                         "skb_queue_len = 0x%d\n",
drivers/staging/rtl8821ae/pci.c:                                  "idx = %d, skb_queue_len = 0x%d\n",
drivers/staging/rtl8821ae/pci.c:                          "idx = %d, skb_queue_len = 0x%d\n",
fs/cifs/cifs_debug.c:                                   "\n\tPathComponentMax: %d Status: 0x%d",
fs/cifs/misc.c:                 cifs_dbg(FYI, "notify err 0x%d\n",
fs/cifs/misc.c: cifs_dbg(FYI, "oplock type 0x%d level 0x%d\n",
fs/cifs/smb2misc.c:             cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
fs/cifs/smb2misc.c:             cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
fs/cifs/smb2misc.c:     cifs_dbg(FYI, "oplock level 0x%d\n", rsp->OplockLevel);
sound/firewire/fireworks/fireworks_proc.c:                          "phys in grp[0x%d]: type 0x%d, count 0x%d\n",
sound/firewire/fireworks/fireworks_proc.c:                          "phys out grps[0x%d]: type 0x%d, count 0x%d\n",
sound/pci/riptide/riptide.c:    snd_printdd("sent mixer %d: 0x%d 0x%d\n", num, rval, lval);
sound/pci/riptide/riptide.c:    snd_printdd("got mixer %d: 0x%d 0x%d\n", num, *rval, *lval);


