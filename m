Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaBQTUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:20:35 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60622 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaBQTUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:20:33 -0500
Date: Mon, 17 Feb 2014 11:20:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 01/15] Input - arizona-haptics: Fix double lock of
 dapm_mutex
Message-ID: <20140217192025.GB19223@core.coreip.homeip.net>
References: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392655903-24537-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392655903-24537-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Charles,

On Mon, Feb 17, 2014 at 04:51:29PM +0000, Charles Keepax wrote:
> snd_soc_dapm_sync takes the dapm_mutex internally, but we currently take
> it externally as well. This patch fixes this.

Hmm, from the first glance this needs to go into current release,
however it seems that it has been broken by
a73fb2df01866b772a48fab93401fe3edbe0b38d 2 years ago so nobody cares...

Looking at the series I am not sure that this is right direction. You
actually do want unlocked versions of snd_soc_dapm_* functions so that
callers can take dapm mutex and then perform sequence of operations. The
currect callers that were taking the mutex should probbaly be changed so
that they do not drop it until they called unlocked version of
snd_soc_dapm_sync().

Thanks.

-- 
Dmitry
