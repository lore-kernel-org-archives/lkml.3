Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaBRX3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:29:00 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:60799 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaBRX26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:28:58 -0500
Date: Wed, 19 Feb 2014 00:28:50 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 12/14] r8152: replace netif_rx with
 netif_receive_skb
Message-ID: <20140218232850.GB13394@electric-eye.fr.zoreil.com>
References: <1392731351-25502-1-git-send-email-hayeswang@realtek.com>
 <1392731351-25502-13-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392731351-25502-13-git-send-email-hayeswang@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> Replace netif_rx with netif_receive_skb to avoid disabling irq frequently
> for increasing the efficiency.

read_bulk_callback is issued in irq context. It could thus use plain
spin_lock / spin_unlock instead of the irq disabling version.

-- 
Ueimor
