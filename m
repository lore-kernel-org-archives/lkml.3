Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaHPNa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 09:30:28 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:62777 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaHPNa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 09:30:26 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.143.178]
In-Reply-To: <20140812215515.GC17528@sirena.org.uk>
References: <1407807429.8958.1.camel@phoenix>
	<20140812215515.GC17528@sirena.org.uk>
Date: Sat, 16 Aug 2014 21:30:26 +0800
Message-ID: <CAFRkauB493XsKvLi_B=rEUdrL84vGDOuEg3e_V+yGQp=QhXxiw@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: Add stub for devm_regulator_get_exclusive
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Rob Clark <robdclark@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-13 5:55 GMT+08:00 Mark Brown <broonie@kernel.org>:
> On Tue, Aug 12, 2014 at 09:37:09AM +0800, Axel Lin wrote:
>> Fix below build error when !CONFIG_REGULATOR.
>>
>>   CC      drivers/gpu/drm/msm/hdmi/hdmi.o
>> drivers/gpu/drm/msm/hdmi/hdmi.c: In function 'hdmi_init':
>> drivers/gpu/drm/msm/hdmi/hdmi.c:126:3: error: implicit declaration of function 'devm_regulator_get_exclusive' [-Werror=implicit-function-declaration]
>
> So, I just looked at that driver - it errors out on probe without the
> regualtor.  Are you sure the fix isn't to add a dependency on the
> regulator API or convert it back to using normal regulator gets (it was
> converted without comment as part of a DT conversion), or indeed to
> using the bulk regulator API.  It looks awfully like the driver is just
> open coding devm_regulator_bulk_get() and friends.
>
> There is no explanation at all in either the changelog or the code for
> why the driver is asking for exclusive regulators.
Hi Rob,
Any feedback about Mark's comment?

Hi Mark,
Even though not for this build fix, I think the patch is still good.
Should I remove the build error message and resend the patch to you?

Regards,
Axel
