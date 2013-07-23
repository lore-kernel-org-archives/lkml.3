Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab3GWNhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:37:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38255 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3GWNhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:37:11 -0400
Date: Tue, 23 Jul 2013 14:36:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Jean-Francois Moine <moinejf@free.fr>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [alsa-devel] [PATCH] ARM: kirkwood: enable S/PDIF
Message-ID: <20130723133655.GV24642@n2100.arm.linux.org.uk>
References: <20130723102320.56bc4555@armhf> <20130723084347.GP24642@n2100.arm.linux.org.uk> <20130723130622.GB9858@sirena.org.uk> <51EE8158.4050300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EE8158.4050300@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 03:12:56PM +0200, Sebastian Hesselbarth wrote:
> On 07/23/13 15:06, Mark Brown wrote:
>> On Tue, Jul 23, 2013 at 09:43:47AM +0100, Russell King - ARM Linux wrote:
>>> On Tue, Jul 23, 2013 at 10:23:20AM +0200, Jean-Francois Moine wrote:
>>>> This patch enables S/PDIF.
>>
>>>> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
>>
>>> I'm not submitting my patch to do this because:
>>
>>> (a) we don't know what effect this has on other hardware.
>>
>> This patch will do absolutely nothing unless it's used in a machine
>> driver which connects a S/PDIF CODEC to it.  I see no reason not to
>> apply it, someone with hardware with more complex needs can always build
>> on it later.
>>
>
> Mark,
>
> the mask that is changed in the patch is what will be written
> into i2s controller's registers. So, if there is no S/PDIF in that  
> specific controller that bit can possibly have a different meaning.
> Also, enabling both I2S playback and SPDIF playback can cause the
> controller to behave differently.

Right, so the SPDIF output on Dove isn't multiplexed, so I was wrong on
that _for_ _dove_, but that may not necessarily be the case for the
Kirkwood SoCs - the pin may be multiplexed there.

However, Dove does have two I2S/SPDIF controllers which are otherwise
identical, apart from one having SPDIF support and the other not.
Setting the SPDIF enable bit on the one without is unspecified what
the behaviour would be, so it should not be set.
