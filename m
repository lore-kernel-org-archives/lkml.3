Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaJ2F6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:58:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:50717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbaJ2F6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="627427454"
Date: Wed, 29 Oct 2014 10:48:14 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org, Neil Jones <neil.jones@imgtec.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 00/11] Add AXD Audio Processing IP driver
Message-ID: <20141029051814.GR28745@intel.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
 <544F8439.4080402@ladisch.de>
 <544F97A4.7080209@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544F97A4.7080209@imgtec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 01:18:28PM +0000, Qais Yousef wrote:
> On 10/28/2014 11:55 AM, Clemens Ladisch wrote:
> >Qais Yousef wrote:
> >>AXD Audio Processing IP performs audio decoding, encoding, mixing, equalisation,
> >>synchronisation and playback.
> >What exactly do you mean with "synchronisation" and "playback"?
> 
> Synchronisation refers to accurate audio playout relative to a master
> clock source including compensation of drift between the master clock
> source and the playout clock of the audio hardware. Hence allowing
> synchronised audio playout across multiple independent devices.
> 
> Playback simple refers to the fact that AXD is capable of managing audio
> playout hardware like I2S and SPDIF interfaces.
> 
> 
> >>It doesn't fit in alsa subsystem but I Cced them to confirm.
> >... because those two words sound like something that a sound card could do.
> 
> The problem mainly stems from the fact that we take a variety of
> compressed audio as input and we could perform audio encoding. The
> problem with the compressed audio is that the range of decoders and
> configuration supported in alsa is limited and there's no support for
FWIW ALSA does not support decoders. The compressed ALSA API allows you to
encode or decode your conent on a DSP, it provides API for that

If you have an additional need for a decoder or an encoder which is not
listed, feel free to send a patch!
The most important point is frameowrk is there for thsi so you need to use
that and add whatever is not supported

> taking raw pcm and producing compressed output. I'm not an expert on
> alsa but when I looked it looked like there's more infra structure
> required.
I disagree. You can use alsa PCM device to send pcm data and then use alsa
compressed device to take back the compressed content. The two devices need
to be "connected" using DPCM and DAPM frameowork availble. It should work
with little or no changes

> 
> The following not supported points from Documentation/sound/alsa/compress_offload.txt affect us:
> 
> - Volume control/routing is not handled by this API. Devices exposing a
>   compressed data interface will be considered as regular ALSA devices;
>   volume changes and routing information will be provided with regular
>   ALSA kcontrols.
And why can't you use ALSA kcontrols for volume??
> 
> - Embedded audio effects. Such effects should be enabled in the same
>   manner, no matter if the input was PCM or compressed.
Again why can't you use ALSA kcontrol for effects, be it PCM or compressed
progarmming an EQ thru alsa kcontrol remains same
> 
> - Encoding/decoding acceleration is not supported as mentioned
>   above. 
Wrong on this count

> It is possible to route the output of a decoder to a capture
>   stream, or even implement transcoding capabilities. This routing
>   would be enabled with ALSA kcontrols.
Yes and it should work

> >>I added it to drivers/char as this is the best location I could think of at the
> >>moment.
> >drivers/misc?
> 
> Yeah could do if there's consensus.
NAK for that, this should be an ALSA driver

-- 
~Vinod
