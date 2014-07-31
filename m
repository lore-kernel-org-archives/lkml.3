Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaGaQ47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:56:59 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:47557 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaGaQ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140723152649.GJ23210@lee--X1>
References: <1406055250-29159-1-git-send-email-jaswinder.singh@linaro.org>
	<1406055374-29275-1-git-send-email-jaswinder.singh@linaro.org>
	<20140723085411.GG23210@lee--X1>
	<CAJe_ZhfaLqgKb3oK-m5Rpae5+zeAEk9-DLFOovq4qjBgg64b-w@mail.gmail.com>
	<20140723152649.GJ23210@lee--X1>
Date: Thu, 31 Jul 2014 22:26:55 +0530
Message-ID: <CAJe_ZhcOXyGO49sZUXnqCk9wm7WvQ01b76k7Wqxxi1S3qisDPA@mail.gmail.com>
Subject: Re: [PATCHv9 2/4] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ijc@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, robh@kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>, "Anna, Suman" <s-anna@ti.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Mark Brown <broonie@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>, Andy Green <andy.green@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 July 2014 20:56, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 23 Jul 2014, Jassi Brar wrote:

>> >> +     if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
>> >> +             chan->txdone_method = TXDONE_BY_POLL;
>> >
>> > Unless you're leaving it there for clarity, you can drop the
>> > "TXDONE_BY_POLL |" from if().
>> >
>> We need to check for both.
>
> What I'm trying to get at is; if it's already TXDONE_BY_POLL, there is no
> need to set it to TXDONE_BY_POLL.
>
In mbox_request_channel() we added the ACK flag, if POLL was set and
now we need to revert that in mbox_free_channel().


Thanks
Jassi
