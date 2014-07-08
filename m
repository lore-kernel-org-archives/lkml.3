Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaGHXQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:16:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54989 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaGHXQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:16:35 -0400
Date: Tue, 08 Jul 2014 16:16:33 -0700 (PDT)
Message-Id: <20140708.161633.2130069042930765600.davem@davemloft.net>
To: olivier@sobrie.be
Cc: j.dumon@option.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hso: fix deadlock when receiving bursts of data
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404723967-24245-2-git-send-email-olivier@sobrie.be>
References: <1404723967-24245-1-git-send-email-olivier@sobrie.be>
	<1404723967-24245-2-git-send-email-olivier@sobrie.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 16:16:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olivier Sobrie <olivier@sobrie.be>
Date: Mon,  7 Jul 2014 11:06:07 +0200

> When the module sends bursts of data, sometimes a deadlock happens in
> the hso driver when the tty buffer doesn't get the chance to be flushed
> quickly enough.
> 
> To avoid this, first, we remove the endless while loop in
> put_rx_bufdata() which is the root cause of the deadlock.
> Secondly, when there is no room anymore in the tty buffer, we set up a
> timer of 100 msecs to give a chance to the upper layer to flush the tty
> buffer and make room for new data.
> 
> Signed-off-by: Olivier Sobrie <olivier@sobrie.be>

I agree with the feedback you've been given in that adding a delay
like this is really not a reasonable solution.

Why is it so difficult to make the event which places the data there
trigger to necessary calls to pull the data out of the URB transfer
buffer?

This should be totally and completely event based.
