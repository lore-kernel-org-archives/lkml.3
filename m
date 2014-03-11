Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaCKW2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:28:11 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41184 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaCKW2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:28:09 -0400
Date: Tue, 11 Mar 2014 23:28:02 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix the incorrect tx descriptor version
Message-ID: <20140311222802.GA17770@electric-eye.fr.zoreil.com>
References: <1394521919-4257-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394521919-4257-1-git-send-email-hayeswang@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> The tx descriptor version of RTL8111B belong to RTL_TD_0.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Acked-by: Francois Romieu <romieu@fr.zoreil.com>

All 8168b chipsets should had shared the same Tx descriptor layout.

2b7b431858c284b62c18baaf2cea571be2797d5a ("r8169: TSO fixes.") got it
right but it was broken after a couple of weeks by
d58d46b5d85139d18eb939aa7279c160bab70484 ("r8169: jumbo fixes") in 2011:
[...]
 	[RTL_GIGA_MAC_VER_17] =
-		_R("RTL8168b/8111b",	RTL_TD_0, NULL),
+		_R("RTL8168b/8111b",	RTL_TD_1, NULL, JUMBO_4K, false),
 	[RTL_GIGA_MAC_VER_18] =

Oops.

-- 
Ueimor
