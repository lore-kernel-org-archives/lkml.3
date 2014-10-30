Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422744AbaJ3XVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:21:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60687 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161351AbaJ3XVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:21:19 -0400
Date: Thu, 30 Oct 2014 19:21:15 -0400 (EDT)
Message-Id: <20141030.192115.918754566952396661.davem@davemloft.net>
To: nicolas.cavallari@green-communications.fr
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2] ipv4: Do not cache routing failures due to
 disabled forwarding.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414660193-4177-1-git-send-email-nicolas.cavallari@green-communications.fr>
References: <20141029.150328.530876391340346443.davem@davemloft.net>
	<1414660193-4177-1-git-send-email-nicolas.cavallari@green-communications.fr>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Oct 2014 16:21:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Date: Thu, 30 Oct 2014 10:09:53 +0100

> If we cache them, the kernel will reuse them, independently of
> whether forwarding is enabled or not.  Which means that if forwarding is
> disabled on the input interface where the first routing request comes
> from, then that unreachable result will be cached and reused for
> other interfaces, even if forwarding is enabled on them.  The opposite
> is also true.
> 
> This can be verified with two interfaces A and B and an output interface
> C, where B has forwarding enabled, but not A and trying
> ip route get $dst iif A from $src && ip route get $dst iif B from $src
> 
> Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
> Reviewed-by: Julian Anastasov <ja@ssi.bg>

Applied and queued up for -stable, thanks.
