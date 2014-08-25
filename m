Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaHYHwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:52:42 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61058 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaHYHwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:52:41 -0400
Message-ID: <1408953158.8665.15.camel@umadbro>
Subject: Re: [PATCH] mac80211: Parse IEEE80211_RADIOTAP_RATE on TX
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 25 Aug 2014 09:52:38 +0200
In-Reply-To: <1405938028.32255.17.camel@jlt4.sipsolutions.net>
References: <1404995261-6626-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140710_142756_935664_A8B88F97) <1405938028.32255.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 12:20 +0200, Johannes Berg wrote:
> On Thu, 2014-07-10 at 14:27 +0200, Rostislav Lisovy wrote:
> > Add support for parsing radiotap field IEEE80211_RADIOTAP_RATE
> > for transmitted frames. Use the provided datarate value in
> > info->control.rates[] array so it will be used for transmission.
> > 
> > Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
> > ---
> > This feature is essential for Transmit Datarate Control (TDC)
> > in future implementation of IEEE 802.11-2012 "Wireless Access
> > for the Vehicular Environment" support.
> 
> It seems like an extremely bad idea to base your implementation of WAVE
> on monitor mode with injection.
> 
> Why can't you add a proper datapath?
> 

You are right. I was overthinking the per-packet datarate setting a
little bit.
If I am not mistaken it is not possible to say that this feature may be
useful as the general method for monitor-mode injection with datarate
until there is some user-space utility really using/needing it?

Best regards;
Rostislav


