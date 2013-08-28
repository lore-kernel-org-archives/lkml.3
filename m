Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3H1WaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:30:10 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:33503 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3H1WaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:30:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130828203418.GW30088@pengutronix.de>
References: <1377657163-6606-1-git-send-email-festevam@gmail.com>
	<20130828052758.GQ30088@pengutronix.de>
	<CAOMZO5BiE7tqja9p51gOGEwtWsKjyX23qZ3=ewyuubMwsgXcLA@mail.gmail.com>
	<20130828185459.GV30088@pengutronix.de>
	<CAOMZO5CuGAH+5+8cE7tjzZTXhLbFxMRt13mhimuBLJkRQz6+7Q@mail.gmail.com>
	<20130828203418.GW30088@pengutronix.de>
Date: Wed, 28 Aug 2013 19:30:08 -0300
Message-ID: <CAOMZO5Bv1sQVw5O=tYz2kZoQhnPSNXUn7EchBCNUXA_tpbyt4g@mail.gmail.com>
Subject: Re: [PATCH] imx-drm: Fix probe failure
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 5:34 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, Aug 28, 2013 at 05:10:16PM -0300, Fabio Estevam wrote:
>> On Wed, Aug 28, 2013 at 3:54 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>>
>> > Do the open/close callbacks work?
>>
>> The 'open' callback maps to the generic 'drm_open', so we cannot use it.
>
> We could replace this, but...
>
>>
>> Shouldn't we rely on the refcount done by the drm core instead of
>> doing this manually in imx-drm?
>
> ...This could be a better solution.
>
> you mean (struct drm_device)->open_count, right?

Yes, and open_count is already handled by drm_open/drm_release
callbacks, which is something we currently use inside imx-drm-core.
