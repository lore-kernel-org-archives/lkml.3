Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaIDKdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:33:36 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34569 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaIDKde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAL8zT=i-T9DHd1F5=YpovM9i0LwpUswm6am1Qyf6kG_g3Xj2Qg@mail.gmail.com>
References: <1409672977-26972-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <CAPDyKFrwCzQJvbpbue4T=HWLmbq5sZOP3RXwiupKvXe71uboUw@mail.gmail.com>
 <5406D942.4080405@intel.com> <CAPDyKFrnF4biUGkLgkzz2RNdY1yLp2_bfvoWMM55yx-_TG6ENw@mail.gmail.com>
 <CAL8zT=j0TfC=RaA5L+Zm3ACk=D57tb+k6HNrQnSjd4JY_iupCQ@mail.gmail.com>
 <CAPDyKFoe6Zkr+QLZRc3azn8JvpsQXdSNLHTLmy5O-nnbVy9C1A@mail.gmail.com> <CAL8zT=i-T9DHd1F5=YpovM9i0LwpUswm6am1Qyf6kG_g3Xj2Qg@mail.gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Thu, 4 Sep 2014 12:33:18 +0200
X-Google-Sender-Auth: QiXXn5A3GLZmYnYUpHN2-s93TK0
Message-ID: <CAL8zT=hkvFvnrswRnQRV4LXHOUxHqTVUQDjhDnhBcRRSEFjEhA@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: Enable boot partition access from DT
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <b29396@freescale.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Chris Ball <chris@printf.net>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-04 11:37 GMT+02:00 Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com>:
> Hi Ulf,
>
>> I am not sure adding a DT binding for non access to rpmb would be
>> needed. At least until we heard of a similar case as Adrian describes
>> but for rpmb.
>>
>> BTW, I just posted a patch which disabled partition scan of the boot
>> area, what to you think about that?
>> http://marc.info/?l=linux-mmc&m=140973496402028&w=2
>>
>> Finally I am also wondering whether we could and thus should, handle
>> these situations entirely without using a host cap. In principle what
>> we need is a more sophisticated error handling when the switch errors
>> occurs, while trying to switch to the boot area/rpmb partitions. Could
>> you maybe investigate that option, before we decide to add a new DT
>> binding?
>
> According to me and what Hsin-Hsiang Tseng wrote, it seems that we
> should be able to have access to boot partitions if we want to give a
> possibility of writing u-boot in one (or both) of them. This is the
> way the i.MX6 will boot on a eMMC if I read the reference manual
> correctly, but I didn't tested it yet.
> But there is no need to scan those partitions at boot, as there will
> probably never be a partition table inside, as you said.
> All we need is providing access to mmc[n]blkpboot0 and mmc[n]blkpboot1
> and a way to tell which one is used as default boot partition.
>
> This is my point of view, but I didn't read JESD84-A441 so I don't
> know if this is the good way.
>
> Regards,
> JM

BTW, here is an interesting commit from Freescale tree :
http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git/commit/?h=imx_3.10.17_1.0.0_ga&id=28774b788ae0de5d88045dd60cac3656c305821d

JM
