Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaABRwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:52:08 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:41059 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaABRwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:52:04 -0500
Date: Thu, 2 Jan 2014 18:50:55 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
Message-ID: <20140102185055.76eb576e@armhf>
In-Reply-To: <20140102131045.GZ31886@sirena.org.uk>
References: <20131231113138.102044cf@armhf>
	<52C466E1.3030302@metafoo.de>
	<20140101210814.31e3f3a9@armhf>
	<52C4766B.8080000@metafoo.de>
	<20140102102647.6efec89d@armhf>
	<20140102111056.GT31886@sirena.org.uk>
	<20140102124331.2bcfc172@armhf>
	<20140102115618.GW31886@sirena.org.uk>
	<20140102134437.1e39da55@armhf>
	<20140102131045.GZ31886@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014 13:10:45 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Thu, Jan 02, 2014 at 01:44:37PM +0100, Jean-Francois Moine wrote:
> 
> > I still don't understand. There is already such cases in the Cubox:
> > the S/PDIF output from the kirkwood audio controller is connected to
> > both the HDMI transmitter and the S/PDIF TOSLINK. So, in the audio
> > controller, the port @1 defines the S/PDIF DAI and the endpoints @0 and
> > @1 point to the remote DAIs, creating 2 snd DAI links:
> 
> > 	port@1 {
> > 		audio_hdmi_spdif: endpoint@0 {
> > 			remote-endpoint = <&hdmi_spdif_audio>;
> > 		};
> > 		audio_spdif: endpoint@1 {
> > 			remote-endpoint = <&spdif_audio>;
> > 		};
> > 	};
> 
> Oh, so the endpoints are virtual and that's supposed to be three things
> wired together rather than a single device with multiple links?  That's
> really not very clear from reading the above and seems cumbersome -
> every device will want to explicitly identify every other device on the
> link and any configuration is going to either need to be replicated on
> every device or we'll need to check lots of places for the configuation.
> It seems like this will be hard to work with.

No, the 'endpoint' <=> 'remote-endpoint' is a point to point relation.
Even if the sources and sinks are not explicitly defined, the way
the stream flows is easy to find: the main source is always in the
'audio-controller' node

	sound {
		compatible = "media-audio";
		audio-controller = <&audio1>;
	};

and, then, the controller ports are sources (CPU DAIs) and the
associated remote ports are sinks (CODEC DAIs).

With many levels, once the remote (sink) ports are identified, in the
devices where such sinks exist, the remaining ports are sources.

Usually, the devices don't have to know to which other device they are
connected, and, yes, the reverse pointer sink to source is not useful.

But the way (link) the audio stream comes from may be important to
know. This is the case for the HDMI CODEC which must tell the HDMI
transmitter from which hardware port(s) ('reg') it may get the audio
stream. That's why, the HDMI encoder has two endpoints in its audio
port, each endpoint being a different CODEC DAI.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
