Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162770Ab3DEVUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:20:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43534 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162366Ab3DEVU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:20:29 -0400
X-Sasl-enc: uzCNqnQz9nUUeJUqEy4vJPiZOOozTTVXFJwrLSQjgSoa 1365196828
Message-ID: <515F4017.6060404@signal11.us>
Date: Fri, 05 Apr 2013 17:20:23 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Werner Almesberger <werner@almesberger.net>
CC: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-zigbee-devel@lists.sourceforge.net
Subject: Re: [Linux-zigbee-devel] [PATCH] mac802154: Keep track of the channel
 when changed
References: <1365194201-2635-1-git-send-email-alan@signal11.us> <20130405210514.GF28141@ws>
In-Reply-To: <20130405210514.GF28141@ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 05:05 PM, Werner Almesberger wrote:
> Alan Ott wrote:
>> Prevent set_channel() from getting called every time a packet is sent. This
>> looks like it was an oversight.
> at86rf230.c and derivatives avoid this problem by setting
> phy->current_* in the *_channel function.
>
> But I'd agree that it's nicer to do this in one place, not in
> every driver.
>
> In case a driver had a weird failure mode in which it leaves the
> original channel but only makes it halfway to the new channel, it
> could still set phy->current_* and return an error. So there's no
> loss of functionality with your change.

Hmm... I just noticed that mib.c does the same thing (and doesn't set
phy->current_*). I'll need to fix that one too (and resubmit). :(

Alan.



