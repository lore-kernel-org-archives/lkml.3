Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbbAMF75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:59:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbbAMF7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:59:55 -0500
Date: Mon, 12 Jan 2015 19:42:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Krzysztof Adamski <k@japko.eu>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Use ether_addr_copy() on vnt_private
 members.
Message-ID: <20150113034212.GA16174@kroah.com>
References: <20141222161541.GA11764@box2.japko.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222161541.GA11764@box2.japko.eu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 05:15:41PM +0100, Krzysztof Adamski wrote:
> This patch fixes checkpatch.pl warning:
> WARNING: Prefer ether_addr_copy() over memcpy() if the Ethernet
> addresses are __aligned(2)
> 
> current_net_addr and permanent_net_addr members of vnt_private alignment
> is changed to at last 16 bits so that ether_addr_copy can be safely used
> on them.
> 
> buf->data is of type ieee80211_cts which is already properly aligned.
> 
> Signed-off-by: Krzysztof Adamski <k@japko.eu>
> ---
> drivers/staging/vt6656/device.h   |    4 ++--
> drivers/staging/vt6656/main_usb.c |    3 ++-
> drivers/staging/vt6656/rxtx.c     |    4 ++--
> 3 files changed, 6 insertions(+), 5 deletions(-)

Doesn't apply to my tree :(
