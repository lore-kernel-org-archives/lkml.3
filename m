Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaGUESS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 00:18:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53134 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaGUESP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 00:18:15 -0400
Date: Sun, 20 Jul 2014 21:18:13 -0700 (PDT)
Message-Id: <20140720.211813.942862864883062133.davem@davemloft.net>
To: benoit.taine@lip6.fr
Cc: linux-pci@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        ath9k-devel@venema.h4ckr.net, linux-hippi@sunsite.dk,
        dri-devel@lists.freedesktop.org, linux-acenic@sunsite.dk,
        wil6210@qca.qualcomm.com, platform-driver-x86@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mips@linux-mips.org, users@rt2x00.serialmonkey.com,
        linux-rdma@vger.kernel.org, virtualization@lists.linux-foundation.org,
        industrypack-devel@lists.sourceforge.net, linux-can@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-crypto@vger.kernel.org,
        MPT-FusionLinux.pdl@avagotech.com, devel@linuxdriverproject.org,
        xen-devel@lists.xenproject.org, linux-pcmcia@lists.infradead.org,
        e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/25] Replace DEFINE_PCI_DEVICE_TABLE macro use
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Jul 2014 21:18:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Taine <benoit.taine@lip6.fr>
Date: Fri, 18 Jul 2014 17:26:47 +0200

> We should prefer `const struct pci_device_id` over
> `DEFINE_PCI_DEVICE_TABLE` to meet kernel coding style guidelines.
> This issue was reported by checkpatch.
> 
> A simplified version of the semantic patch that makes this change is as
> follows (http://coccinelle.lip6.fr/):
> 
> // <smpl>
> 
> @@
> identifier i;
> declarer name DEFINE_PCI_DEVICE_TABLE;
> initializer z;
> @@
> 
> - DEFINE_PCI_DEVICE_TABLE(i)
> + const struct pci_device_id i[]
> = z;
> 
> // </smpl>
> 
> I have 103 patches ready, and will only send a few for you to judge if
> it is useful enough, and to prevent from spamming too much.

I'm fine with this wrt. the networking changes, but I don't think this should
be merged via my tree.
