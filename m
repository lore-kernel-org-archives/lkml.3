Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaEEIrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:47:31 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51804 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbaEEIr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:47:28 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-20-5367501ddfc1
Message-id: <1399279644.17696.3.camel@AMDC1943>
Subject: Re: [PATCH part2 5/6] regulator: max14577: Implement SUSPEND mode for
 MAX77836 LDO-s
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>
Date: Mon, 05 May 2014 10:47:24 +0200
In-reply-to: <20140501181908.GS3245@sirena.org.uk>
References: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
 <1398264640-12122-6-git-send-email-k.kozlowski@samsung.com>
 <20140501181908.GS3245@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xy7qyAenBBnuvGlsc3KppsXHGelaL
	qQ+fsFlMevKe2WLiysnMFmeb3rBb3P96lNHi25UOJovLu+awWaw9cpfd4nQ3q8X6Ga9ZHHg8
	JvR/YvTYOesuu8fmFVoem1Z1snncubaHzWPeyUCPvi2rGD0+b5IL4IjisklJzcksSy3St0vg
	ymj/Ooel4CdvxZTNjewNjNO4uxg5OSQETCSeH2tkgrDFJC7cW8/WxcjFISSwlFHi961WVgjn
	M6PE+XXnWEGqeAX0JSYde8cCYgsLxEvcPDUdLM4mYCyxefkSNhBbREBZ4ur3vSwgzcwCR5gl
	dpzfA5ZgEVCVOLJ+J1ADBwengJHE9JOKEAvWMkps/LgNbCizgLrEpHmLmCFOUpaYt/8YE8Ri
	QYkfk+9B1chLbF7zlnkCo8AsJC2zkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7u
	JkZIxHzZwbj4mNUhRgEORiUe3sCglGAh1sSy4srcQ4wSHMxKIryzGNODhXhTEiurUovy44tK
	c1KLDzEycXBKNTAuVeJkTP5VL7t+vylvEvMh9cad51jmspgEGnKwGQffuRE/h2lalasT21LJ
	x4eEl144Vhr59aNilXJ7zeQJlYml4bvfCRTNvfOW9UBVnfCLy8kTv+ftfzcnLsLGUFlSZZ+f
	bZKy21fnH2cEJWdoP//Y8O8397+0XdOWzbNljvh4dTvzBs2TB54psRRnJBpqMRcVJwIA69yL
	onYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-05-01 at 11:19 -0700, Mark Brown wrote:
> On Wed, Apr 23, 2014 at 04:50:39PM +0200, Krzysztof Kozlowski wrote:
> 
> > This patch adds support for mode REGULATOR_MODE_STANDBY (and NORMAL) to
> > LDO regulators by implementing the set_mode() and get_mode() operations.
> > However the necessary regulator constraints (valid modes) are not parsed
> > by of_regulator_match() so the driver adds them manually to the
> > regulator init_data.
> 
> No, that's not the idea here.  The reason that the modes need to be
> explicitly enabled is that there's an element of board design in
> determining if a given mode can satisfy the required current demand for
> the board with sufficient quality (usually the lower power modes have
> both a lower maximum current and poorer regulation accuracy especially
> as the current rises).  Doing it unconditionally isn't in general
> reliable.
> 
> The reason that the modes aren't supported by DT is that defining a
> binding is hard - it's not clear what exactly a "mode" means since it's
> basically a Linux internal thing.  We probably need to explicitly add
> definitions of the modes to the bindings for individual devices
> unfortunately (ie, saying "mode X maps to Y in the datasheet", possibly
> using the datasheet modes in the binding for ease of use and having that
> translation in the driver).
> 
> Ideally we'd be able to have the automatic mode setting working for
> devices but in practice nobody wants to publish the numbers and working
> out how much the board needs can also be hard so that isn't really
> practical.

I understand. Lets skip this patch now. I will prepare in the future a
version of this patch with own DT binding for max77836 suspend mode.

Best regards,
Krzysztof

