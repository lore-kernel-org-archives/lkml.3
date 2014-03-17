Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbaCQNoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:44:11 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47424 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaCQNoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:44:04 -0400
Message-ID: <5326FC20.9020304@gmail.com>
Date: Mon, 17 Mar 2014 14:44:00 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Bo Shen <voice.shen@atmel.com>
CC: nicolas.ferre@atmel.com, Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH 7/8] ASoC: atmel: document clock properties of the wm8904
 driver
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-8-git-send-email-voice.shen@atmel.com> <20140317115518.GD11706@sirena.org.uk>
In-Reply-To: <20140317115518.GD11706@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

Le 17/03/2014 12:55, Mark Brown a écrit :
> On Mon, Mar 17, 2014 at 05:45:40PM +0800, Bo Shen wrote:
>
>>     - compatible: "atmel,asoc-wm8904"
>>     - atmel,model: The user-visible name of this sound complex.
>> +  - clocks: A list of clocks needed by the wm8904 chip.
>> +  - clock-output-names: Driver related clock names. Shall contain "pck0".
> If this is a clock for the CODEC it should be documented as part of the
> binding for the CODEC and connected to the CODEC in the device tree
> rather than being part of a machine driver binding.

Tell me if I'm mistaken, but doing this would implies a lot of changes.
The current wm8904 driver does not handle clk retrieval and configuration,
and I'm afraid that introducing these concepts would break other drivers 
(those
connecting to a wm8904 codec).

Do you see a simple alternative to this approach (or is there something 
I misunderstood
in your suggestion) ?

How about adding CCF support as proposed in this series and think about 
a cleaner
solution for a future release ?

Best Regards,

Boris
