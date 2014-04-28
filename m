Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaD1J35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:29:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60058 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaD1J3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:29:54 -0400
Date: Mon, 28 Apr 2014 10:29:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Mark Brown <broonie@kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] mfd: bcm590xx: add support for second i2c slave
 address space
Message-ID: <20140428092947.GN6264@lee--X1>
References: <1397501428-8857-1-git-send-email-mporter@linaro.org>
 <1397501428-8857-3-git-send-email-mporter@linaro.org>
 <20140416110603.GA19671@lee--X1>
 <20140416213141.GD12304@sirena.org.uk>
 <20140417065753.GC28725@lee--X1>
 <20140417222616.GK23695@beef>
 <20140422082139.GF17657@lee--X1>
 <20140423220126.GC4164@beef>
 <20140423220500.GA1127@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140423220500.GA1127@beef>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > > > s/regmap/Regmap
> > > > > > 
> > > > > > It's consistently written regmap in all the documentation and so on :)
> > > > > 
> > > > > Furry muff; but the comments still stand for the acronyms.
> > > > > 
> > > > > > > addmap{0,1} doesn't quite sit right with me.
> > > > > > 
> > > > > > > REVISIT: Ah, it's address-map, rather than add map. Okay, not as bad
> > > > > > > as I first thought, but still, is there a better naming convention you
> > > > > > > could use?
> > > > > > 
> > > > > > addrmap or something?
> > > > > 
> > > > > Right, that was what I was thinking. However, I prefer something along
> > > > > the lines of 'i2c' and 'i2c_sec' or 'client' and 'client_slv' etc.
> > > > 
> > > > FWIW, the reason it's addmap{0,1} is that the datasheet has documents
> > > > ADDMAP=0 and the first bank of registers and ADDMAP=1 as the second bank
> > > > of registers. I adopted that to match the docs for the part.
> > > > 
> > > > I guess we could do i2c and i2c_sec, I'll just have to put a comment
> > > > correlating it to the h/w. Calling it 'slv' implies something else
> > > > so we should avoid that here. The notion of a "secondary" i2c device
> > > > is completely a Linux I2C subsystem fabrication which wouldn't exist
> > > > if it allowed multiple slave addresses per device. From a h/w
> > > > perspective there is really no primary and secondary relationship.
> > > > 
> > > > I'm fine with i2c/i2c_sec or addrmap0/1 and I will just comment to
> > > > correlate with the datasheet..pick one.
> > > 
> > > Let's stick method fabricated by the I2C subsystem. It may seem strange
> > > from a h/w perspective, but it is the way we (you) have coded it, as
> > > the first parameter of i2c_new_dummy() is the 'managing' (primary,
> > > parent, master, whatever) device, so '_sec' would suit as an
> > > identifying appendage for the resultant device.
> > 
> > That works, I'll also switch to addrmap_[pri|sec] which touches the
> > regulator driver as well. That will keep the relationship  between device
> > and regmap clear.
> 
> Misspoke...I'm switching regmap[0|1] to regmap_[pri|sec] to keep that
> synced with i2c_[pri|sec]

Sounds good, thanks Matt.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
