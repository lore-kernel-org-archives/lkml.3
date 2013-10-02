Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3JBUd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:33:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49024 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3JBUd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:33:27 -0400
Date: Wed, 02 Oct 2013 16:33:26 -0400 (EDT)
Message-Id: <20131002.163326.2302966214580101265.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH 10/11] tcp: Always set options to 0 before calling
 tcp_established_options
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380572952-30729-11-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
	<1380572952-30729-11-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 13:33:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon, 30 Sep 2013 13:29:11 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> tcp_established_options assumes opts->options is 0 before calling,
> as it read modify writes it.
> 
> For the tcp_current_mss() case the opts structure is not zeroed,
> so this can be done with uninitialized values.
> 
> This is ok, because ->options is not read in this path.
> But it's still better to avoid the operation on the uninitialized
> field. This shuts up a static code analyzer, and presumably
> may help the optimizer.
> 
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Applied.
