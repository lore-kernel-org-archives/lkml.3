Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbaIKPxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:53:46 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:58970 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbaIKPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:53:43 -0400
Date: Thu, 11 Sep 2014 11:53:27 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
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
Message-ID: <20140911155324.GA27076@developer>
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com>
 <1410403012.25559.69.camel@rzhang1-toshiba>
 <20140911121842.GB26715@developer>
 <40514790.Xc34lyFLGa@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40514790.Xc34lyFLGa@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Thu, Sep 11, 2014 at 02:32:08PM +0200, Arnd Bergmann wrote:
> On Thursday 11 September 2014 08:18:43 Eduardo Valentin wrote:
> > > As what we want is to make thermal driver have a chance to configure the
> > > hardware shutdown registers, I'm thinking if we can do this without
> > > representing the hardware shutdown value as a trip point.
> > > Say,
> > > 1. parse DT, and get the hardware shutdown temperature value, and store
> > > it somewhere, e.g. struct __thermal_zone.
> > > 2. introduce a new parameter, int (*set_hardware_trip)(void *, long *),
> > > in thermal_zone_of_sensor_register().
> > > 3. invoke set_hard_trip(tz, hardware_shutdown_temperature_value) in
> > > thermal_zone_of_sensor_register().
> > 
> > The only issue I have with the above proposal is that not all platforms
> > use DT. Some still boot with boardfiles, for instance. Thus, the
> > parameter to configure hardware thermal shutdown needs to be common on
> > thermal core, not specific to of-thermal. Do you agree?
> 
> Do you know of a machine that can't yet be converted to DT and that
> needs this driver? In case of rockchips that is certainly not the
> case, and we don't care about anybody trying to use board files out
> of tree, they can just hack the thermal support as well.

I see. Again, the only concern I have is to produce thermal framework APIs
that would be only in the of-thermal. My point is not specific to this
patch, or this platform, but with a detail in the above proposal. 

While I agree to have a trip specific to configurable hardware triggered
thermal shutdown, I just don't see why it needs to be a feature
implemented only via of-thermal. It has to be properly defined in
thermal core.

The proposal of of-thermal is not to become a separate/competing thermal
framework.

> 
> 	Arnd

Cheers,

Eduardo
