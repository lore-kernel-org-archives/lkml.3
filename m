Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaJ2Cve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:51:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaJ2Cvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:51:32 -0400
Date: Wed, 29 Oct 2014 10:50:19 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, Neil Jones <neil.jones@imgtec.com>
Subject: Re: [PATCH 00/11] Add AXD Audio Processing IP driver
Message-ID: <20141029025019.GA7568@kroah.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
 <544F8439.4080402@ladisch.de>
 <544F97A4.7080209@imgtec.com>
 <20141028141348.GD18384@kroah.com>
 <544FB0AC.4020205@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FB0AC.4020205@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:05:16PM +0000, Qais Yousef wrote:
> On 10/28/2014 02:13 PM, Greg Kroah-Hartman wrote:
> >On Tue, Oct 28, 2014 at 01:18:28PM +0000, Qais Yousef wrote:
> >>On 10/28/2014 11:55 AM, Clemens Ladisch wrote:
> >>>Qais Yousef wrote:
> >>>>AXD Audio Processing IP performs audio decoding, encoding, mixing, equalisation,
> >>>>synchronisation and playback.
> >>>What exactly do you mean with "synchronisation" and "playback"?
> >>Synchronisation refers to accurate audio playout relative to a master
> >>clock source including compensation of drift between the master clock
> >>source and the playout clock of the audio hardware. Hence allowing
> >>synchronised audio playout across multiple independent devices.
> >>
> >>Playback simple refers to the fact that AXD is capable of managing audio
> >>playout hardware like I2S and SPDIF interfaces.
> >>
> >>
> >>>>It doesn't fit in alsa subsystem but I Cced them to confirm.
> >>>... because those two words sound like something that a sound card could do.
> >>The problem mainly stems from the fact that we take a variety of
> >>compressed audio as input and we could perform audio encoding. The
> >>problem with the compressed audio is that the range of decoders and
> >>configuration supported in alsa is limited and there's no support for
> >>taking raw pcm and producing compressed output. I'm not an expert on
> >>alsa but when I looked it looked like there's more infra structure
> >>required.
> >>
> >>The following not supported points from Documentation/sound/alsa/compress_offload.txt affect us:
> >>
> >>- Volume control/routing is not handled by this API. Devices exposing a
> >>   compressed data interface will be considered as regular ALSA devices;
> >>   volume changes and routing information will be provided with regular
> >>   ALSA kcontrols.
> >>
> >>- Embedded audio effects. Such effects should be enabled in the same
> >>   manner, no matter if the input was PCM or compressed.
> >>
> >>- Encoding/decoding acceleration is not supported as mentioned
> >>   above. It is possible to route the output of a decoder to a capture
> >>   stream, or even implement transcoding capabilities. This routing
> >>   would be enabled with ALSA kcontrols.
> >So instead you created a one-off api just for this hardware?  Ick, no,
> >please work with the audio developers to incorporate it into the
> >standard Linux audio apis so that everyone can benifit and not require
> >special userspace programs to drive this hardware.
> >
> >thanks,
> >
> >greg k-h
> 
> OK. I'll wait to hear from alsa developers to see the extent of work
> required. I can't see it being trivial though. Would it be possible for this
> to be accepted into staging until this is resolved?

If you are willing to abide by the staging rules:
	- incremental patches only doing one thing at a time
	- never break the build
	- constantly moving forward to getting merged (i.e. no new
	  features being added)

I think it will be easier for you to do the work outside of the tree as
you are going to be changing the API, which is not going to be easy to
do in an incremental patch series.

And yes, this isn't going to be a trivial amount of work, sorry.

thanks,

greg k-h
