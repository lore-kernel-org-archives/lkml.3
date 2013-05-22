Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3EVCED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:04:03 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38310 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003Ab3EVCEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:04:00 -0400
X-Sasl-enc: J68wZYYsNRBhRI5+3eX3aAP/H/gDsq6bxTCj4YCn1Iqi 1369188236
Message-ID: <519C278F.5030809@signal11.us>
Date: Tue, 21 May 2013 22:03:59 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: david@hauweele.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net
Subject: Re: [PATCH beta 1] 0/3] Fix race conditions in mrf24j40 interrupts
References: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com> <1369188080-8904-1-git-send-email-alan@signal11.us>
In-Reply-To: <1369188080-8904-1-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 10:01 PM, Alan Ott wrote:
> David Hauweele noticed that the mrf24j40 would hang arbitrarily after some
> period of heavy traffic.  Two race conditions were discovered, and the
> driver was changed to use threaded interrupts, since the enable/disable of
> interrupts in the driver has recently been a lighning rod whenever issues
> arise related to interrupts (costing engineering time), and since threaded
> interrupts are the right way to do it.
>
> Alan Ott (3):
>   mrf24j40: Move INIT_COMPLETION() to before packet transmission
>   mrf24j40: Use threaded IRQ handler
>   mrf24j40: Use level-triggered interrupts
>
>  drivers/net/ieee802154/mrf24j40.c | 31 +++++++++----------------------
>  1 file changed, 9 insertions(+), 22 deletions(-)

I forgot to add, I ran ping -f both ways all afternoon (6.5 hours), and
it seems solid.

