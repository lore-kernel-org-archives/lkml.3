Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaHEXpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:45:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60561 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaHEXpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:45:02 -0400
Date: Tue, 05 Aug 2014 16:45:00 -0700 (PDT)
Message-Id: <20140805.164500.1875405528479445448.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, Ian.Campbell@citrix.com,
        paul.durrant@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen-netfront: Fix handling packets on compound pages
 with skb_segment
From: David Miller <davem@davemloft.net>
In-Reply-To: <53E0D56E.7020205@citrix.com>
References: <20140803091110.GA7093@zion.uk.xensource.com>
	<20140804.152411.1486639478907964423.davem@davemloft.net>
	<53E0D56E.7020205@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Aug 2014 16:45:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Tue, 5 Aug 2014 14:00:30 +0100

> On 04/08/14 23:24, David Miller wrote:
>> Given what I've seen so far, I think the only option is to linearize
>> the packet.
> I think that would have more performance penalty than calling
> skb_gso_segment, but maybe I'm wrong.

We have firmly established that you cannot legally use GSO segmenting
as an option, so it doesn't matter if it's faster or not.
