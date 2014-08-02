Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbaHBWdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:33:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49678 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaHBWdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:33:38 -0400
Date: Sat, 02 Aug 2014 15:33:37 -0700 (PDT)
Message-Id: <20140802.153337.1399638752235662112.davem@davemloft.net>
To: wei.liu2@citrix.com
Cc: zoltan.kiss@citrix.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, Ian.Campbell@citrix.com,
        paul.durrant@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen-netfront: Fix handling packets on compound pages
 with skb_segment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140801110246.GB17947@zion.uk.xensource.com>
References: <1406726730-17994-1-git-send-email-zoltan.kiss@citrix.com>
	<20140731.132520.1889577477638334755.davem@davemloft.net>
	<20140801110246.GB17947@zion.uk.xensource.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 Aug 2014 15:33:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Liu <wei.liu2@citrix.com>
Date: Fri, 1 Aug 2014 12:02:46 +0100

> On Thu, Jul 31, 2014 at 01:25:20PM -0700, David Miller wrote:
>> If you were to have a 64-slot TX queue, you ought to be able to handle
>> this theoretical 51 slot SKB.
> 
> There's two problems:
> 1. IIRC a single page ring has 256 slots, allowing 64 slots packet
>    yields 4 in-flight packets in worst case.
> 2. Older netback could not handle this large number of slots and it's
>    likely to deem the frontend malicious.
> 
> For #1, we don't actually care that much if guest screws itself by
> generating 64 slot packets. #2 is more concerning.

How many slots can the older netback handle?
