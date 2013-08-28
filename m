Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3H1DYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 23:24:37 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:48871 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3H1DYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 23:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130828031122.GA11625@kroah.com>
References: <1377657163-6606-1-git-send-email-festevam@gmail.com>
	<20130828031122.GA11625@kroah.com>
Date: Wed, 28 Aug 2013 00:24:35 -0300
Message-ID: <CAOMZO5DMBh++42AQJPAA+tcuC_c=Mzdw5N_oJGyVDvt1JRF4_A@mail.gmail.com>
Subject: Re: [PATCH] imx-drm: Fix probe failure
From: Fabio Estevam <festevam@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Aug 28, 2013 at 12:11 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Aug 27, 2013 at 11:32:43PM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> Since commit b5dc0d10 (drm/imx: kill firstopen callback) the following probe
>> failure is seen:
>
> I don't have that commit in any tree I control, so I can't apply this
> patch.  What tree is this commit in?

Ok, understood.

Just realized that this commit reached linux-next via Dave Airlie's tree:

commit b5dc0d108cd3c0b50ddcb6f6c54be1
bea4c39e01
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Aug 8 15:41:13 2013 +0200

    drm/imx: kill firstopen callback

    This thing seems to do some kind of delayed setup. Really, real kms
    drivers shouldn't do that at all. Either stuff needs to be dynamically
    hotplugged or the driver setup sequence needs to be fixed.

    This patch here just moves the setup at the very end of the driver
    load callback, with the locking adjusted accordingly.

    v2: Also move the corresponding put from ->lastclose to ->unload.

    Cc: Sascha Hauer <s.hauer@pengutronix.de>
    Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

Will resend it to Dave then.

Thanks,

Fabio Estevam
