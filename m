Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaIKMc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:32:26 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:49428 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaIKMcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:32:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Douglas Anderson <dianders@chromium.org>, dtor <dtor@chromium.org>,
        Chris Zhong <zyw@rock-chips.com>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        zhaoyifeng <zyf@rock-chips.com>
Subject: Re: [PATCH v4 2/4] dt-bindings: document Rockchip thermal
Date: Thu, 11 Sep 2014 14:32:08 +0200
Message-ID: <40514790.Xc34lyFLGa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140911121842.GB26715@developer>
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com> <1410403012.25559.69.camel@rzhang1-toshiba> <20140911121842.GB26715@developer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:S1hsm6ZsnHTZhR9lpuBHZa0JZZLRV5TFXJLw/gcIvV2
 169JWLWfoQQ1OG17AMeVppjXlRWKKa6rq9f4p8R28YunH09K3+
 OVusjZaZIXcwff7ZwLbc+c1MM/6Xss5C47LndUErVdfrrp8cq9
 oaU21bbayTWZfJJbAbyvFfUC2LjpJvpBbF61whyJM3+I2NUi3i
 wGcycJuGpBjqgtvCQCnktkndiQIDdEKZb6uPEhC+Z8BNNNxdiq
 hSH8PU0qv1/as/9C26uO0iXOQqyTZfBEUm+9iUNwqnEBhDVJzb
 cbcWdrCOIaY8NCBrL/+aKlizOjN7JLVFpq9tAzd8jyu93Y75Rq
 7woemslhxp9lHi9De5D0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2014 08:18:43 Eduardo Valentin wrote:
> > As what we want is to make thermal driver have a chance to configure the
> > hardware shutdown registers, I'm thinking if we can do this without
> > representing the hardware shutdown value as a trip point.
> > Say,
> > 1. parse DT, and get the hardware shutdown temperature value, and store
> > it somewhere, e.g. struct __thermal_zone.
> > 2. introduce a new parameter, int (*set_hardware_trip)(void *, long *),
> > in thermal_zone_of_sensor_register().
> > 3. invoke set_hard_trip(tz, hardware_shutdown_temperature_value) in
> > thermal_zone_of_sensor_register().
> 
> The only issue I have with the above proposal is that not all platforms
> use DT. Some still boot with boardfiles, for instance. Thus, the
> parameter to configure hardware thermal shutdown needs to be common on
> thermal core, not specific to of-thermal. Do you agree?

Do you know of a machine that can't yet be converted to DT and that
needs this driver? In case of rockchips that is certainly not the
case, and we don't care about anybody trying to use board files out
of tree, they can just hack the thermal support as well.

	Arnd
