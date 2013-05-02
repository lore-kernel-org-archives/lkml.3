Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679Ab3EBTGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:06:09 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:58401 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761236Ab3EBTGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:06:07 -0400
X-Greylist: delayed 734 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 May 2013 15:06:07 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20866.46636.642215.768865@quad.stoffel.home>
Date: Thu, 2 May 2013 14:53:32 -0400
From: "John Stoffel" <john@stoffel.org>
To: David Miller <davem@davemloft.net>
Cc: bjorn@mork.no, kaber@trash.net, torvalds@linux-foundation.org,
        hayeswang@realtek.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com
Subject: Re: [GIT] Networking
In-Reply-To: <20130502.140125.697030413654996310.davem@davemloft.net>
References: <20130502.041625.412316202038784117.davem@davemloft.net>
	<20130502083619.GA22010@macbook.localnet>
	<87d2t9bvj1.fsf@nemi.mork.no>
	<20130502.140125.697030413654996310.davem@davemloft.net>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "David" == David Miller <davem@davemloft.net> writes:

David> From: Bjørn Mork <bjorn@mork.no>
David> Date: Thu, 02 May 2013 11:06:42 +0200

>> From d957cf339bf625869c39d852ac6733ef597ecef9 Mon Sep 17 00:00:00 2001
>> From: Bjørn Mork <bjorn@mork.no>
>> Date: Thu, 2 May 2013 10:37:05 +0200
>> Subject: [PATCH] net: vlan,ethtool: netdev_features_t is more than 32 bit
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>> 
>> Signed-off-by: Bjørn Mork <bjorn@mork.no>

David> Also applied and queued up for -stable.

David> These changes show me that this special type isn't providing type
David> safety in the way that we actually need it.

David> Something like how we do the MM page table types would work better:

David> typedef struct { u64 val; } netdev_features_t;

David> #define __netdev_feature(X)	((netdev_features_t) { X } )

David> and also with the appropriate set of accessors.

David> Then you can't get it wrong without a compile error.

Isn't part of the problem that you're exporting it into /sys in a
binary format?  Why not just have each flag as it's own file and
value?  Sure, it's a waste in some ways, but then it makes it simpler
to just do an 'opendir()' to see if the flag exists, much less what
it's set to.

John
