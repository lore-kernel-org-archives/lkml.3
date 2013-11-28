Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab3K1EWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:22:20 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44948 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3K1EWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:22:19 -0500
Message-ID: <5296C57C.3010900@gmail.com>
Date: Thu, 28 Nov 2013 12:24:28 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: floe@butterbrot.org, rydberg@euromail.se,
        David Herrmann <dh.herrmann@gmail.com>, rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] drivers: input: touchscreen: sur40: use static variable
 instead of stack varialbe for 'packet_id'
References: <528AD6B3.1060507@gmail.com> <20131125011908.GA18921@codeaurora.org> <529555C5.7030404@gmail.com> <20131128040741.GD15452@core.coreip.homeip.net>
In-Reply-To: <20131128040741.GD15452@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2013 12:07 PM, Dmitry Torokhov wrote:
> Hi Chen,
> 
> On Wed, Nov 27, 2013 at 10:15:33AM +0800, Chen Gang wrote:
>> > 'packet_id' is used for checking sequence whether in order, it need be
>> > static variable independent from sur40_poll().
>> > 
>> > The related warning (with allmodconfig under hexagon):
>> > 
>> >   drivers/input/touchscreen/sur40.c: In function 'sur40_poll':
>> >   drivers/input/touchscreen/sur40.c:297:6: warning: 'packet_id' may be used uninitialized in this function [-Wuninitialized]
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> > ---
>> >  drivers/input/touchscreen/sur40.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> > 
>> > diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
>> > index cfd1b7e..5dfd01a 100644
>> > --- a/drivers/input/touchscreen/sur40.c
>> > +++ b/drivers/input/touchscreen/sur40.c
>> > @@ -251,7 +251,7 @@ static void sur40_poll(struct input_polled_dev *polldev)
>> >  	struct sur40_state *sur40 = polldev->private;
>> >  	struct input_dev *input = polldev->input;
>> >  	int result, bulk_read, need_blobs, packet_blobs, i;
>> > -	u32 packet_id;
>> > +	static u32 packet_id;
> It is usually not a good idea to use statics in device drivers as it
> does not work well when you have several devices of the same type
> present in a system. Also, we process all blobs in one pass so there is
> no need to preserve value of packet_id between calls to sur40_poll().

OK, thanks, I will/should send patch v2 for it.

-- 
Chen Gang
