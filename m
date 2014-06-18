Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaFREyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 00:54:07 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:65126 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaFREyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 00:54:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAPnjgZ1+y6QYpdio9inzLTi9g4Ew7vkco_MU3GO1_gpndp3dxA@mail.gmail.com>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-11-git-send-email-dianders@chromium.org>
	<CAPnjgZ1+y6QYpdio9inzLTi9g4Ew7vkco_MU3GO1_gpndp3dxA@mail.gmail.com>
Date: Tue, 17 Jun 2014 21:54:03 -0700
X-Google-Sender-Auth: LRqp4Mmzaf7BHvxQrZUMAfr7f1U
Message-ID: <CAD=FV=W0L_D2GkeRb0+JLZAMk=2m2V3hOS4fFbXDtQHNoYxZvA@mail.gmail.com>
Subject: Re: [PATCH 10/10] mfd: cros_ec: ec_dev->cmd_xfer() returns number of
 bytes received from EC
From: Doug Anderson <dianders@chromium.org>
To: Simon Glass <sjg@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon,

On Tue, Jun 17, 2014 at 8:46 PM, Simon Glass <sjg@chromium.org> wrote:
> Hi,
>
> On 16 June 2014 14:40, Doug Anderson <dianders@chromium.org> wrote:
>> From: Bill Richardson <wfrichar@chromium.org>
>>
>> When communicating with the EC, the cmd_xfer() function should return the
>> number of bytes it received from the EC, or negative on error.
>
> This is just for the I2C tunnel feature, right? If so, I think this
> should be mentioned here. It seems to be affecting ec_i2c_xfer(), not
> cmd_xfer().

No, the tunnel feature is implemented just fine without this (and is
already landed and working).  It looks like the (not yet upstreamed)
ec_i2c_limited_xfer for spring returns this new value directly but I'm
not convinced that's technicall correct.

Bill can correct me if I'm wrong, but I think this is primarily
interesting once we add in cros_ec_dev (the userspace API) which needs
this info.  Until that happens this patch doesn't hurt and just
returns some extra info.

-Doug
