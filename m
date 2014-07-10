Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaGJVVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:21:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41437 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaGJVVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:21:00 -0400
Date: Thu, 10 Jul 2014 22:20:30 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Olivier Sobrie'" <olivier@sobrie.be>, David Miller <davem@davemloft.net>,
        "j.dumon@option.com" <j.dumon@option.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] hso: fix deadlock when receiving bursts of data
Message-ID: <20140710222030.0a194b1b@alan.etchedpixels.co.uk>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17270187@AcuExch.aculab.com>
References: <1404723967-24245-1-git-send-email-olivier@sobrie.be>
	<1404723967-24245-2-git-send-email-olivier@sobrie.be>
	<20140708.161633.2130069042930765600.davem@davemloft.net>
	<20140710142848.GA28056@hposo>
	<063D6719AE5E284EB5DD2968C1650D6D17270044@AcuExch.aculab.com>
	<20140710165003.0309924e@alan.etchedpixels.co.uk>
	<063D6719AE5E284EB5DD2968C1650D6D17270187@AcuExch.aculab.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You really want to apply flow control back over the 'serial' link.
> That may just cause data discards earlier on the local system.
> But it is possible that not resubmitting the receive urb will cause the
> modem to flow control back to the sender.
> In which case there is some chance that data won't be lost.

If you are doing PPP and you can't keep up the sooner you chuck data the
better. Flow control actually works against performance and good network
behaviour. It's counter intuitive but TCP/IP works best if any
performance bottlenecks are immediately visible and not covered over.

Alan
