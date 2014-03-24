Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaCXX3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 19:29:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45903 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaCXX3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 19:29:36 -0400
Date: Mon, 24 Mar 2014 19:29:32 -0400 (EDT)
Message-Id: <20140324.192932.881876462361283961.davem@davemloft.net>
To: avagin@openvz.org
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, edumazet@google.com, xemul@parallels.com,
        gorcunov@openvz.org
Subject: Re: [PATCH RFC 0/3] tcp: allow to repair a tcp connections in
 closing states
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395408781-8145-1-git-send-email-avagin@openvz.org>
References: <1395408781-8145-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Mar 2014 16:29:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Fri, 21 Mar 2014 17:32:58 +0400

> Currently connections only in the TCP_ESTABLISHED state can be dumped and
> restored. This series allows to restore connections in the FIN_WAIT_1,
> FIN_WAIT_2, LAST_ACK, CLOSE_WAIT or CLOSING states.
> 
> For restoring closing states we need an ability to restore a fin packet
> in a queue. In this series I suggest to use the interface of control
> messages for that.

I see no real value in this unless you tackle TIME_WAIT as well, and
that's going to add so much code.
