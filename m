Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaHHF3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:29:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55651 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbaHHF3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:29:06 -0400
Date: Thu, 07 Aug 2014 22:29:05 -0700 (PDT)
Message-Id: <20140807.222905.354652678816300998.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, david.vrabel@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next 0/2] xen-netback: Changes around carrier
 handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <53E3AE21.50109@citrix.com>
References: <1407165658-20146-1-git-send-email-zoltan.kiss@citrix.com>
	<20140805.160748.1185917042908283028.davem@davemloft.net>
	<53E3AE21.50109@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Aug 2014 22:29:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Thu, 7 Aug 2014 17:49:37 +0100

> David Vrabel pointed out an important question in a reply to the
> previous version of this series: this patch deschedule NAPI if the
> carrier goes down. The backend doesn't receive packets from the
> guest. DavidVr and others said we shouldn't do this, the guest should
> be able to transmit even if it's not able/willing to receive. Other
> drivers doesn't deschedule NAPI at carrier off as well, however the
> "carrier off" information comes from the hardware, not from an
> untrusted guest who is not posting buffers on the receive ring.
> I don't have any good argument why I did it the current way, other
> than a hunch that it feels more natural.
> David, do you have an opinion on that?

Unless you have a strong reason for doing so, I don't think disabling
receives when the TX path backs up is necessary.
