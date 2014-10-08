Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaJHQBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:01:01 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52608 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbaJHQA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:00:58 -0400
Message-ID: <54355FAF.6060708@collabora.co.uk>
Date: Wed, 08 Oct 2014 18:00:47 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/5] regulator: dt-bindings: Add regulator-initial-mode
 support
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk> <1412775847-15213-4-git-send-email-javier.martinez@collabora.co.uk> <20141008143439.GB4609@sirena.org.uk>
In-Reply-To: <20141008143439.GB4609@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 04:34 PM, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 03:44:05PM +0200, Javier Martinez Canillas wrote:
> 
>> +- regulator-initial-mode: initial regulator operating mode. One of following:
>> +	<1>: REGULATOR_MODE_FAST    - Regulator can handle fast changes.
>> +	<2>: REGULATOR_MODE_NORMAL  - Normal regulator power supply mode.
>> +	<4>: REGULATOR_MODE_IDLE    - Regulator runs in a more efficient mode.
>> +	<8>: REGULATOR_MODE_STANDBY - Regulator runs in the most efficient mode.
>> +  modes are defined in the dt-bindings/regulator/regulator.h header and can be
>> +  used in device tree sources files. If no mode is defined, then the OS will not
>> +  manage the operating mode and the HW default values will be used instead.
> 
> ...and as previously and repeatedly discussed this still gives the user
> no way of telling if or how these modes might correspond to what the
> chip is capable of doing.  This really needs addressing rather than
> ignoring, for example by not trying to define the modes in generic
> bindings.
> 

Drivers could add custom per-device DT properties. That is how it was
solved in the ChromeOS kernel. There is a regulator-op-mode DT property
whose value is just a magic number with the value that has to be written
in the OPMODE field of the control register of each regulator and that
is made on the driver probe.

Another option is to not document the standard modes in the generic
regulator binding but instead on each device DT binding doc. That way
each device binding can define what are the semantics of the standard
modes and how correspond to the real modes in the chip.

That way the regulator-initial-mode could still be generic and parsed
by the core instead of each driver implementing their own custom parsing.

Best regards,
Javier
