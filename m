Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3GTKzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 06:55:38 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38790 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3GTKzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 06:55:37 -0400
MIME-Version: 1.0
In-Reply-To: <1374140806-12485-1-git-send-email-jonas.jensen@gmail.com>
References: <1374140806-12485-1-git-send-email-jonas.jensen@gmail.com>
Date: Sat, 20 Jul 2013 12:55:36 +0200
Message-ID: <CACmBeS0ztqKWJ1uLKhb2EZdexspTq5t0uHZfPotHiAPHfkftoA@mail.gmail.com>
Subject: Re: [PATCH] net: Add MOXA ART SoCs ethernet driver
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Jonas Jensen <jonas.jensen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this driver may have a bug.

After some time running ping successfully, the message "no TX space
for packet" is printed resulting in 100% packet loss.

The message is printed from .ndo_start_xmit and I think it may be
because of how priv->tx_desc_now is now set up in
moxart_mac_setup_desc_ring.

I will take a look at this and try to fix the issue.

Best regards,
Jonas
