Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaJ2KTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:19:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13704 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbaJ2KS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:18:59 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-23-5450bf10ce6a
Content-transfer-encoding: 8BIT
Message-id: <1414577934.18868.7.camel@AMDC1943>
Subject: Re: [PATCH v5 3/4] regulator: max77686: Add suspend disable for some
 LDOs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Wed, 29 Oct 2014 11:18:54 +0100
In-reply-to: <20141029100142.GR18557@sirena.org.uk>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
 <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
 <20141028223121.GH18557@sirena.org.uk> <1414574413.18868.6.camel@AMDC1943>
 <20141029100142.GR18557@sirena.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xa7oC+wNCDF7uULbYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g0bvgKpvF2aY37BbfrnQwWWx6fI3V4vKuOWwWM87vY7K4
	fZnXYu2Ru+wOfB4tzT1sHn+fX2fx+LvqBbPHzll32T02repk89i8pN6jb8sqRo/Pm+QCOKK4
	bFJSczLLUov07RK4Mr7dVyr4y17x/fwnxgbGVWxdjJwcEgImEpffd7NC2GISF+6tB4pzcQgJ
	LGWUuPixC6yIV0BQ4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+ZUeLAw6lMEPX6Ek3L
	V7KA2MICIRLfrh0Ai7MJGEtsXr4EbKaIgLLE1e97WUCamQWmsUgs+HiJESTBIqAq0f/3OjuI
	zQnUsKP7ORPEhp+MEr8mnWEDuUICqLux320Co8AsJPfNQrhvFpL7FjAyr2IUTS1NLihOSs81
	0itOzC0uzUvXS87P3cQIiaCvOxiXHrM6xCjAwajEwxvB4h8ixJpYVlyZe4hRgoNZSYR3h3lA
	iBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGVvfrrgaG3y7P37tQ8AQXn4Jd+txso74HPVpFXf/P
	bznC901J6FXL/5xcxVmy+6zkots0jgmHzwt98MXBfqP7t97kx99tpERbfywt+qAoNnvC3UcM
	RnLfOI8oN3FN2jL5sg2juqHStFzZEoN+/XmRzhY8S87++pB48rAlV+rbbWb2HdOWOsQrsRRn
	JBpqMRcVJwIAdv6V534CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-29 at 10:01 +0000, Mark Brown wrote:
> On Wed, Oct 29, 2014 at 10:20:13AM +0100, Krzysztof Kozlowski wrote:
> > On wto, 2014-10-28 at 22:31 +0000, Mark Brown wrote:
> 
> > > This looks wrong, you're using the regular enable operation as suspend
> > > enable.  How does that work without disrupting the current runtime
> > > state?
> 
> > Currently it shouldn't disrupt state of regulator because during runtime
> > it may only be only: on (0x3) or off (0x0). Suspend enable in max77686
> > writes 0x3 to the register which means - always on.
> 
> > If regulator was disabled before suspend then it has to be enabled
> > during suspend_enable() call which is exactly what max77686_enable does.
> > If it was enabled then nothing happens.
> 
> No, this isn't suspend enable control - this is normal, standard enable
> control and the device has no suspend enable control.

You mean that for such regulator the driver shouldn't implement
suspend_enable()?

Best regards,
Krzysztof

