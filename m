Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab3LFRpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:45:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40657 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3LFRpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:45:01 -0500
Date: Fri, 06 Dec 2013 12:45:00 -0500 (EST)
Message-Id: <20131206.124500.1976272290413710707.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] tun: update file current position
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386320930-11285-2-git-send-email-zwu.kernel@gmail.com>
References: <1386320930-11285-1-git-send-email-zwu.kernel@gmail.com>
	<1386320930-11285-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 09:45:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Fri,  6 Dec 2013 17:08:50 +0800

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Also applied and queued up for -stable, thanks.

I noticed in these two cases that that min_t() adjustment of 'ret'
seems strange.  I can't understand why it's needed.

If, for example, tun_do_read() really did read more than 'len'
bytes:

1) That would write past the end of the buffer.

2) Writing a different value to the ->ki_pos would mean
   that ->ki_pos is now inaccurate.

Unless someone can explain why the min_t() is needed, we should remove
it.
