Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaE1Pud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:50:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49125 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaE1Puc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:50:32 -0400
Message-ID: <538605B7.50209@ti.com>
Date: Wed, 28 May 2014 10:50:15 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jassi Brar <jassisinghbrar@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>, Girish K S <ks.giri@samsung.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>	<1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>	<20140521172701.GV12304@sirena.org.uk> <CABb+yY0G9Rn4mzA7Cn4__tR02WE4Q6-RQfQ06U6Kiiayey+RXA@mail.gmail.com>
In-Reply-To: <CABb+yY0G9Rn4mzA7Cn4__tR02WE4Q6-RQfQ06U6Kiiayey+RXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 11:20 PM, Jassi Brar wrote:
> On Wed, May 21, 2014 at 10:57 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Thu, May 15, 2014 at 11:41:00AM +0530, Jassi Brar wrote:
>>> Introduce common framework for client/protocol drivers and
>>> controller drivers of Inter-Processor-Communication (IPC).
>>
>> This looks pretty nice, though I do have a few *very* small nits beyond
>> those Arnd had.
>>
>>> +     if (chan->cl->tx_block && chan->active_req) {
>>> +             int ret;
>>> +             init_completion(&chan->tx_complete);
>>
>> reinit_completion().
>>
>>> +     if (!cl->tx_tout) /* wait for ever */
>>> +             cl->tx_tout = msecs_to_jiffies(3600000);
>>> +     else
>>> +             cl->tx_tout = msecs_to_jiffies(cl->tx_tout);
>>
>> Is the default wait for ever the best timeout - I'm not sure it's best
>> from a defensiveness point of view.  It should be fine either way,
>> it's just a matter of taste.
>>
> The client wants the call to be blocking. Out of 'zero', 'infinity'
> and some 'valid' delay, it makes better sense to have 'infinity' than
> zero or another value that might be valid for some platform. I assume
> 1hr to be 'infinity', though I am open to better suggestions. Maybe
> put a WARN() ?
> 
> 
>>> +     ret = chan->mbox->ops->startup(chan);
>>> +     if (ret) {
>>> +             pr_err("Unable to startup the chan\n");
>>
>> Perhaps print the error codes?  Might be helpful to users.
>>
> OK.
> 
> 
> BTW, I have not converted Highbank's PL320 and OMAP's controller and
> client drivers. I believe Highbank's can't be converted to DT now and
> Suman would want to convert the OMAP himself.

Yes, I will get to this next week, especially as there are new SoCs like
DRA7 and AM437x that need special handling.

regards,
Suman




> 
> Also, maybe mailbox patches could be upstreamed via, say, arm-soc tree?
> 
> Regards,
> Jassi
> 

