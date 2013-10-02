Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3JBUdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:33:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49018 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3JBUdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:33:22 -0400
Date: Wed, 02 Oct 2013 16:33:19 -0400 (EDT)
Message-Id: <20131002.163319.1718353534049561226.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH 07/11] igb: Avoid uninitialized advertised variable in
 eee_set_cur
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380572952-30729-8-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
	<1380572952-30729-8-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 13:33:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon, 30 Sep 2013 13:29:08 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> eee_get_cur assumes that the output data is already zeroed. It can
> read-modify-write the advertised field:
> 
>               if (ipcnfg & E1000_IPCNFG_EEE_100M_AN)
> 2594			edata->advertised |= ADVERTISED_100baseT_Full;
> 
> This is ok for the normal ethtool eee_get call, which always
> zeroes the input data before.
> 
> But eee_set_cur also calls eee_get_cur and it did not zero the input
> field. Later on it then compares agsinst the field, which can contain partial
> stack garbage.
> 
> Zero the input field in eee_set_cur() too.
> 
> Cc: jeffrey.t.kirsher@intel.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Applied.
