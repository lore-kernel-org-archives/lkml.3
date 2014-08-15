Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaHOLNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:13:50 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40092 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHOLNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:13:49 -0400
Message-ID: <53EDEB66.1040304@collabora.co.uk>
Date: Fri, 15 Aug 2014 13:13:42 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Tim Kryger <tim.kryger@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask
 is empty.
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk> <CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com> <20140814151958.GY17528@sirena.org.uk> <CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com> <53EDBB5B.4000209@collabora.co.uk> <20140815095528.GH17528@sirena.org.uk>
In-Reply-To: <20140815095528.GH17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 08/15/2014 11:55 AM, Mark Brown wrote:
> On Fri, Aug 15, 2014 at 09:48:43AM +0200, Javier Martinez Canillas wrote:
> 
>> But now I wonder why regulator_list_voltage() even list the voltage for
>> fixed regulators (desc->fixed_uV) since they don't have the ability to
> 
> That's because it's very cheap to do and there is a comprehensible thing
> we can return - if we have to read the voltage that means potentially
> asking the hardware in an I2C transaction which is not cheap.
> 

Thanks a lot for the explanation, that does make a lot of sense.

> 
> There's plenty of potentially variable regulators used in these
> situations, I expect it's more likely that people were just ignoring the
> warning since it has no practical effect.
> 

Indeed.

Best regards,
Javier
