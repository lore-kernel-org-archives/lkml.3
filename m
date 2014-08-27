Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840AbaH0OBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:01:36 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34881 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933802AbaH0OBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:01:33 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-22-53fde4bb231e
Content-transfer-encoding: 8BIT
Message-id: <1409148089.25748.5.camel@AMDC1943>
Subject: Re: [RESEND PATCH v3 1/6] charger: max14577: Add support for MAX77836
 charger
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>
Date: Wed, 27 Aug 2014 16:01:29 +0200
In-reply-to: <20140827135218.GG6364@lee--X1>
References: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
 <1409146282-25075-2-git-send-email-k.kozlowski@samsung.com>
 <20140827135218.GG6364@lee--X1>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t/xK7q7n/wNNvjRzG1xcKumxcYZ61kt
	pj58wmYx6cl7ZouJKyczW/S/Wchqce7VSkaLs01v2C3ufz3KaPHtSgeTxebvHWwWl3fNYbP4
	3HuE0WLtkbvsFkuvX2SymDB9LYtF694j7Banu1ktTu8ucRD2WDNvDaPH5b5eJo8J/Z8YPXbO
	usvusXL5FzaPzSu0PDat6mTzuHNtD5vHvJOBHn1bVjF6fN4kF8AdxWWTkpqTWZZapG+XwJWx
	oP0RS8E/3orH966yNzBO5O5i5OSQEDCROPxsGzuELSZx4d56ti5GLg4hgaWMEoc6f4AleAUE
	JX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMEPWfGSXmHDjPCFGvL3Gn4zYbiC0sECHx5P4t
	JhCbTcBYYvPyJWwgc0QEVCTOvTEH6WUW2Msq8ab7IFgvi4CqxPGuDWC9nAI6Elsm74Q6aDmj
	xIvLC5lAmiUElCUa+90mMArMQnLeLITzZiE5bwEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT8
	3E2MkGj8uoNx6TGrQ4wCHIxKPLwKp/8EC7EmlhVX5h5ilOBgVhLhLTvwN1iINyWxsiq1KD++
	qDQntfgQIxMHp1QDY4nv6nsNs1q1Oy7bz0szmNOh1PfMNbbj8pvdEzPLCyQ/T2Catv9a1cvT
	ccwS9qLFPvF/fQvMFxV2PhL8cPGnutsG3Uyf7t7gowtizuutkz9Yta3E3+GkUNEyX/kzWpe7
	rqrUOD2oX3Ouos3i6KqLuTnroj3/vw3jbOTXctjHLSewJK6GbUOgEktxRqKhFnNRcSIA2TYZ
	X6QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-08-27 at 14:52 +0100, Lee Jones wrote:
> On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
> 
> > Add support for MAX77836 charger to the max14577 driver. The MAX77836
> > charger is almost the same as 14577 model except:
> >  - No dead-battery detection;
> >  - Support for special charger (like in MAX77693);
> >  - Support for DX over-voltage protection (like in MAX77693);
> >  - Lower values of charging current (two times lower current for
> >    slow/fast charge, much lower EOC current);
> >  - Slightly different values in ChgTyp field of STATUS2 register. On
> >    MAX14577 0x6 is reserved and 0x7 dead battery. On the MAX77836 the
> >    0x6 means special charger and 0x7 is reserved. Regardless of these
> >    differences the driver maps them to one enum max14577_muic_charger_type.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Anton Vorontsov <anton@enomsg.org>
> > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/power/Kconfig                |  4 +-
> >  drivers/power/max14577_charger.c     | 77 +++++++++++++++++++++++++++++-------
> >  include/linux/mfd/max14577-private.h | 54 ++++++++++++++++++-------
> 
> Not quite so important here, but better to break these out too.  We
> can arrange ourselves to that the set can go in together.  Just make
> sure it's bisectable.

Are you sure? This will result in a patch which adds some
code/symbols/defines used only by next (future) patch. Independent apply
of such patch still won't make any sense because there won't be any user
of this code.


Best regards,
Krzysztof


