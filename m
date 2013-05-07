Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3EGJma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:42:30 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36998 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3EGJm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:42:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130507084241.GA1581@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	<20130506123805.GA1602@redhat.com>
	<20130506083759.556dac76@chukar.edge2.net>
	<20130506153044.GB1602@redhat.com>
	<1367854279.8434.13.camel@jlt4.sipsolutions.net>
	<1367855046.8434.16.camel@jlt4.sipsolutions.net>
	<20130507084241.GA1581@redhat.com>
Date: Tue, 7 May 2013 11:46:07 +0300
Message-ID: <CANUX_P1n=A1rxDYyuQH=azYiTtuz=q-mh3zZeu_30bRUHjVzSA@mail.gmail.com>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to 1672c0e3
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jake Edge <jake@lwn.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > > But if so, I would also see
>> > > the breakage on my setup, but I don't - it works quite well here.
>> >
>> > Are you testing on a passive channel? Try with a large beacon interval.
>>
>> I think most likely what happens is that it's on a passive channel, and
>> the firmware drops the TX packet with a bad status. Before the patch,
>> we'd just wait sitting on the channel for HZ/5 (200ms) before trying
>> again, with the patch we immediately retransmit the packet, which will
>> fail again and again until the firmware received a beacon.
>>
>> If you look at iwlwifi/dvm/, it has some passive_no_rx workaround for
>> this, which I don't see in iwlegacy.
>
> Can you explain why it is named passive_no_rx instead passive_no_tx ?

Well, it is basically - passive channel with no rx :-) This means we can't tx.

>> I think the best way to solve this would be to do such a thing in
>> iwlegacy as well, but until then and for stable maybe we should
>> introduce another HW flag to restore the previous mac80211 behaviour?
>
> I'm not sure if I like to add passive_no_rx to iwlegacy. Stopping queues
> and waiting for beacon looks sticky, what happen if beacon will not be
> received?
>
> Perhaps I will just remove IEEE80211_HW_REPORTS_TX_ACK_STATUS from 4965,
> it's simpler workaround ?
