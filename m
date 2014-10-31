Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbaJaURV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:17:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43282 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692AbaJaURT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:17:19 -0400
Date: Fri, 31 Oct 2014 16:17:17 -0400 (EDT)
Message-Id: <20141031.161717.851599743414417317.davem@davemloft.net>
To: lsorense@csclub.uwaterloo.ca
Cc: linux-kernel@vger.kernel.org, mugunthanvnm@ti.com, netdev@vger.kernel.org
Subject: Re: drivers: net: cpsw: Support ALLMULTI and fix IFF_PROMISC in
 switch mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141031173852.GK24110@csclub.uwaterloo.ca>
References: <20141031173852.GK24110@csclub.uwaterloo.ca>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Oct 2014 13:17:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 31 Oct 2014 13:38:52 -0400

> The cpsw driver did not support the IFF_ALLMULTI flag which makes dynamic
> multicast routing not work.  Related to this, when enabling IFF_PROMISC
> in switch mode, all registered multicast addresses are flushed, resulting
> in only broadcast and unicast traffic being received.
> 
> A new cpsw_ale_set_allmulti function now scans through the ALE entry
> table and adds/removes the host port from the unregistered multicast
> port mask of each vlan entry depending on the state of IFF_ALLMULTI.
> In promiscious mode, cpsw_ale_set_allmulti is used to force reception
> of all multicast traffic in addition to the unicast and broadcast traffic.
> 
> With this change dynamic multicast and promiscious mode both work in
> switch mode.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

Applied.
