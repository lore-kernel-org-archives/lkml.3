Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105Ab3EBUSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:18:15 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:7079 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762086Ab3EBUSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:18:12 -0400
Message-ID: <1367525887.5106.140.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [GIT] Networking
From: Ben Hutchings <bhutchings@solarflare.com>
To: John Stoffel <john@stoffel.org>
CC: David Miller <davem@davemloft.net>, <bjorn@mork.no>, <kaber@trash.net>,
        <torvalds@linux-foundation.org>, <hayeswang@realtek.com>,
        <akpm@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 2 May 2013 21:18:07 +0100
In-Reply-To: <20866.46636.642215.768865@quad.stoffel.home>
References: <20130502.041625.412316202038784117.davem@davemloft.net>
	 <20130502083619.GA22010@macbook.localnet> <87d2t9bvj1.fsf@nemi.mork.no>
	 <20130502.140125.697030413654996310.davem@davemloft.net>
	 <20866.46636.642215.768865@quad.stoffel.home>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [86.14.226.88]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19834.005
X-TM-AS-Result: No--14.646900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 14:53 -0400, John Stoffel wrote:
> >>>>> "David" == David Miller <davem@davemloft.net> writes:
> 
> David> From: Bjørn Mork <bjorn@mork.no>
> David> Date: Thu, 02 May 2013 11:06:42 +0200
> 
> >> From d957cf339bf625869c39d852ac6733ef597ecef9 Mon Sep 17 00:00:00 2001
> >> From: Bjørn Mork <bjorn@mork.no>
> >> Date: Thu, 2 May 2013 10:37:05 +0200
> >> Subject: [PATCH] net: vlan,ethtool: netdev_features_t is more than 32 bit
> >> MIME-Version: 1.0
> >> Content-Type: text/plain; charset=UTF-8
> >> Content-Transfer-Encoding: 8bit
> >> 
> >> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> 
> David> Also applied and queued up for -stable.
> 
> David> These changes show me that this special type isn't providing type
> David> safety in the way that we actually need it.
> 
> David> Something like how we do the MM page table types would work better:
> 
> David> typedef struct { u64 val; } netdev_features_t;
> 
> David> #define __netdev_feature(X)	((netdev_features_t) { X } )
> 
> David> and also with the appropriate set of accessors.
> 
> David> Then you can't get it wrong without a compile error.
> 
> Isn't part of the problem that you're exporting it into /sys in a
> binary format?
[...]

Features are exported through SIOCETHTOOL, not sysfs (though they *used*
to be there).

The 'flags' attribue in sysfs is something different.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

