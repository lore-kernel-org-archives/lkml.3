Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaEEThe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:37:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaEEThd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:37:33 -0400
Date: Mon, 05 May 2014 15:37:31 -0400 (EDT)
Message-Id: <20140505.153731.953697715071354770.davem@davemloft.net>
To: alchark@gmail.com
Cc: rl@hellgate.ch, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Re: [PATCH] net: via-rhine: Convert #ifdef USE_MMIO to a runtime
 flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399120853-26967-1-git-send-email-alchark@gmail.com>
References: <20140502.155635.1691085402453175737.davem@davemloft.net>
	<1399120853-26967-1-git-send-email-alchark@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 12:37:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Charkov <alchark@gmail.com>
Date: Sat,  3 May 2014 16:40:53 +0400

> This introduces another flag in 'quirks' to replace the preprocessor
> define (USE_MMIO) used to indicate whether the device needs a
> separate enable routine to operate in MMIO mode.
> 
> All of the currently known platform Rhine cores operate in MMIO
> mode by default, and on PCI it is preferred over PIO for performance
> reasons. However, a comment in code suggests that some (?) early
> Rhine cores only work in PIO mode, so they should not be switched
> to MMIO.
> 
> Enabling MMIO on PCI is still triggered by the same Kconfig option
> to avoid breaking user configs needlessly, but this can be changed
> going forward towards automatic runtime detection in case a list of
> PIO-only Rhine revisions can be compiled.
> 
> This also fixes a couple of compiler warnings detected by Fengguang
> Wu's test bot (!USE_MMIO case):
 ...
> Signed-off-by: Alexey Charkov <alchark@gmail.com>

Applied, but in the future please make it clear what tree you are
targetting by saying "[PATCH net]" or "[PATCH net-next]" in your
subject line.

Thanks.
