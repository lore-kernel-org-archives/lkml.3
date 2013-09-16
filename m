Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab3IPMdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:33:14 -0400
Received: from blu0-omc1-s12.blu0.hotmail.com ([65.55.116.23]:35582 "EHLO
	blu0-omc1-s12.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab3IPMdN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:33:13 -0400
X-TMN: [iuDebxLD3DjqYIl7TA+SsQmL+AJCRINm]
X-Originating-Email: [trpike@outlook.com]
Message-ID: <BLU177-W800B61A98829FA30996C2CD260@phx.gbl>
From: Thomas Pike <trpike@outlook.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: HD Audio: DisplayPort and HDMI codecs?
Date: Mon, 16 Sep 2013 12:33:12 +0000
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Sep 2013 12:33:12.0876 (UTC) FILETIME=[E8CD1EC0:01CEB2D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
I need to ask something that's been bugging me for years. Suppose you have a graphics adapter with both DisplayPort and HDMI ports, and both of them are connected to different screens.

Then how do I decide where to route my audio signals?
Linux ALSA drivers only expose one generic codec (usually something like /proc/asound/card0/codec#3) that is supposed to cater both to DP and HDMI. Of course, audio only ends up at one of the two, and in my experience DP takes precedence. This goes as far as that no matter whether even a device is connected to DP or not, HDMI does not receive any audio as soon as a DP port exists.
Usually I'd route my audio with something like `mplayer -ao alsa:device=hw=0.3`, but since codec#3 represents both DP and HDMI, there is no way for me to pick a particular audio sink (and pulseaudio naturally wouldn't allow me to do anything beyond this either, as it only patches through audio to ALSA devices).
At first I thought this is a vendor-specific problem, but after experiencing it on both AMD and Intel adapters, I checked the kernel modules: All HD audio related to DP/HDMI seems to processed by snd_hda_codec_hdmi. HDA kernel modules don't seem to allow for any parameters to set the preferred audio port either, so I believe this is a generic problem.

So, any suggestions on how this can be fixed?
Wouldn't it be advisable to expose each audio port via a separate codec? This way I could even simultaneously run multiple audio streams over multiple DP/HDMI connections.

Thanks for you insight!
T. Pike 		 	   		  