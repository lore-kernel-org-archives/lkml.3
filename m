Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaJWMZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:25:46 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:62044 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbaJWMZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:25:41 -0400
MIME-Version: 1.0
In-Reply-To: <20141022174544.GA4250@dtor-ws>
References: <1413882808-4669-1-git-send-email-jinkun.hong@rock-chips.com>
	<1413882808-4669-2-git-send-email-jinkun.hong@rock-chips.com>
	<20141021195854.GE8609@dtor-ws>
	<544725C4.4040703@rock-chips.com>
	<CAPDyKFp+aNJd_FEY6=-ubK0zvVDWh+x5ZsVG+AVpuBzpSqynOQ@mail.gmail.com>
	<20141022174544.GA4250@dtor-ws>
Date: Thu, 23 Oct 2014 14:25:40 +0200
Message-ID: <CAPDyKFoimakHLdonJ5-NuCpNceU+s4ie8a5n9sLiMCrwrhWcfA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] power-domain: add power domain drivers for
 Rockchip platform
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hong jinkun <jinkun.hong@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Jack Dai <jack.dai@rock-chips.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2014 19:45, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Wed, Oct 22, 2014 at 09:58:34AM +0200, Ulf Hansson wrote:
>>
>> Using the devm_*API is supposed to work from here. I have kept this in
>> mind, while we added the new dev_pm_domain_attach|detach() API. The
>> buses also handles -EPROBE_DEFER.
>
> How do you ensure this? You have no control over from where API is
> called. If I happen to call it form anywhere but bus probe code path I
> will be leaking memory at least until the device is unbound completely
> (which would be in this case an unrelated event).

You are right, devm_*API is currently not a good idea! I didn't
realize that the ->attach_dev() callback was invoked from
__pm_genpd_add_device(). Sorry for the noise.

Anyway,  I am working on adding the option to return -EPROBE_DEFER
from the ->attach_dev() callback, since that could be useful to
support.

Kind regards
Uffe
