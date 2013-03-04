Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab3CDP7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:59:53 -0500
Received: from mail.us.es ([193.147.175.20]:48755 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378Ab3CDP7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:59:51 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/16782. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-97.0/7.5):. 
 Processed in 1.933446 secs); 04 Mar 2013 15:59:49 -0000
X-Envelope-From: pneira@us.es
Date: Mon, 4 Mar 2013 16:59:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink: silence warning if
 CONFIG_PROVE_RCU isn't set
Message-ID: <20130304155946.GA25980@localhost>
References: <1362401141.16460.24.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1362401141.16460.24.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 01:45:41PM +0100, Paul Bolle wrote:
> Since commit c14b78e7decd0d1d5add6a4604feb8609fe920a9 ("netfilter:
> nfnetlink: add mutex per subsystem") building nefnetlink.o without
> CONFIG_PROVE_RCU set, triggers this GCC warning:
>     net/netfilter/nfnetlink.c:65:22: warning: ‘nfnl_get_lock’ defined but not used [-Wunused-function]
> 
> The cause of that warning is, in short, that rcu_lockdep_assert()
> compiles away if CONFIG_PROVE_RCU is not set. Silence this warning by
> open coding nfnl_get_lock() in the sole place it was called, which
> allows to remove that function.

Applied, thanks Paul.
