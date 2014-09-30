Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaI3GlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:41:00 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49387 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaI3Gk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:40:58 -0400
Message-ID: <542A505A.5030109@i2se.com>
Date: Tue, 30 Sep 2014 08:40:26 +0200
From: Stefan Wahren <stefan.wahren@i2se.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, shawn.guo@linaro.org, festevam@gmail.com
CC: lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/2] regulator: add mxs regulator driver
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com> <1411779588-22031-3-git-send-email-stefan.wahren@i2se.com> <20140928101650.GL27755@sirena.org.uk> <5428FE7B.8060700@i2se.com> <20140929171314.GW16977@sirena.org.uk>
In-Reply-To: <20140929171314.GW16977@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:53ao/3vq4Se7oc9EdYtNOF30NFjQz1Vuj160ty9nnRI
 9deiAhrMRg+ThYX7ZDNT1xhgGtev58SzbtjHf9KIl56QVe9IAr
 OBWpdMi906wqz28uJyzEQw/Xww2sIWbldoAFwrfvelqYuPtBFl
 gBMfx5p1vapAsv78C87wtnnwBGr/zxi9TE0L4XrfI9D5+W4CN3
 H2TFqr2/pk1eEyRimh8ve5G4xEdrtqY/6NYkUxh1+MOxoQz6Iw
 Cpj7S7T03bOw/9scbT/ZE7I9Q5aaSknQzVcg0yoiNWvG1CoYF3
 BObllvXXi6lq/vFiBBrund8MjFv5cMGMPoPmXHOE2zXbCETGA4
 Owc4KgCh+3cJf1sgSXco=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.09.2014 um 19:13 schrieb Mark Brown:
> On Mon, Sep 29, 2014 at 08:38:51AM +0200, Stefan Wahren wrote:
>
>> I'm searching for a good regulator implementation example.
>> Does it apply to ti-abb-regulator.c and twl-regulator.c?
> Possibly.  But bear in mind that it's important to understand the
> hardware you're trying to support.

The question refer more to the devicetree binding and it's implementation.

>
>>> This really needs a comment to explain what on earth is going on here -
>>> the whole thing with writing the same thing twice with two delays is
>>> more than a little odd.  It looks like the driver is trying to busy wait
>>> in cases where the change happens quickly but the comments about "fast"
>>> and "normal" mode make this unclear.
>> The regulator driver polls for the DC_OK bit in the power status register.
>> Quote for reference manual (p. 935): "High when switching DC-DC
>> converter control loop has stabilized after a voltage target change."
>> The two loops comes from the different regulator modes
>> (REGULATOR_MODE_FAST, REGULATOR_MODE_NORMAL).
>> In REGULATOR_MODE_FAST the voltage steping is disabled and changing
>> voltage should be fast. In REGULATOR_MODE_NORMAL voltage steping is
>> enabled and it's take a while for reaching the target voltage.
> I don't think you've fully understood what the different modes mean
> here, that's not normally how a buck convertor works.  The different
> modes would typically control the ability of the regulator to respond
> quickly to changes in load without drifting off regulation, fast mode
> makes the regulator less efficient but more responsive to load changes
> (probably marginally with modern regulators).  It should have relatively
> little to do with the ability to ramp the voltage and certainly not on
> the scale there.
>
>> Do you see more a problem with the two different loops or the redundant
>> register write?
> Both.  The code right now just looks really obscure.

That leads me to the conclusion to drop both mode functions. My
intention is to get the cpufreq-cpu0 aka cpufreq-dt working on i.MX28,
not to build up the complete power system.

@Fabio, @Shawn: What is your opinion?

Best regards

Stefan


