Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaCMJoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:44:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38990 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaCMJoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:44:23 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-6a-53217df66c8c
Message-id: <1394703860.6546.1.camel@AMDC1943>
Subject: Re: [PATCH v3 2/4] mfd: max8997: handle IRQs using regmap
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Thu, 13 Mar 2014 10:44:20 +0100
In-reply-to: <1394703532-494-3-git-send-email-r.baldyga@samsung.com>
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-3-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xa7rfahWDDb71yFksuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi/tfjzJafLvSwWRx89M3VovLu+awWWx9s47R
	Yu2Ru+wWtxtXsFlc23uc2eLB4Z3sFrt3PWW12N/ZwWhxupvVQdhj56y77B57Jp5k89i8Qstj
	06pONo871/awecw7GeixZ/4PVo++LasYPabP+8nk8XmTnMf6LVuZArijuGxSUnMyy1KL9O0S
	uDLmbDrNXrCJveLfuqcsDYxnWbsYOTkkBEwkug++Z4SwxSQu3FvP1sXIxSEksJRR4tbzDiYI
	5zOjxPvuWywgVbwCehLzT/awgdjCAk4SD9/1MIHYbALGEpuXLwGLiwhoSdz5OJ8dpJlZ4DCz
	xL4HHWDrWARUJaYsmQZWxCngIrHvx2awZiGBWolPC8+A1TALqEtMmreIGeIkJYnd7Z3sEHF5
	ic1r3jJDHCEo8WPyPZYJjAKzkLTMQlI2C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5
	mxghcfllB+PiY1aHGAU4GJV4eFcsVwgWYk0sK67MPcQowcGsJMI7v1IxWIg3JbGyKrUoP76o
	NCe1+BAjEwenVANj5ptza/Kuhk2wueJy4ot3y2H1wgpbQdF0CdZ6pbSJdxokF8VfeNH/7q5Q
	PK9y2nwNk5v3znO/5g4rn/jl+VGBxffPGpfoxfZrzFbnvbx67T0e9sBPf6ZfN1gd/PTN56jM
	lSpSJ7JqF2YXXEjiDdw9pZPx/Opd5ad+F9qKamyzWPaq+ihfs1mIEktxRqKhFnNRcSIA2pcm
	I6kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 10:38 +0100, Robert Baldyga wrote:
> This patch modifies mfd driver to use regmap for handling interrupts.
> It allows to simplify irq handling process. This modifications needed
> to make small changes in function drivers, which use interrupts.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |    3 +-
>  drivers/mfd/Kconfig                 |    2 +-
>  drivers/mfd/Makefile                |    2 +-
>  drivers/mfd/max8997-irq.c           |  373 -----------------------------------
>  drivers/mfd/max8997.c               |  112 ++++++++++-
>  drivers/rtc/rtc-max8997.c           |    2 +-
>  include/linux/mfd/max8997-private.h |   63 +++++-
>  7 files changed, 165 insertions(+), 392 deletions(-)
>  delete mode 100644 drivers/mfd/max8997-irq.c

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>


Best regards,
Krzysztof Kozlowski

