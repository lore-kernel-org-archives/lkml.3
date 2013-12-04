Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3LDLDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:03:37 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60357 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3LDLDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:03:35 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-6a-529f0c054260
Message-id: <1386155011.25938.4.camel@AMDC1943>
Subject: Re: [PATCH v6 3/3] mfd: max14577: Add device tree bindings document
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Date: Wed, 04 Dec 2013 12:03:31 +0100
In-reply-to: <529F0B75.5040004@samsung.com>
References: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
 <1386153615-25456-4-git-send-email-k.kozlowski@samsung.com>
 <529F08DD.2090005@samsung.com> <1386154579.25938.2.camel@AMDC1943>
 <529F0B75.5040004@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t/xK7qsPPODDN71S1sc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPdqJaPF2aY37Bb3vx5ltPh2pYPJYtPja6wWC9uWsFhc
	3jWHzWLtkbvsFkuvX2SymDB9LYvF4RUHmCzWvZzOYvHqYBuLg7DHmnlrGD0WfL7C7jGh/xOj
	x85Zd9k9Vi7/wuaxeYWWx6ZVnWwer1bPZPW4c20PUGhJvUffllWMHp83yXlsnBsawBvFZZOS
	mpNZllqkb5fAlTFjwUWmgvucFZv+zGZpYNzH3sXIySEhYCKx5+VLNghbTOLCvfVANheHkMBS
	Ron9bw8zQTifGSVuP21lAaniFdCXeHDkHyuILSzgI9F45g0ziM0mYCyxefkSsEkiAhoSM/9e
	YQRpZhbYxCpx8c47oGYODhYBVYk1+zlAajgFtCWePX7HDrHgNaPExAdPGEESzALqEpPmLWKG
	OElJYnd7JztEXF5i85q3zBBHCEr8mHyPZQKjwCwkLbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFe
	cWJucWleul5yfu4mRkikftnBuPiY1SFGAQ5GJR5eDvZ5QUKsiWXFlbmHGCU4mJVEeLewzQ8S
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwGh4YcXGN9Vf8o4HBr5gtFMLUG/acT8ozmrdWr65lvHS
	W5bZbpw79/HuTpFQrRdS/h65wupNjgJTzGsqH8v4/wt23dm547Lf7Y+vrP5ov9y88bS6Ri7b
	wW8vVSz0jq950HhCVuTd2YmaMyb+r2riYOcVLtUqUfpxT/bneefOrGBdoX8LmVZMD1NiKc5I
	NNRiLipOBACGC5bHsgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 20:01 +0900, Chanwoo Choi wrote:
> On 12/04/2013 07:56 PM, Krzysztof Kozlowski wrote:
> > On Wed, 2013-12-04 at 19:50 +0900, Chanwoo Choi wrote:
(...)
> >>
> >> I prefer to add dt data about max14577-muic on following:
> >> If extcon consumer driver need to use muic device, dts should provide following dt data.
> >>
> >> 		muic: max14577-muic {
> >> 			compatible = "maxim, max14577-muic";
> >> 		};
> >>> +	};
> >>>
> >> For example,
> >> If fuel-gauge want to use extcon subsystem, dt data of fuel-gauge add 'extcon' property as following:
> >>
> >> 	fuel-gague@ {
> >> 		compatible = "...";
> >> 		extcon = <&muic>;
> >> 	}
> >>
> > Hi,
> > 
> > The extcon driver itself does not use the binding. It is only needed for
> > consumers. Is it a common practice to add to documentation such notice
> > for consumers only?
> 
> As you comment, It is only for extcon consumer.
> But extcon provider driver always is operated with extcon consumer driver.
> If dts file don't support upper dt data about extcon provider driver,
> all of extcon consumer drivers could not use extcon subsystem.
> 
> I thinks it is common dt data for muic device.

OK, I'll add it.

Best regards,
Krzysztof

