Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab3C3MnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:43:08 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:33666 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3C3MnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:43:07 -0400
Date: Sat, 30 Mar 2013 13:42:56 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bowgotsai@google.com,
        "'Ryankao'" <ryankao@realtek.com>
Subject: Re: r8169 auto speed down issue
Message-ID: <20130330124256.GA19236@electric-eye.fr.zoreil.com>
References: <4EECA12DD88643FD9006350514D96C8E@realtek.com.tw>
 <20130328231955.GA26182@electric-eye.fr.zoreil.com>
 <83FC3118294143DC81063B29EF570FC1@realtek.com.tw>
 <20130329072056.GA31269@electric-eye.fr.zoreil.com>
 <555174DCA0B0431BB3AE9CCD464E5896@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555174DCA0B0431BB3AE9CCD464E5896@realtek.com.tw>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> :
[...]
> Sorry for my unclear descriptor. I just think a case that the nic suspends or
> shutdowns without cable plugging. Then, the cable is plugged again. If the nic
> speed down to 10M and the link partner force 100M, the issue appears again. If
> the nic doesn't speed down for normal link partner, it requires more power
> when the linking recovers.

Yes. The nic can not guess what the user values most: power saving in a
stable link layer configuration vs ability to detect and adapt to a yet
unseen configuration.

It could be a reason why EEE exists.

> Finally, I determine to set the speed to 10M when the link partner supports
> 10M. And for the other case, setting the speed to 100M. This avoids the giga
> nic to keep the speed to 1000M, and could fix this issue.
> However, I wonder if there is a switch which forces the speed to giga.

We can check if the partner supports 100M too. It's almost free and it will
avoid this problem.

-- 
Ueimor
