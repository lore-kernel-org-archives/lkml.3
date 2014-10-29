Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbaJ2Kxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:53:45 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52328 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbaJ2Kxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:53:43 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-67-5450c734b0b2
Content-transfer-encoding: 8BIT
Message-id: <1414580018.18868.14.camel@AMDC1943>
Subject: Re: [PATCH v5 3/4] regulator: max77686: Add suspend disable for some
 LDOs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Wed, 29 Oct 2014 11:53:38 +0100
In-reply-to: <5450C6C2.2050506@collabora.co.uk>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
 <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
 <20141028223121.GH18557@sirena.org.uk> <1414574413.18868.6.camel@AMDC1943>
 <20141029100142.GR18557@sirena.org.uk> <1414577934.18868.7.camel@AMDC1943>
 <20141029103140.GY18557@sirena.org.uk> <1414579442.18868.13.camel@AMDC1943>
 <5450C6C2.2050506@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t/xa7omxwNCDBYvEbHYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g0bvgKpvF2aY37BbfrnQwWWx6fI3V4vKuOWwWM87vY7K4
	fZnXYu2Ru+wOfB4tzT1sHn+fX2fx+LvqBbPHzll32T02repk89i8pN6jb8sqRo/Pm+QCOKK4
	bFJSczLLUov07RK4Mjoff2YpaOes2LpkH3sDYzN7FyMnh4SAicTSO5OYIWwxiQv31rN1MXJx
	CAksZZQ4ceInG0iCV0BQ4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+ZUeJS1zIWiHoD
	iWmrVoL1CguESHy7doAJxGYTMJbYvHwJWFxEwE7ixuqHzBCDfjJLLH0eCjKfRUBV4u7FSpAw
	p4C+xKo1a1gg5k9glni47T7YDRICyhKN/W4TGAVmIbluFsJ1s5Bct4CReRWjaGppckFxUnqu
	kV5xYm5xaV66XnJ+7iZGSPx83cG49JjVIUYBDkYlHt4IFv8QIdbEsuLK3EOMEhzMSiK87/YG
	hAjxpiRWVqUW5ccXleakFh9iZOLglGpgXHfJg7tW/5WlVGPOutkKNyxc9rvPtjwp93eju9z9
	CU9fyLn7xhnfWvq03az2TN3cqxbNM41sJwR3PBDl5lpzqbSS+/m6Xs9j/aeCnzifijZLlno7
	Q0nqjprMyedxz7Yd+n6iQnhO9xrH7lON1tPFHhk9OrMlaJe8Btvk2CMJMxO0/+91u/qkQIml
	OCPRUIu5qDgRACpsL099AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-29 at 11:51 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/29/2014 11:44 AM, Krzysztof Kozlowski wrote:
> > On śro, 2014-10-29 at 10:31 +0000, Mark Brown wrote:
> >> On Wed, Oct 29, 2014 at 11:18:54AM +0100, Krzysztof Kozlowski wrote:
> >> > On śro, 2014-10-29 at 10:01 +0000, Mark Brown wrote:
> >> 
> >> > > No, this isn't suspend enable control - this is normal, standard enable
> >> > > control and the device has no suspend enable control.
> >> 
> >> > You mean that for such regulator the driver shouldn't implement
> >> > suspend_enable()?
> >> 
> >> Yes, if there is no separate control of suspend mode in hardware then of
> >> course the driver shouldn't implement operations for things it doesn't
> >> have.
> > 
> > Oh, thanks! I'll send fixed patch.
> > 
> > This means that probably the max77802 ("mirrored" driver) should be
> > fixed...
> > 
> 
> Indeed, I had the same confusion that you had. Just to avoid duplicating work,
> do you want me to send a fix or are you going to include one on your series?

I'll send a patch for max77802 also.

Best regards,
Krzysztof


