Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaGNN2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:28:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45251 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbaGNN1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:27:54 -0400
Date: Mon, 14 Jul 2014 14:27:34 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Olivier Sobrie <olivier@sobrie.be>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Laight <David.Laight@ACULAB.COM>, Dan Williams <dcbw@redhat.com>,
        Jan Dumon <j.dumon@option.com>
Subject: Re: [PATCH v2 2/2] hso: fix deadlock when receiving bursts of data
Message-ID: <20140714142734.4b9c0afa@alan.etchedpixels.co.uk>
In-Reply-To: <1405332530-2507-2-git-send-email-olivier@sobrie.be>
References: <1405332530-2507-1-git-send-email-olivier@sobrie.be>
	<1405332530-2507-2-git-send-email-olivier@sobrie.be>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 12:08:50 +0200
Olivier Sobrie <olivier@sobrie.be> wrote:

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

Acked-by: Alan Cox <alan@linux.intel.com>
