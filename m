Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaL2Rhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:37:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39563 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaL2Rhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:37:48 -0500
Message-ID: <54A19151.3090506@ti.com>
Date: Mon, 29 Dec 2014 19:37:21 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jean-Francois Moine <moinejf@free.fr>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] ASoC: tda998x: add a codec to the HDMI transmitter
References: <cover.1414053169.git.moinejf@free.fr> <20141229165246.GZ17800@sirena.org.uk>
In-Reply-To: <20141229165246.GZ17800@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 06:52 PM, Mark Brown wrote:
> On Thu, Oct 23, 2014 at 10:32:49AM +0200, Jean-Francois Moine wrote:
>> The NXP TDA998x HDMI transmitter may transmit audio to the HDMI link
>> from 2 different sources, I2S and S/PDIF.
>
> So, I'm not seeing *any* interest here from any other HDMI users.  This
> is a continuing theme with HDMI patches and is really very concerning,
> everyone appears to be working in their own bubbles coming up with their
> own things and ignoring everyone else's work - what little review I'm
> seeing seems to be happening only after I explicitly prompt it.  I'm
> following up to Jean-Francois' patches here but this isn't specific to
> them, it seems like a general thing with HDMI code.
>
> This in turn makes me think there's some abstraction problems with
> what's going on and we're going to have to go through yet more
> refactorings to fix things up as we do manage to come up with better
> abstractions.  What I'd really like to see as a bare minimum is some
> visible conversation about what we're doing and sign that people are
> at least keeping in mind generic solutions when working on HDMI code.
> Some commentary on the similarities and differences between hardware
> and which abstractions work with which devices would also be really
> helpful in working out if we're going in the right direction.
>
> Basically at the minute I'm worried that we may be making the problems
> we've got here worse not better, I've not personally had the time to sit
> down and study the hardware sufficiently to form a firm impression
> myself which isn't helping.
>

I have not seen any significant new development since v7 of these 
patches. My comments for v6 were mostly[1] addressed and I can live with 
these changes, even develop this approach further if it gets merged.

However, as a general note I see a need for a generic ASoC hdmi codec 
abstraction and I don't think this is generic enough. More of the audio 
specific implementation and HDMI standard specific things should be 
pushed away from the hdmi encoder driver (tda998x in this case) to the 
generic ASoC side hdmi codec driver (or library).

I am currently working on something that tries to be a generic solution 
that should be usable for different encoders and platforms, but 
unfortunately I have been busy with other things lately and have not 
been able to put anything working together yet. As soon as I have at 
least a bare bone API and and a proof of concept implementation working, 
I send RFC/POF patches out.

Best regards,
Jyri

[1] I personally do not like the hdmi_get_cdev() approach. I would 
rather go with only a library for registering from ASoC codec component 
under the HDMI encoder device or a completely separate device with only 
a reference to the HDMI encoder.

