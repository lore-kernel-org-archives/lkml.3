Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbbAYQDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:03:50 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:62779 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbbAYQDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:03:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMht4VaNgwr5rOyher081Vk7w_HKTMeOm677rEAkOcCPAg@mail.gmail.com>
References: <alpine.DEB.2.02.1501191226010.2973@galak-ubuntu.qualcomm.com>
	<20150122011521.GA31815@quad.lixom.net>
	<D177DF12-0F31-49CF-B98B-9FAC23AAB24C@codeaurora.org>
	<CAOesGMipp=Odc-cWvrba0e1pd1X7O+PKNH+WoM3fG4xX2GRFuA@mail.gmail.com>
	<DBE63F76-D4CB-49D5-90C6-642CFCA7687F@codeaurora.org>
	<CAOesGMht4VaNgwr5rOyher081Vk7w_HKTMeOm677rEAkOcCPAg@mail.gmail.com>
Date: Sun, 25 Jan 2015 11:03:47 -0500
Message-ID: <CAF6AEGuLu+KYwBX59T4-SThPDJCYwKDU6_qWf7d80Dae6FAmbQ@mail.gmail.com>
Subject: Re: [GIT PULL] qcom SoC changes for v3.20
From: Rob Clark <robdclark@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Kumar Gala <galak@codeaurora.org>, Olav Haugan <ohaugan@codeaurora.org>,
        Kevin Hilman <khilman@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Lina Iyer <lina.iyer@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thierry Reding <treding@nvidia.com>, daeinki <inki.dae@samsung.com>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 1:43 PM, Olof Johansson <olof@lixom.net> wrote:
>>> I'd be OK with merging this, send a request and tag. Would that let
>>> the DRM folks make progress too?
>>
>> Will do, I don’t think it will address the DRM folks needs as they need access to make firmware calls from the DRM driver.
>>
>>> If you need a common place for this, drivers/firmware seems like a
>>> better home than drivers/soc.
>>
>> Agreed, what’s you take than on moving to use firmware_ops as defined in arch/arm and extended it or just leaving this as a qcom specific firmware interface?
>
> Are there any other SoCs out there with similar requirements on
> firmware interfaces? I think most of them so far have been fairly
> simple compared to the complexity of the qualcomm firmware.

I think the question is probably "how do downstream HDCP
implementations work on these other SoCs"..   so far, I think qcom is
the first to try to upstream HDCP support, but I know there have to be
at least a few downstream implementations lurking out there.

And I'm sure as some others come out of the woodwork there will be
some things to refactor.. like possibly shared helpers for
implementing the state machine, etc.

BR,
-R

> Would it make sense to use firmware_ops for the common pieces and have
> direct smc calls for the rest? I'm not sure that would buy us all that
> much. Hm.
>
> Well, at least it's an internal implementation detail. If we move it
> now and find a better way to do it down the road it can be refactored.
