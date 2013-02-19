Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934612Ab3BSWEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:04:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3BSWEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:04:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 06/35] mfd: ab8500-core: Sysfs chip id modification
Date: Tue, 19 Feb 2013 22:04:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, linus.walleij@stericsson.com,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org> <1360933026-30325-7-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1360933026-30325-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302192204.45153.arnd@arndb.de>
X-Provags-ID: V02:K0:Ij+yrQBnMujli0zQWutFEXB7ai1ka3sluZ8/L0TRgzD
 5Q3y3oa1fEEIPcUujGSYay87guG7rdGqsn4PCMSnuTkFe5c0c7
 grRk+ALEvh3ROy608kY9GUyeJbM7i7gyvYXJHZy0iEWGFtDOxJ
 J6ZIUGmjBSuabfUqw2Bn3rPdwRtK4+bgQvLydVHtZsu3eVa8bC
 eEa9ghs1X+ssASiITne3naSZ7hcOi/wBAkri/KKHHPd+wX4tQa
 CdOCCA/Ot4xy57+obIFuJ9VWOZiOkGBIaAaTwk04FIIpTjHn0W
 63g55c72UavVAFkMViFbW+Mhd/XsO6ZMHa8M9auZbPU5DLnFhd
 MUJGFBl8g9XdsfYpkAfM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2013, Lee Jones wrote:
>         struct ab8500 *ab8500;
> +       int chip_id = -EINVAL;
>
>         ab8500 = dev_get_drvdata(dev);
> -       return sprintf(buf, "%#x\n", ab8500 ? ab8500->chip_id : -EINVAL);
> +       if(ab8500) {
> +               chip_id = ab8500->chip_id;
> +               if((is_ab8505(ab8500) || is_ab9540(ab8500)) && ab8500->version != 0xFF)
> +                       chip_id = (ab8500->version << 8) | chip_id;
> +       }
> +       return sprintf(buf, "%#x\n", chip_id);
>  }

What's the use of printing "ffffffea" for unknown versions here?

	Arnd
