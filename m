Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761161AbaGSKT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 06:19:57 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:50345 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760854AbaGSKTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 06:19:55 -0400
Date: Sat, 19 Jul 2014 12:19:46 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Ethan Zhao <ethan.zhao@oracle.com>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] netxen: fix ethtool rx_dropped information in ethtool
 get_ethtool_stats()
Message-ID: <20140719101946.GA4319@electric-eye.fr.zoreil.com>
References: <1405655009-18975-1-git-send-email-ethan.zhao@oracle.com>
 <C562D0E12CBDE44E8A0CCAB77060096701283AD344@AVMB1.qlogic.org>
 <049BCC6F-0A2E-421A-9873-0B7ED6FFB3AC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <049BCC6F-0A2E-421A-9873-0B7ED6FFB3AC@gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ethan Zhao <ethan.kernel@gmail.com> :
> ?? 2014??7??19????????2:21??Rajesh Borundia <rajesh.borundia@qlogic.com> ??????
[...]
> > I think ethtool stats are adapter specific. Driver does not maintain
> > rx_dropped stats and we also don't get it from adapter.  I am not
> > sure if ethtool stats should match ifconfig stats as ifconfig also
> > adds net core stats to adapter stats.
> I held the same point as yours before I read more drivers implementation
> under Ethernet dir, in fact there is no specification/convention that
> ethtool info is adapter specific. All information output by ethtool is
> based on the information name itself, one fact we want this patch is
> netxen defined 'rx dropped' field but output nothing.

It may be fine as a requirement of the day but it does not bode well
for the future as ethtool stats API won't get less messy.

I'd rather see ethtool stats provides one of those:
1. hardware stats only
2. driver dependent stats - anything you want - as long as the hardware
   only part of the stats is clearly identified

2. needs works. 1. hurts any requirement where it would priviously had
been so easy to add a few lines of code in the driver and push the mess
straight from kernel to the end user application.

-- 
Ueimor
