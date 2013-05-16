Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3EPTPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 15:15:35 -0400
Received: from antispam02.maxim-ic.com ([205.153.101.183]:46408 "EHLO
	antispam02.maximintegrated.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab3EPTPe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 15:15:34 -0400
X-ASG-Debug-ID: 1368731732-0520cc2f3a00cf0001-xx1T2L
X-Barracuda-Envelope-From: Matthew.Mowdy@maximintegrated.com
From: Matthew Mowdy <Matthew.Mowdy@maximintegrated.com>
To: Mark Brown <broonie@kernel.org>
CC: "abrestic@chromium.org" <abrestic@chromium.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Dylan Reid <dgreid@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ralph Birt <Ralph.Birt@maximintegrated.com>,
        Evan Ragsdale <Evan.Ragsdale@maximintegrated.com>
Date: Thu, 16 May 2013 12:15:29 -0700
Subject: RE: [PATCH] ASoC: max98090: add digital mic mux to record path
Thread-Topic: [PATCH] ASoC: max98090: add digital mic mux to record path
X-ASG-Orig-Subj: RE: [PATCH] ASoC: max98090: add digital mic mux to record path
Thread-Index: Ac5SXlXMmXoKjyMoTwmniYCJBig6TAACmgqg
Message-ID: <9F78FA13B8C7A749B307D9AECB279EB713E7B32C9C@ITSVLEX06.it.maxim-ic.internal>
References: <1368640112-1417-1-git-send-email-abrestic@chromium.org>
 <A453F1AE3B5DC14DB19666C506CE75A710ABEB1EFF@ITSVLEX06.it.maxim-ic.internal>
 <9F78FA13B8C7A749B307D9AECB279EB713E7B327F3@ITSVLEX06.it.maxim-ic.internal>
 <20130516175241.GF1627@sirena.org.uk>
In-Reply-To: <20130516175241.GF1627@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: maxdalex01.maxim-ic.internal[10.16.15.101]
X-Barracuda-Start-Time: 1368731732
X-Barracuda-URL: http://192.168.10.183:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.02
X-Barracuda-Spam-Status: No, SCORE=0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=THREAD_INDEX, THREAD_TOPIC
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.131148
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 THREAD_INDEX           thread-index: AcO7Y8iR61tzADqsRmmc5wNiFHEOig==
	0.01 THREAD_TOPIC           Thread-Topic: ...(Japanese Subject)...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Understood Mark,

I apologize for any erroneous comments, as I am the hardware engineer not the driver author. I will stay out of the actual driver implementation as some of the notes I added may have been platform specific implementation (integration) and not core driver functionality. Our software engineer can clarify any questions or concerns with the core driver (I believe he is currently reviewing the proposed patch).

The key information I needed to add from a hardware side was the full functionality of the digital microphone enable bits. I was concerned, and wanted to insure any changes reflected that they are primarily enables (and are not just MUX control bits) and that they need to operate in tandem for proper hardware configuration. To that end I hope the valid use cases are helpful  to the continuing development. 

Thank you for your feedback, and I apologize for any odd formatting. It looks like all correspondence is in plain text and I was using HTML. 

Matthew Mowdy

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Thursday, May 16, 2013 10:53 AM
To: Matthew Mowdy
Cc: abrestic@chromium.org; lgirdwood@gmail.com; perex@perex.cz; tiwai@suse.de; Sachin Kamat; Kuninori Morimoto; Dylan Reid; linux-kernel@vger.kernel.org; Ralph Birt; Evan Ragsdale
Subject: Re: [PATCH] ASoC: max98090: add digital mic mux to record path

On Wed, May 15, 2013 at 09:10:23PM -0700, Matthew Mowdy wrote:

Sorry, didn't manage to find the content I meant to reply to in here due to the formatting issues I mentioned in my mail and the enormous reams of datsheet that were pasted in.  Anyway....

> Default Routing:
> Of note (software can confirm) I believe the default DAPM routing for the driver was intentional setup such that :

This indicates that the driver is broken, the driver should be using the chip defaults.

> Record:

> o   If a headset MIC is present, record from it.
> 
> o   If not, digital MIC is the default record input.

This is a bug, the driver should not be making any automatic routing decisions.  The behaviour you describe would break some fairly obvious use cases like speakerphone while headset is connected.

> Playback:

> o   When headphones are detected, playback is through the headphone output.

> o   When headphones are not present, playback was through the speaker outputs.

Similarly here, this is junk.  

> The defaults can be modified by each end user as needed (for analog 
> microphones, line inputs, etc.). Please insure any patch to the 
> baseline driver reflects the correct operation of the digital 
> microphone enable bits, and preserves the intended default operation.

No, this is stupid and will be buggy.  The register default values need to reflect the silicon defaults, the frameworks (both ASoC and regmap) do things like suppress writes that have no effect and rely on knowing the silicon defaults for that.

The framework already allows the application layer to configure the device through the controls exposed to userspace, if people need to modify a CODEC driver for their system that reflects a problem in the CODEC driver.
