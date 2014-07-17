Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbaGQRAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:00:41 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:61364 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbaGQRAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140717145958.GA32534@ulmo>
References: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
	<1405608520-5644-5-git-send-email-hechtb@gmail.com>
	<20140717145958.GA32534@ulmo>
Date: Thu, 17 Jul 2014 18:52:35 +0200
Message-ID: <CABYn4swY5yRe=eGzCYo0uJtmjn05Ut4oDWupPjmU9bXbuU6+Pw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] i2c: tegra: Remove suspension check
From: Bastian Hecht <hechtb@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-i2c@vger.kernel.org, Linux-SH <linux-sh@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "open list:TEGRA ARCHITECTUR..." <linux-tegra@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-17 16:59 GMT+02:00 Thierry Reding <thierry.reding@gmail.com>:
> On Thu, Jul 17, 2014 at 04:48:40PM +0200, Bastian Hecht wrote:
> [...]
>>  #ifdef CONFIG_PM_SLEEP
>> -static int tegra_i2c_suspend(struct device *dev)
>> -{
>> -     struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
>> -
>> -     i2c_lock_adapter(&i2c_dev->adapter);
>> -     i2c_dev->is_suspended = true;
>> -     i2c_unlock_adapter(&i2c_dev->adapter);
>> -
>> -     return 0;
>> -}
>> -
>>  static int tegra_i2c_resume(struct device *dev)
>>  {
>>       struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
>> @@ -842,14 +827,12 @@ static int tegra_i2c_resume(struct device *dev)
>>               return ret;
>>       }
>>
>> -     i2c_dev->is_suspended = false;
>> -
>>       i2c_unlock_adapter(&i2c_dev->adapter);
>>
>>       return 0;
>>  }
>>
>> -static SIMPLE_DEV_PM_OPS(tegra_i2c_pm, tegra_i2c_suspend, tegra_i2c_resume);
>> +static SIMPLE_DEV_PM_OPS(tegra_i2c_pm, tegra_i2c_resume);
>
> Shouldn't this be:
>
>         static SIMPLE_DEV_OPS(tegra_i2c_pm, NULL, tegra_i2c_resume);
>
> instead?

Oh yes thanks. I made the same mistake in [PATCH 3/5] too.

Thanks,

 Bastian



> Thierry
