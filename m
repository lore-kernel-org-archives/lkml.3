Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab3GWNND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:13:03 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61907 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3GWNNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:13:01 -0400
Message-ID: <51EE8158.4050300@gmail.com>
Date: Tue, 23 Jul 2013 15:12:56 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [alsa-devel] [PATCH] ARM: kirkwood: enable S/PDIF
References: <20130723102320.56bc4555@armhf> <20130723084347.GP24642@n2100.arm.linux.org.uk> <20130723130622.GB9858@sirena.org.uk>
In-Reply-To: <20130723130622.GB9858@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/13 15:06, Mark Brown wrote:
> On Tue, Jul 23, 2013 at 09:43:47AM +0100, Russell King - ARM Linux wrote:
>> On Tue, Jul 23, 2013 at 10:23:20AM +0200, Jean-Francois Moine wrote:
>>> This patch enables S/PDIF.
>
>>> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
>
>> I'm not submitting my patch to do this because:
>
>> (a) we don't know what effect this has on other hardware.
>
> This patch will do absolutely nothing unless it's used in a machine
> driver which connects a S/PDIF CODEC to it.  I see no reason not to
> apply it, someone with hardware with more complex needs can always build
> on it later.
>

Mark,

the mask that is changed in the patch is what will be written
into i2s controller's registers. So, if there is no S/PDIF in that 
specific controller that bit can possibly have a different meaning.
Also, enabling both I2S playback and SPDIF playback can cause the
controller to behave differently.

I share Russell's concern about it and would rather like to use
multiple codecs per DAI (DPCM) for that. I see Daniel Mack picked
that up again, maybe he submits something soon.

Sebastian
