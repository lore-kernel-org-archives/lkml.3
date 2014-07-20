Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaGTTF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:05:27 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44573 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaGTTFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:05:25 -0400
Date: Sun, 20 Jul 2014 21:05:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: davem@davemloft.net, gregkh@linux-foundation.org, sachin.kamat@linaro.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: staging/8821ae driver breaks allyes build in 3.16-rc*
Message-ID: <20140720190523.GL18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I cannot build make allyesconfig in current Linus mainline, because 
drivers/staging/rtl8821ae has a lot of compile errors.

I tried to fix some, but it seems to be wide spread and sometimes
non obvious.

It may be related to the following series from Sachin,
however when just reverting those the driver gains some new
unrelated compile errors. It may be still a good idea
to revert those because the earlier errors are likely
easier to fix. Or just disable the driver until it at least
builds.

Please fix it in some way, allyesconfig should build!

fe6d68f staging: rtl8821ae: stats.c: Remove version specific code
2b4b5a6 staging: rtl8821ae: trx.h: Remove version specific code
e7f5a21 staging: rtl8821ae: trx.c: Remove version specific code
575e8da staging: rtl8821ae: sw.c: Remove version specific code
0c288d4 staging: rtl8821ae: regd.h: Remove version specific code
b9ddcee staging: rtl8821ae: regd.c: Remove version specific code
756a748 staging: rtl8821ae: rc.c: Remove version specific code
35722b4 staging: rtl8821ae: ps.c: Remove version specific code
aa59f7a staging: rtl8821ae: pci.h: Remove version specific code
c6e8a9e staging: rtl8821ae: pci.c: Remove version specific code
1939f35 staging: rtl8821ae: efuse.c: Remove version specific code
4874043 staging: rtl8821ae: debug.c: Remove version specific code
0cd05ba staging: rtl8821ae: core.c: Remove version specific code
4797740 staging: rtl8821ae: compat.h: Remove version specific code
80e3e09 staging: rtl8821ae: cam.c: Remove version specific code
8b292b0 staging: rtl8821ae: base.c: Remove version specific code

Errors with series reverted:

In file included from /home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/btcoexist/halbt_precomp.h:31:0,
                 from /home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c:21:
/home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/btcoexist/../pci.h:289:15: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘rtl_pci_probe’
 int __devinit rtl_pci_probe(struct pci_dev *pdev,
               ^
In file included from /home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/btcoexist/halbt_precomp.h:31:0,
                 from /home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/efuse.c:31:
/home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/btcoexist/../pci.h:289:15: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘rtl_pci_probe’
 int __devinit rtl_pci_probe(struct pci_dev *pdev,
               ^
make[3]: *** [drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.o] Error 1
  CC [M]  drivers/staging/rtl8821ae/rtl8821ae/table.o
In file included from /home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/btcoexist/halbt_precomp.h:31:0,
                 from /home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/btcoexist/rtl_btc.h:32,
                 from /home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/ps.c:36:
/home/ak/lsrc/git/linux-2.6/drivers/staging/rtl8821ae/btcoexist/../pci.h:289:15: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘rtl_pci_probe’
 int __devinit rtl_pci_probe(struct pci_dev *pdev,
               ^
make[3]: *** [drivers/staging/rtl8821ae/efuse.o] Error 1




Errors in mainline:


make[1]: Entering directory `/home/ak/lsrc/git/obj-allyes'
  CC [M]  drivers/staging//rtl8821ae/base.o
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/base.c: In function ‘rtl_send_smps_action’:
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/base.c:1455:3: warning: passing argument 2 of ‘rtlpriv->intf_ops->adapter_tx’ from incompatible pointer type [enabled by default]
   rtlpriv->intf_ops->adapter_tx(hw, sta, skb, &tcb_desc);
   ^
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/base.c:1455:3: note: expected ‘struct sk_buff *’ but argument is of type ‘struct ieee80211_sta *’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/base.c:1455:3: warning: passing argument 3 of ‘rtlpriv->intf_ops->adapter_tx’ from incompatible pointer type [enabled by default]
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/base.c:1455:3: note: expected ‘struct rtl_tcb_desc *’ but argument is of type ‘struct sk_buff *’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/base.c:1455:3: error: too many arguments to function ‘rtlpriv->intf_ops->adapter_tx’
make[4]: *** [drivers/staging//rtl8821ae/base.o] Error 1
  CC [M]  drivers/staging//rtl8821ae/core.o
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c: In function ‘rtl_op_tx’:
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c:107:2: warning: passing argument 2 of ‘rtlpriv->intf_ops->waitq_insert’ from incompatible pointer type [enabled by default]
  if (!rtlpriv->intf_ops->waitq_insert(hw, control->sta, skb))
  ^
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c:107:2: note: expected ‘struct sk_buff *’ but argument is of type ‘struct ieee80211_sta *’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c:107:2: error: too many arguments to function ‘rtlpriv->intf_ops->waitq_insert’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c:108:10: warning: passing argument 2 of ‘rtlpriv->intf_ops->adapter_tx’ from incompatible pointer type [enabled by default]
          rtlpriv->intf_ops->adapter_tx(hw, control->sta, skb, &tcb_desc);
          ^
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c:108:10: note: expected ‘struct sk_buff *’ but argument is of type ‘struct ieee80211_sta *’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c:108:10: warning: passing argument 3 of ‘rtlpriv->intf_ops->adapter_tx’ from incompatible pointer type [enabled by default]
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c:108:10: note: expected ‘struct rtl_tcb_desc *’ but argument is of type ‘struct sk_buff *’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c:108:10: error: too many arguments to function ‘rtlpriv->intf_ops->adapter_tx’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c: In function ‘rtl_op_flush’:
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/core.c:1288:3: error: too many arguments to function ‘rtlpriv->intf_ops->flush’
   rtlpriv->intf_ops->flush(hw, queues, drop);
   ^
make[4]: *** [drivers/staging//rtl8821ae/core.o] Error 1
  CC [M]  drivers/staging//rtl8821ae/pci.o
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c: In function ‘_rtl_pci_tx_chk_waitq’:
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:570:4: warning: passing argument 3 of ‘rtlpriv->intf_ops->adapter_tx’ from incompatible pointer type [enabled by default]
    rtlpriv->intf_ops->adapter_tx(hw, NULL, skb, &tcb_desc);
    ^
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:570:4: note: expected ‘struct rtl_tcb_desc *’ but argument is of type ‘struct sk_buff *’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:570:4: error: too many arguments to function ‘rtlpriv->intf_ops->adapter_tx’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c: In function ‘_rtl_pci_prepare_bcn_tasklet’:
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1156:6: warning: passing argument 7 of ‘rtlpriv->cfg->ops->fill_tx_desc’ makes integer from pointer without a cast [enabled by default]
      BEACON_QUEUE, &tcb_desc);
      ^
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1156:6: note: expected ‘u8’ but argument is of type ‘struct sk_buff *’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1156:6: warning: passing argument 8 of ‘rtlpriv->cfg->ops->fill_tx_desc’ makes pointer from integer without a cast [enabled by default]
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1156:6: note: expected ‘struct rtl_tcb_desc *’ but argument is of type ‘int’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1156:6: error: too many arguments to function ‘rtlpriv->cfg->ops->fill_tx_desc’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c: In function ‘rtl_pci_tx’:
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1693:6: warning: passing argument 6 of ‘rtlpriv->cfg->ops->fill_tx_desc’ from incompatible pointer type [enabled by default]
      hw_queue, ptcb_desc);
      ^
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1693:6: note: expected ‘struct sk_buff *’ but argument is of type ‘struct ieee80211_sta *’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1693:6: warning: passing argument 7 of ‘rtlpriv->cfg->ops->fill_tx_desc’ makes integer from pointer without a cast [enabled by default]
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1693:6: note: expected ‘u8’ but argument is of type ‘struct sk_buff *’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1693:6: warning: passing argument 8 of ‘rtlpriv->cfg->ops->fill_tx_desc’ makes pointer from integer without a cast [enabled by default]
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1693:6: note: expected ‘struct rtl_tcb_desc *’ but argument is of type ‘u8’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:1693:6: error: too many arguments to function ‘rtlpriv->cfg->ops->fill_tx_desc’
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c: At top level:
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:2422:2: warning: initialization from incompatible pointer type [enabled by default]
  .adapter_tx = rtl_pci_tx,
  ^
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:2422:2: warning: (near initialization for ‘rtl_pci_ops.adapter_tx’) [enabled by default]
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:2423:2: warning: initialization from incompatible pointer type [enabled by default]
  .flush = rtl_pci_flush,
  ^
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:2423:2: warning: (near initialization for ‘rtl_pci_ops.flush’) [enabled by default]
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:2425:2: warning: initialization from incompatible pointer type [enabled by default]
  .waitq_insert = rtl_pci_tx_chk_waitq_insert,
  ^
/home/ak/lsrc/git/linux-2.6/drivers/staging//rtl8821ae/pci.c:2425:2: warning: (near initialization for ‘rtl_pci_ops.waitq_insert’) [enabled by default]
make[4]: *** [drivers/staging//rtl8821ae/pci.o] Error 1
make[4]: Target `__build' not remade because of errors.
make[3]: *** [drivers/staging//rtl8821ae] Error 2
make[3]: Target `__build' not remade because of errors.
make[2]: *** [_module_drivers/staging/] Error 2
make[2]: Target `_all' not remade because of errors.
make[1]: *** [sub-make] Error 2
make[1]: Target `_all' not remade because of errors.
make: *** [__sub-make] Error 2

-- 
ak@linux.intel.com -- Speaking for myself only.
