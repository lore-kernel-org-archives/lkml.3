Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab3HTADk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:03:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3HTADh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:03:37 -0400
Date: Mon, 19 Aug 2013 17:03:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tom Gundersen <teg@jklm.no>
Cc: stable@kernel.org, Linux Wireless List <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [REGRESSION] 3.10.{6,7} crashes on network activity
Message-ID: <20130820000336.GA15548@kroah.com>
References: <CAG-2HqUXQeq=30EpGWmn6tkC=CP1W+=UZCVPTYhhE0WyU_C4nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-2HqUXQeq=30EpGWmn6tkC=CP1W+=UZCVPTYhhE0WyU_C4nw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 07:59:47AM +0800, Tom Gundersen wrote:
> Hi guys,
> 
> Starting with 3.10.6 (and still present in .7) I get an oops on
> connecting to the network.
> 
> The attached picture shows the oops. In case it does not reach the ML,
> the top of the call trace reads:
> 
> brcms_c_compute_rtscts_dur
> brcms_c_ampdu_finalize
> ampdu_finalize
> dma_txfast
> brcms_c_txfifo
> brcms_c_sendpkt_mac80211
> brcms_ops_tx
> __ieee80211_tx
> 
> I bisected the problem and the first bad commit is
> 
> commit ef47a5e4f1aaf1d0e2e6875e34b2c9595897bef6
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Fri Jun 28 21:04:35 2013 +0200
> 
>     mac80211/minstrel_ht: fix cck rate sampling
> 
>     commit 1cd158573951f737fbc878a35cb5eb47bf9af3d5 upstream.
> 
> Reverting it on top of .7 fixes the problem.
> 
> I had the same (I suppose) problem on mainline some time ago, but I
> have not bisected it, verified that the problem still occurs there, or
> checked if reverting the upstream patch fixes it. I'd be happy to do
> that if it would help though.
> 
> Let me know if you need any more information.

Do you have this same problem with 3.11-rc6 as well?

thanks,

greg k-h
