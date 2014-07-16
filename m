Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaGPWb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:31:59 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49949 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaGPWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:31:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140716173528.GF2759@katana>
References: <1403654214-25072-1-git-send-email-dianders@chromium.org>
	<20140716173528.GF2759@katana>
Date: Wed, 16 Jul 2014 15:31:54 -0700
X-Google-Sender-Auth: qWCxF-DGOySRGyxMZv4VsrSeEBM
Message-ID: <CAD=FV=W6OCzXOE9gz9qxGggiVeTHiveg7W-1hnF3_-OKy7RLKQ@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: s3c2410: resume the I2C controller earlier
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vincent Palatin <vpalatin@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

On Wed, Jul 16, 2014 at 10:35 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Tue, Jun 24, 2014 at 04:56:54PM -0700, Doug Anderson wrote:
>> From: Vincent Palatin <vpalatin@chromium.org>
>>
>> When the wake-up is triggered by the PMIC RTC, the RTC driver is trying
>> to read the PMIC interrupt status over I2C and fails because the I2C
>> controller is not resumed yet.
>> Let's resume the I2C controller earlier in the _noirq phase
>> (as other hardwares are doing), so we can properly get the wake-up
>> condition.
>>
>> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>
> Applied to for-current (because Tomasz said it fixes issues), thanks! If
> you think the exynos patch of the same style should also be in current,
> please let me know...

Thanks!  I don't think the exynos one needs to go into for-current.
for-next is enough.  :)

-Doug
