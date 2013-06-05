Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3FEMNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:13:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3FEMNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:13:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, patches@lists.linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 15/15] OF: remove #ifdef from linux/of_platform.h
Date: Wed, 05 Jun 2013 14:13:23 +0200
Message-ID: <18275402.lrMAtEkNSk@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAL_JsqLRJ1cEWBfAdHEyngJHQKauJ6XzWH2JwXh1qDusMkzUGA@mail.gmail.com>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <201306041951.00447.arnd@arndb.de> <CAL_JsqLRJ1cEWBfAdHEyngJHQKauJ6XzWH2JwXh1qDusMkzUGA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0gm0+EfrDq9bq2hd+ldiAZ7VjTeBb49KXa9y3S2Lk4U
 u+tPMomIxSzDXeSF+vK+WqIXSuknlzMAMGQ+InIT9bL03daj5s
 U69ErNxekVMfNRjgKwsmzbs/HzoTH5AIw2P5tQSk/q4D66ZLFn
 dtZlD3D1SnLdsp9JiL/K/LDGRx9j+B5ZLxCxbjK+rRTM/a1aLi
 dT6MZ3X2Lyc1GQG4ULHoNMKMebRSNbgzm/UgKwjNJfJPLhuhvB
 Ay5kVvxlrtTPrdM9bMKefLhgQG8xDt3kZBtjIE3MB+ns805wj5
 IX56DFbj+Epr78cJmSPIMTHaBy9p6svoRvgVHIuDprYsqOnBNb
 xV1Xgk03m+xq8CWgwO8Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 17:24:51 Rob Herring wrote:
> 
> Right. I get all that. You still have to go add inlines if you want to make:
> 
> if (IS_ENABLED(CONFIG_OF))
>     of_foo();
> 
> just be:
> 
> of_foo();
> 
> There are situations for both and only inlines cover both cases. I
> don't see a reason we would want to allow the first case and not allow
> the second case. I am tired of taking patches adding the inlines 1 by
> 1, so perhaps we need to refactor the OF headers to better separate
> core infrastructure includes vs. driver only includes if that is
> really a concern.

Ok, fair enough. Putting internal declarations into a local header
file would be best of course.

	Arnd
