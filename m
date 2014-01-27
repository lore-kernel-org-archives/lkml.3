Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaA0Jyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:54:54 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:45879 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaA0Jyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:54:53 -0500
Date: Mon, 27 Jan 2014 09:54:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: max14577: max14577_{suspend,resume}() should
 depend on CONFIG_PM_SLEEP
Message-ID: <20140127095432.GB14478@lee--X1>
References: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
 <1390811288.4974.4.camel@AMDC1943>
 <CAMuHMdU8otOO+FdNDJA0WnMz8omH2P0ebQ23sW8KdAfCbb74FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdU8otOO+FdNDJA0WnMz8omH2P0ebQ23sW8KdAfCbb74FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> If CONFIG_PM_SLEEP=n:
> >>
> >> drivers/mfd/max14577.c:177: warning: ‘max14577_suspend’ defined but not used
> >> drivers/mfd/max14577.c:200: warning: ‘max14577_resume’ defined but not used
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> ---
> >>  drivers/mfd/max14577.c |    2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> >> index ac514fb2b877..71aa14a6bfbb 100644
> >> --- a/drivers/mfd/max14577.c
> >> +++ b/drivers/mfd/max14577.c
> >> @@ -173,6 +173,7 @@ static const struct i2c_device_id max14577_i2c_id[] = {
> >>  };
> >>  MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
> >>
> >> +#ifdef CONFIG_PM_SLEEP
> >>  static int max14577_suspend(struct device *dev)
> >>  {
> >>       struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> >> @@ -208,6 +209,7 @@ static int max14577_resume(struct device *dev)
> >>
> >>       return 0;
> >>  }
> >> +#endif /* CONFIG_PM_SLEEP */
> >>
> >>  static struct of_device_id max14577_dt_match[] = {
> >>       { .compatible = "maxim,max14577", },
> >
> > Same here:
> > http://thread.gmane.org/gmane.linux.kernel/1615513/focus=1615563
> > although I don't mind if your patch comes in :).
> 
> Sorry, missed those.
> It's a pity these known fixes don't go in together with the code that introduces
> them...

Great idea. Can I borrow your time machine? ;)

Or, we can use the -rcs, as this is what they were designed for.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
