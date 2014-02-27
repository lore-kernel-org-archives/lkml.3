Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaB0WKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:10:41 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49044 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaB0WKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:10:40 -0500
X-IronPort-AV: E=Sophos;i="4.97,557,1389744000"; 
   d="scan'208";a="104828200"
Message-ID: <530FB7DD.6000500@citrix.com>
Date: Thu, 27 Feb 2014 22:10:37 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jesse Gross <jesse@nicira.com>, <pshelar@nicira.com>,
        <dev@openvswitch.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] openvswitch: Disable bottom half when grabbing stats
 lock in userspace context
References: <1393538677-21268-1-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1393538677-21268-1-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/14 22:04, Zoltan Kiss wrote:
> The megaflow feature introduced per-CPU stats, and the new code did some
> refactoring as well [1]. However the new functions doesn't disable bottom halves
> when locking the stat, and as they can be called from userspace context, they
> can be interrupted by netif_receive_skb.

Just forget about this, I'll send in soon the version with *_bh locks.

Zoli
