Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3KWBra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:47:30 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:57045 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755857Ab3KWBr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:47:28 -0500
Date: Sat, 23 Nov 2013 09:47:17 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Alexander Graf <agraf@suse.de>
Cc: David Miller <davem@davemloft.net>, alexander.h.duyck@intel.com,
        netdev@vger.kernel.org, edumazet@google.com,
        herbert@gondor.hengli.com.au,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: gem csum breakage with 018c5bba (Handle CHECKSUM_COMPLETE more
 adequately ...)
Message-ID: <20131123014716.GA16661@gondor.apana.org.au>
References: <B8BCE323-6F65-4D14-BD4A-BFA07C3ED290@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8BCE323-6F65-4D14-BD4A-BFA07C3ED290@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 07:08:16PM +0100, Alexander Graf wrote:
> Hi,
> 
> With current Linus' master tree my ibook started emitting a lot of annoying csum calculation warnings. I've bisected it down to the commit seen in the subject line, but I suppose the real problem lies somewhere a lot deeper and only gets revealed thanks to the more clever checksum logic applied now.
> 
> Any ideas how to dig further into this?

Sorry, I don't have any docs on this device.  Perhaps Dave has
the docs which can tell us what RXDCTRL_TCPCSUM actually returns?

I assume it returns the correct checksum ending at the IP
packet boundary and only goes wrong when extra padding exists.

Hmm, I suppose the question then is what exactly does it do
if the packet isn't an IP packet?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
