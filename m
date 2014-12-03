Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaLCGHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:07:43 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:63125 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLCGHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:07:41 -0500
Message-ID: <1417586858.5303.118.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next] r8152: reduce memory copy for rx
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Tue, 02 Dec 2014 22:07:38 -0800
In-Reply-To: <1394712342-15778-105-Taiwan-albertk@realtek.com>
References: <1394712342-15778-105-Taiwan-albertk@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 13:14 +0800, Hayes Wang wrote:
> If the data size is more than half of the AGG_BUG_SZ, allocate a new
> rx buffer and use skb_clone() to avoid the memory copy.
> 
> The original method is that allocate the memory and copy data for each
> packet in a rx buffer. The new one is that when the data size for a rx
> buffer is more than RX_THRESHOLD_CLONED, allocate a new rx buffer and
> use skb_clone for each packet in the rx buffer. According to the
> experiment, the new mothod has better performance.

Better performance for what workload exactly ?

cloning in rx path has many drawbacks, with skb->truesize being usually
wrong.



