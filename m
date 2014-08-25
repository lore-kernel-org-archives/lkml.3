Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaHYLy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:54:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35828 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932080AbaHYLy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:54:57 -0400
Date: Mon, 25 Aug 2014 13:54:54 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PWM: atmel: fix incorrect CDTY value after enabling or
 disabling
Message-ID: <20140825115454.GA2077@piout.net>
References: <1394823931-2815-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20140825101522.GA16960@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825101522.GA16960@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25/08/2014 at 12:15:23 +0200, Thierry Reding wrote :
> On Fri, Mar 14, 2014 at 08:05:31PM +0100, Alexandre Belloni wrote:
> > pwm-leds calls .config() and .disable() in a row. This exhibits that it may
> > happen that the channel gets disabled before CDTY has been updated with CUPD.
> > The issue gets quite worse with long periods.
> > So, ensure by reading ISR that at least one period has past before disabling the
> > channel.
> > 
> > The other issue is that it may happen that CUPD is not flushed before enabling
> > the channel so it will update CDTY/CPRD just after one period. So we always set
> > CUPD, even when the channel is not enabled.
> > 
> > Tested on at91sam9g45 and sama5d31ek.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> >  drivers/pwm/pwm-atmel.c | 46 +++++++++++++++++++++++++++++-----------------
> >  1 file changed, 29 insertions(+), 17 deletions(-)
> 
> going through the list of unapplied patches I came across this old
> patch. It was never reviewed nor acked by anyone and you didn't ping me,
> so I always assumed it must no longer be required. Is that so?
> 

It is still required but Nicolas is not happy with the polling on
PWM_ISR and he was supposed to discuss that internally with the IP
designer to understand if there is a better way.

I'll either ping on that one or send a new version when I'll know a bit
more.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
