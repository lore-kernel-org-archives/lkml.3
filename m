Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaCHGfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 01:35:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47490 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCHGez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 01:34:55 -0500
Date: Sat, 08 Mar 2014 01:34:51 -0500 (EST)
Message-Id: <20140308.013451.1713896236113364692.davem@davemloft.net>
To: sgrubb@redhat.com
Cc: eparis@redhat.com, ebiederm@xmission.com, rgb@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] audit: Simplify by assuming the callers socket
 buffer is large enough
From: David Miller <davem@davemloft.net>
In-Reply-To: <5147229.ivUnbSCGlH@x2>
References: <1394232722.17779.57.camel@flatline.rdu.redhat.com>
	<20140307.194801.1893514114998807038.davem@davemloft.net>
	<5147229.ivUnbSCGlH@x2>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Mar 2014 22:34:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Grubb <sgrubb@redhat.com>
Date: Fri, 07 Mar 2014 22:27:28 -0500

> On Friday, March 07, 2014 07:48:01 PM David Miller wrote:
>> From: Eric Paris <eparis@redhat.com>
>> Date: Fri, 07 Mar 2014 17:52:02 -0500
>> 
>> > Audit is non-tolerant to failure and loss.
>> 
>> Netlink is not a loss-less transport.
> 
> Perhaps. But in all our testing over the years its been very good.

What I really meant by that was that there is flow control.

You can push as much data reliably over it as you want, but you have
to block when the socket limits are hit.

And I'd say you might as well make the creator of the event do the
blocking rather than making other threads do this.
