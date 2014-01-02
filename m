Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaABMpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:45:34 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:47883 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaABMpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:45:32 -0500
Date: Thu, 2 Jan 2014 13:44:37 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
Message-ID: <20140102134437.1e39da55@armhf>
In-Reply-To: <20140102115618.GW31886@sirena.org.uk>
References: <20131231113138.102044cf@armhf>
	<52C466E1.3030302@metafoo.de>
	<20140101210814.31e3f3a9@armhf>
	<52C4766B.8080000@metafoo.de>
	<20140102102647.6efec89d@armhf>
	<20140102111056.GT31886@sirena.org.uk>
	<20140102124331.2bcfc172@armhf>
	<20140102115618.GW31886@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014 11:56:18 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Thu, Jan 02, 2014 at 12:43:31PM +0100, Jean-Francois Moine wrote:
> > Mark Brown <broonie@kernel.org> wrote:
> 
> > > I think we want an explicit object in the card representing the DAIs.
> > > This will both be useful for making it easy to find the configuration
> > > for the link and will be more extensible for the cases where multiple
> > > devices are connected, you can't just assume there's just two.
> 
> > I don't see the problem: the 'port' is the DAI. The associated
> > endpoints give the DAI links and the routing information.
> 
> > As the DT definition has been done for video, some properties may be
> > added at will for audio.
> 
> > What kind of object were you thinking of?
> 
> Like I say multiple devices on the same link - if you're just listing a
> single remote device there can't be more than one.

I still don't understand. There is already such cases in the Cubox:
the S/PDIF output from the kirkwood audio controller is connected to
both the HDMI transmitter and the S/PDIF TOSLINK. So, in the audio
controller, the port @1 defines the S/PDIF DAI and the endpoints @0 and
@1 point to the remote DAIs, creating 2 snd DAI links:

	port@1 {
		audio_hdmi_spdif: endpoint@0 {
			remote-endpoint = <&hdmi_spdif_audio>;
		};
		audio_spdif: endpoint@1 {
			remote-endpoint = <&spdif_audio>;
		};
	};

in the snd card:

	- DAI link 1 = 'audio controller spdif out' <=> 'hdmi spdif'
	- DAI link 2 = 'audio controller spdif out' <=> 'spdif'

If I am wrong, may you give us an example for which such a DT would not
work?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
