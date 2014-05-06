Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbaEFDLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:11:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35926 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:11:23 -0400
Date: Mon, 05 May 2014 23:11:21 -0400 (EDT)
Message-Id: <20140505.231121.1210034371289454749.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 06/24] net, diet: Use small UDP hash tables on small
 kernels
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-7-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-7-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:11:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:25:55 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> UDP has two hash tables, for UDP and UDP lite. Default
> them to 16 entries each on small kernels. This can be
> still overriden on the command line.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Likewise, if you make it too small, overrunning the machine
is way too easy.  Maybe it's even more important in a lower
powered machine than a high powered one.
