Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab3BYKgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:36:14 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:42409 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498Ab3BYKgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:36:13 -0500
References: <20130222111521.GA25473@pd.tnic> <1361647210-12983-1-git-send-email-bp@alien8.de> <20130224112851.GA19609@pd.tnic> <cone.1361706175.908398.1806.1000@galar> <20130224120952.GB19609@pd.tnic> <1361761600.2303.12.camel@rzhang1-mobl4> <20130225102049.GA12067@pd.tnic>
Message-ID: <cone.1361788564.131747.30649.1000@mups>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Date: Mon, 25 Feb 2013 11:36:04 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry for not answering to earlier mails, but sitting in front of the 
computer and writing English mails is still very exhausting for me.


Borislav Petkov writes:

> On Mon, Feb 25, 2013 at 11:06:40AM +0800, Zhang Rui wrote:
>> when the temperature goes up to 50C, will the fan be turned on or not?
> 
> Right, let's first clarify this:
> 
> so we want the fan to go on when it reaches and/or exceeds the 'fanon'
> temperature and to go off after it goes under the 'fanoff' temperature.
> It is supposed to remain on in the [fanoff,fanon] interval.
> 
> Now, my observation from yesterday was that, if we don't do the
> flattening of the abovementioned interval in acerhdf_set_cur_state() but
> we simply turn on the fan if we receive state=1 and turn it off when
> state=0, the fan gets turned on only for short bursts when the governor
> decides it is time to throttle, i.e. the temperature in the zone is
> rising and turns it off when the temperature starts to fall again. And
> it would turn on the fan at lower temperatures than fanon.
> 
> But this is annoying. The main reason why this acerhdf thing was added
> in the first place was to do a better fan control on those machines
> because the fans are noisy. Basically, enable the fan only when really
> needed - and leave it off when not because it is really annoying.
> 
> When enabled, however, leave it on longer until a safe, 'fanoff'
> temperature is reached.
> 
> Am I making more sense now? Peter?

This sounds good, couldn't have stated it more clear. Just one thing to add 
here: This is standard idea of a "schmitt trigger", we implemented 
in acerhdf :)
http://en.wikipedia.org/wiki/Schmitt_trigger

-- 
kind regards,
--peter;
