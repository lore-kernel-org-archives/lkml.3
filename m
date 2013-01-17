Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3AQXft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:35:49 -0500
Received: from mail.us.es ([193.147.175.20]:35378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab3AQXfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:35:47 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/16515. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-96.3/7.5):. 
 Processed in 1.687327 secs); 17 Jan 2013 23:35:45 -0000
X-Envelope-From: pneira@us.es
Date: Fri, 18 Jan 2013 00:35:39 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Gabor Juhos <juhosg@openwrt.org>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4] netfilter: nf_conntrack_sip: Handle Cisco 7941/7945
 IP phones
Message-ID: <20130117233539.GA15576@1984>
References: <1355805238-2460-1-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355805238-2460-1-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 08:33:58PM -0800, Kevin Cernekee wrote:
> Most SIP devices use a source port of 5060/udp on SIP requests, so the
> response automatically comes back to port 5060:
> 
>     phone_ip:5060 -> proxy_ip:5060   REGISTER
>     proxy_ip:5060 -> phone_ip:5060   100 Trying
> 
> The newer Cisco IP phones, however, use a randomly chosen high source
> port for the SIP request but expect the response on port 5060:
> 
>     phone_ip:49173 -> proxy_ip:5060  REGISTER
>     proxy_ip:5060 -> phone_ip:5060   100 Trying
> 
> Standard Linux NAT, with or without nf_nat_sip, will send the reply back
> to port 49173, not 5060:
> 
>     phone_ip:49173 -> proxy_ip:5060  REGISTER
>     proxy_ip:5060 -> phone_ip:49173  100 Trying
> 
> But the phone is not listening on 49173, so it will never see the reply.
> 
> This patch modifies nf_*_sip to work around this quirk by extracting
> the SIP response port from the Via: header, iff the source IP in the
> packet header matches the source IP in the SIP request.

Applied, thanks Kevin.
