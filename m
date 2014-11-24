Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaKXNVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:21:09 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41288 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaKXNVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:21:03 -0500
Date: Mon, 24 Nov 2014 14:21:00 +0100
From: Johan Hovold <johan@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v4 1/2] of: Rename "poweroff-source" property to
 "system-power-controller"
Message-ID: <20141124132100.GD6875@localhost>
References: <1415885699-1465-1-git-send-email-user@radxa>
 <1415885699-1465-2-git-send-email-user@radxa>
 <20141121105951.GA20679@localhost>
 <20141124102456.GE4241@x1>
 <20141124113518.GC6875@localhost>
 <CABgxDoLA=QL6vzU-v1w4vMZ3qhorjRdYOWFFMrjJE6xvZ7QO3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoLA=QL6vzU-v1w4vMZ3qhorjRdYOWFFMrjJE6xvZ7QO3g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 01:58:50PM +0100, Romain Perier wrote:
> 2014-11-24 12:35 GMT+01:00 Johan Hovold <johan@kernel.org>:

> > You should also fix the commit message, which claims to define a "helper
> > function which is compatible with both properties", something which was
> > no longer the case.
> >
> So I need to resend this patch which would only introduce an helper
> function which checks for "system-power-controller" property (it would
> also have a new commit message).
> As you suggested, this helper might be named
> "of_device_is_system_power_controller" ?

Correct. Rename the helper and property name you introduced to
"of_device_is_system_power_controller" and "system-power-controller" and
update the act8865 driver to use the new names (all in one patch).

Send the patch to Mark (and keep everyone else one CC) so he can apply
it to the regulator tree.

Other drivers that are currently using "ti,system-power-controller" can
continue to do so (for backward compatibility), while we later also add
a call to your helper function (and update binding documentation) and
also update the device trees for boards that use this functionality.

Thanks,
Johan
