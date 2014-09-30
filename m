Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaI3LqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:46:10 -0400
Received: from mail.us.es ([193.147.175.20]:60196 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaI3LqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:46:07 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19454. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-97.8/7.5):. 
 Processed in 2.175644 secs); 30 Sep 2014 11:46:04 -0000
X-Spam-ASN: AS12715 87.221.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 30 Sep 2014 13:47:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: netdev@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: fix nf_conn_nat->masq_index visibility
Message-ID: <20140930114716.GA21568@salvia>
References: <2670668.vq09CjLWH3@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2670668.vq09CjLWH3@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 01:27:50PM +0200, Arnd Bergmann wrote:
> A recent change introduced the NF_NAT_MASQUERADE_IPV4/6 symbols and now
> builds the masquerading code based on this symbol rather than the
> IP_NF_TARGET_MASQUERADE symbol, however the nf_nat.h header file
> still uses the old symbol, which leads to a build error when that
> is disabled:
> 
> nf_nat_masquerade_ipv4.c: In function 'nf_nat_masquerade_ipv4':
> nf_nat_masquerade_ipv4.c:59:5: error: 'struct nf_conn_nat' has no member named 'masq_index'
> 
> This changes the header file to do the respective change, and move
> to using the IS_ENABLED() macro in the process, to improve readability
> of the check

David pulled a patch to resolve this yesterday:

http://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=67981fefb20e717cea55b42f9081a833fa46b3be

Thanks anyway.
