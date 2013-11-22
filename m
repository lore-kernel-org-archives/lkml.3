Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3KVLeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 06:34:31 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55493 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3KVLe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 06:34:29 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-c9-528f41438960
Message-id: <1385120065.6030.0.camel@AMDC1943>
Subject: Re: [PATCH v3 2/5] extcon: max14577: Add extcon-max14577 driver to
 support MUIC device
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Fri, 22 Nov 2013 12:34:25 +0100
In-reply-to: <20131122103533.GI14725@sirena.org.uk>
References: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
 <1385109972-28059-3-git-send-email-k.kozlowski@samsung.com>
 <20131122103533.GI14725@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t/xa7rOjv1BBi+a5S0ObtW02DhjPavF
	1IdP2Cyuf3nOajH/yDlWi4krJzNbHPizg9Hi3KuVjBZnm96wW9z/epTR4tuVDiaLTY+vsVos
	bFvCYnF51xw2i7VH7rJb3G5cwWYxYfpaFovDKw4wWax7OZ3F4nQ3q8Wrg20sDqIea+atYfRY
	8PkKu8eE/k+MHjtn3WX3WLn8C5vH5hVaHptWdbJ5vFo9k9XjzrU9bB7zTgZ6bF5S79G3ZRWj
	x+dNch4b54YG8EVx2aSk5mSWpRbp2yVwZZy8t4ypoJW1ounPA+YGxr/MXYycHBICJhKTNl9k
	gbDFJC7cW8/WxcjFISSwlFHi78fZTBDOZ0aJh18fsYFU8QroSfQ/P88IYgsLJEpcfHEZbBKb
	gLHE5uVLwGpEBJQlrn7fywLSzCzQyyYxY+NTdpAEi4CqxNGFh5hAbE6ghubLu9ghNqxjlGjc
	dIwVJMEsoC4xad4iqPuUJHa3d7JDxOUlNq95ywxxhaDEj8n3WCYwCsxC0jILSdksJGULGJlX
	MYqmliYXFCel5xrpFSfmFpfmpesl5+duYoRE8dcdjEuPWR1iFOBgVOLh3WHZFyTEmlhWXJl7
	iFGCg1lJhLfdtj9IiDclsbIqtSg/vqg0J7X4ECMTB6dUA6ORssVDr2ABt6h/ty4UpcinNO7r
	V750qW7X1rATu87FuZX13t71ce2fEOVjavn65SI++UGlW+9ELyoOm68lvkxU6cW6crsW43PP
	HL/KOU550PFFMGBxeK2PnfzCeVp3lBtfxBVolTfeOlSk07ngttI6hc2nNkv3vz2w/PfeVzvF
	k3XU3sT5/VBiKc5INNRiLipOBADHNRkQwAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 10:35 +0000, Mark Brown wrote:
> On Fri, Nov 22, 2013 at 09:46:09AM +0100, Krzysztof Kozlowski wrote:
> 
> > +#define	DELAY_MS_DEFAULT		17000		/* unit: millisecond */
> 
> This delay is sufficiently large that the delayed work using it probably
> ought to use the power efficient workqueues instead of just a regular
> schedule_delayed_work().  This will mean that instead of being scheduled
> on the core which scheduled it the work can run on any CPU, avoiding the
> need to power up a currently idle CPU just to run the work.

I'll fix this. Thanks for review of the patches.

Best regards,
Krzysztof


