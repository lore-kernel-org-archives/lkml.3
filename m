Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab3GWNuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:50:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38265 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab3GWNuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:50:17 -0400
Date: Tue, 23 Jul 2013 14:50:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Jean-Francois Moine <moinejf@free.fr>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v3] ARM: kirkwood: extend the kirkwood i2s
	driver for DT usage
Message-ID: <20130723135000.GW24642@n2100.arm.linux.org.uk>
References: <20130723104615.3696f1a9@armhf> <20130723123444.GW9858@sirena.org.uk> <51EE7E1A.3040301@gmail.com> <20130723132016.GC9858@sirena.org.uk> <51EE8591.7060005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EE8591.7060005@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 03:30:57PM +0200, Sebastian Hesselbarth wrote:
> On 07/23/13 15:20, Mark Brown wrote:
>>> again, we mentioned to merge kirkwood-i2s.c and kirkwood-dma.c into
>>> a single file, didn't we?
>>
>> That's been discussed several times but nobody's actually done it.
>
> Correct, that is why I repeated that request to Jean-Francois.

On that, I have some initial patches which start doing that, but I've
not had time to really complete the effort - the problem is working
with one tree (mainline) while testing on Rabeeh's kernel tree to get
a fully working Cubox platform is quite a hinderance.

Not only that, but the lack of assistance from ASoC people on the
multiple substream stuff really doesn't help one iota when it comes to
making forward progress with SPDIF support.  I've explained to them the
problem (SPDIF and I2S if used together must be enabled simultaneously
or only one is permitted at any one time); they've suggested using the
multiple PCM substream support, and then it's a case that "oh it's
undocumented" "oh there's no examples yet".

And then there's the problem of understanding the ASoC DAPM stuff
"oh it's just a graph walk, you don't need to know the internals"
is what I get from ASoC people.  Well, yes I do need to know the
internals, so I can find out whether it's going to startup a second
substream while a first one is active, and end up with SPDIF enabled
non-concurrently with I2S.
