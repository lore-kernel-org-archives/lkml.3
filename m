Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbbABVgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:36:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53768 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbABVgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:36:03 -0500
Date: Fri, 02 Jan 2015 16:35:58 -0500 (EST)
Message-Id: <20150102.163558.1139468085145968126.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: akpm@linux-foundation.org, w-lkml@lebenslange-mailadresse.de,
        ebiederm@xmission.com, benoit.taine@lip6.fr, Julia.Lawall@lip6.fr,
        manuel.schoelling@gmx.de, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: micrel: ksz884x.c: Remove some unused
 functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420131623-30749-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420131623-30749-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Jan 2015 13:36:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu,  1 Jan 2015 18:00:23 +0100

> Removes some functions that are not used anywhere:
> hw_w_phy_link_md() hw_r_phy_link_md() hw_w_phy_polarity()
> hw_r_phy_polarity() hw_w_phy_crossover() hw_r_phy_crossover()
> hw_r_phy_rem_cap() hw_w_phy_auto_neg() hw_r_phy_auto_neg()
> hw_r_phy_link_stat() sw_get_addr() port_chk_prio() port_chk_replace_vid()
> port_chk_802_1p() port_chk_diffserv() sw_chk_unk_def_port()
> sw_cfg_unk_def_port() sw_cfg_chk_unk_def_deliver() sw_cfg_unk_def_deliver()
> port_chk_in_filter() port_chk_dis_non_vid() port_cfg_in_filter()
> port_cfg_dis_non_vid() port_chk_rmv_tag() port_chk_ins_tag()
> port_cfg_rmv_tag() port_cfg_ins_tag() sw_flush_dyn_mac_table() port_cfg_tx()
> port_cfg_rx() port_chk_force_flow_ctrl() port_chk_back_pressure()
> port_cfg_force_flow_ctrl() port_chk_broad_storm() hw_ena_intr_bit()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

This causes a cascade of new warnings because now functions like
phy_chk() are unused in some configurations.

I'm really not thrilled to even review change from you of this nature
if you aren't going to be careful about attending to details like
that.

Just blindly removing functions and not looking at the context or
other potential side effects is not really acceptable.
