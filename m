Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaKHWMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 17:12:05 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:59306 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaKHWMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 17:12:03 -0500
Date: Sat, 8 Nov 2014 23:11:49 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] r8152: clear theflagofSCHEDULE_TASKLETin
 tasklet
Message-ID: <20141108221149.GA26030@electric-eye.fr.zoreil.com>
References: <1394712342-15778-75-Taiwan-albertk@realtek.com>
 <1394712342-15778-79-Taiwan-albertk@realtek.com>
 <1394712342-15778-81-Taiwan-albertk@realtek.com>
 <20141031.161520.3547230591227504.davem@davemloft.net>
 <0835B3720019904CB8F7AA43166CEEB2ECD8A7@RTITMBSV03.realtek.com.tw>
 <20141102225307.GA19900@electric-eye.fr.zoreil.com>
 <0835B3720019904CB8F7AA43166CEEB2ECDFC2@RTITMBSV03.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2ECDFC2@RTITMBSV03.realtek.com.tw>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
>  Francois Romieu [mailto:romieu@fr.zoreil.com] 
> > Sent: Monday, November 03, 2014 6:53 AM
> [...]
> > test_and_clear_bit (dense) or clear_bit would be more idiomatic.
> 
> Excuse me. Any suggestion?
> Should I use clear_bit directly, or something else?
> Or, do I have to remove this patch?

The performance explanation leaves me a bit unconvinced. Without any
figure one could simply go for the always locked clear_bit because of:
1. the "I'm racy" message that the open-coded test + set sends
2. the extra work needed to avoid 1 (comment, explain, ...).

The extra time could thus be used to see what happens when napi is
shoehorned in this tasklet machinery. I'd naively expect it to be
relevant for efficiency.

I won't mind if your agenda is completely different. :o)

-- 
Ueimor
