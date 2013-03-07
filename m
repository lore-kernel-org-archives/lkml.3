Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3CGWcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:32:12 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:42842 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3CGWcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:32:11 -0500
Message-ID: <5139155F.5050407@gmail.com>
Date: Thu, 07 Mar 2013 23:31:59 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Afzal Mohammed <afzal.mohd.ma@gmail.com>
CC: Fabio Estevam <festevam@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: Question about fixed-clock
References: <20130307184240.GA3327@afzal-ThinkPad-R50e>
In-Reply-To: <20130307184240.GA3327@afzal-ThinkPad-R50e>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Afzal,

thanks for looking into this.

On 07.03.2013 19:42, Afzal Mohammed wrote:
> On Tue, Feb 19, 2013 at 09:09:31AM +0530, Afzal Mohammed wrote:
> 
>> Hope invoking of_clk_init before clock generator driver helps
> 
> Mails coming from this id are in my personal capacity.
> 
> On Tue, Feb 19, 2013 at 10:53:18AM +0100, Daniel Mack wrote:
>> On 19.02.2013 02:33, Fabio Estevam wrote:
> 
>>> Have you registered it with clk_register_fixed_rate() ?
> 
>> Hmm no, I didn't do anything else than adding it to the DT in the first
>> place, hoping that a driver will pick it up and add the clock for me.
>> But it turns out that of_clk_init() is not called at all on my platform.
>>
>> I'm doing this now from omap_generic_init() and it works. If that's an
>> appropriate place to call it, I can provide a patch.
> 
> Initially didn't realize that it was for an am335x based one.
> 
> I feel that for a platform having it's clock tree in DT, of_clk_init
> would take care of it, but if clock tree data is not in DT, clock
> tree would have to be extended in a non-DT way.

Hmm, I don't follow. So for generic OMAP board in general which does
*not* have its SoC clocks in DT, the question is who's in charge of
registering out-of-SoC fixed clocks that are defined in DT.

Note that the clock I'm dealing with here is _outside_ of the SoC, and I
just need to have it in DT, so it can feed another clock chip's input pin.

Grep'ing through arch/arm, it seems that the imx arch does the same
thing my patch does, but I could also imagine that it should be done
somewhere from the DT core. I copied Grant, Rob and Mark for more comments.


Thanks,
Daniel

