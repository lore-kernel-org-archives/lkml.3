Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbaGOC2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 22:28:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37442 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaGOC17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 22:27:59 -0400
Date: Mon, 14 Jul 2014 19:27:58 -0700 (PDT)
Message-Id: <20140714.192758.1087918241017989929.davem@davemloft.net>
To: olivier@sobrie.be
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Laight@ACULAB.COM,
        gnomes@lxorguk.ukuu.org.uk, dcbw@redhat.com, j.dumon@option.com
Subject: Re: [PATCH v2 2/2] hso: fix deadlock when receiving bursts of data
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405332530-2507-2-git-send-email-olivier@sobrie.be>
References: <1405332530-2507-1-git-send-email-olivier@sobrie.be>
	<1405332530-2507-2-git-send-email-olivier@sobrie.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Jul 2014 19:27:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olivier Sobrie <olivier@sobrie.be>
Date: Mon, 14 Jul 2014 12:08:50 +0200

> When the module sends bursts of data, sometimes a deadlock happens in
> the hso driver when the tty buffer doesn't get the chance to be flushed
> quickly enough.
> 
> Remove the endless while loop in function put_rxbuf_data() which is
> called by the urb completion handler.
> If there isn't enough room in the tty buffer, discards all the data
> received in the URB.
> 
> Cc: David Miller <davem@davemloft.net>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: Jan Dumon <j.dumon@option.com>
> Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
> ---
> Changes in v2:
>  - remove the unthrottle timer added in the previous patch version
>  - drop entire rx urb data if there is not enough space in tty buffer
>  - remove variable curr_rx_urb_offset from hso_serial structure

Applied, thanks.
