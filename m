Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaBNIPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:15:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29306 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaBNIPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:15:16 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-03-52fdd091c08c
Message-id: <1392365712.29133.16.camel@AMDC1943>
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14
 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Date: Fri, 14 Feb 2014 09:15:12 +0100
In-reply-to: <20140213192835.GD28112@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <20140213192835.GD28112@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xa7oTL/wNMvj718Zi44z1rBZTHz5h
	s7j+5TmrxdmmN+wW978eZbT4dqWDyeLyrjlsFjPO72OyWHvkLrvF6W5Wi4srvjA5cHvsnHWX
	3WPTqk42jzvX9rB5zDsZ6NG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZ7fOusRVc5qj4NrGV
	sYHxE1sXIyeHhICJRPe8C8wQtpjEhXvrgeJcHEICSxklnl1+DOV8ZpTomXeJHaSKV8BA4uvc
	hWC2sECoxKV1P1hAbDYBY4nNy5eATRURUJa4+n0vC0gzs8AkZok/J7uZQBIsAqoS/Us/gzVw
	AjU0XW2G2rCeUeLYx11gRcwC6hKT5i2CuklJYnd7JztEXF5i85q3zBBXCEr8mHyPZQKjwCwk
	LbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkhkfNnBuPiY1SFGAQ5GJR7e
	D3f/BAmxJpYVV+YeYpTgYFYS4XXf/zdIiDclsbIqtSg/vqg0J7X4ECMTB6dUA6NvHIew/paU
	9nmT6kQjnizLfS5uerqLwyUv8Hl7VXlmQd27jUus+dfPY1vzkVM1z/VF9XK9jVqnbHRDltjs
	ClySu4npFfsmQ6V3gkzSde/WOMztTvQwF49ZNYfv+/y9Kn2Kqc4XglzqHrCccGWpzdhY+8vG
	OLK8UtLi3BqetzbRilMO19r3KbEUZyQaajEXFScCAHP44QRqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 19:28 +0000, Mark Brown wrote:
> On Thu, Feb 13, 2014 at 10:14:04AM +0100, Krzysztof Kozlowski wrote:
> > S2MPS11/S2MPS14 regulators support different modes of operation:
> >  - Always off;
> >  - On/Off controlled by pin/GPIO (PWREN/LDOEN/EMMCEN);
> >  - Always on;
> > This is very similar to S5M8767 regulator driver which also supports
> > opmodes (although S5M8767 have also low-power mode).
> 
> What is the difference between always off/on and the normal enable
> control?  This sounds like a fairly standard register control that can
> be overridden by a GPIO.  The usual way of specifying that is by keying
> off the presence of the GPIO.

My initial idea was to do this similarly to the S5M8767 regulator (where
there is also 4th mode: low power). The presence of GPIO in DTS can
simplify the bindings but on the other hand it wouldn't be compatible
with S5M8767 regulator driver. This may complicate the merge of these
drivers.

What is your opinion on this - should I abandon the "op_mode" idea and
use presence of GPIO?

Best regards,
Krzysztof

