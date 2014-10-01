Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaJANpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:45:52 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64714 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaJANpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:45:50 -0400
MIME-Version: 1.0
In-Reply-To: <542C0441.5080508@sam-solutions.com>
References: <1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>
	<1410854903-26419-1-git-send-email-d.lavnikevich@sam-solutions.com>
	<1410854903-26419-3-git-send-email-d.lavnikevich@sam-solutions.com>
	<CAOMZO5CgrQ6Wf6kStga40TUKx9dARygCNB4OYSUoG3c8eUYbrA@mail.gmail.com>
	<542C0441.5080508@sam-solutions.com>
Date: Wed, 1 Oct 2014 10:45:48 -0300
Message-ID: <CAOMZO5BS6X2NTY4q7RKoKdhJNbEANSa2wXur3_Hyxp8nQn5Avw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ARM: dts: pbab01: enable I2S audio on
 phyFLEX-i.MX6 boards
From: Fabio Estevam <festevam@gmail.com>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, perex@perex.cz,
        Takashi Iwai <tiwai@suse.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 10:40 AM, Dmitry Lavnikevich
<d.lavnikevich@sam-solutions.com> wrote:

>> No need to have this 'regulator-always-on'
>>
>
> why is there no need for 'regulator-alweys-on'? I see it in

For a regulator that is not GPIO controlled you don't need to pass
'regulator-always-on'.

>
>>> +&ssi2 {
>>> +       fsl,mode = "i2s-slave";
>>
>>
>> Please remove this 'fsl,mode' property. It is ignored by the fsl_ssi
>> driver.
>
>
> yes, thanks. It is present in Documentation but now I see that it
> was actually removed not that long ago. I will remove this
> property with next patchset.

Correct, I recently sent a patch removing it and it is in Mark's tree now:
https://git.kernel.org/cgit/linux/kernel/git/broonie/sound.git/commit/?h=topic/fsl-ssi&id=b93427b1c057841602e0fe2005153a6e82f2e658
