Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaH2LSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:18:45 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:57553 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaH2LSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFoeONs8OXZ3=2ZT54Nfdq_dLqgatMcq2DyZ=rs1r0x+dg@mail.gmail.com>
References: <1408585989-1084-1-git-send-email-chanho.min@lge.com>
	<CAPDyKFoeONs8OXZ3=2ZT54Nfdq_dLqgatMcq2DyZ=rs1r0x+dg@mail.gmail.com>
Date: Fri, 29 Aug 2014 13:18:42 +0200
Message-ID: <CAPDyKFrgu04FTWeSkWz1-YeHqSUe+9BE1Jk4wqBugVK4Ze90mw@mail.gmail.com>
Subject: Re: [PATCH] mmc:sdhci: handle busy-end interrupt during command
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Chanho Min <chanho.min@lge.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hankyung Yu <hankyung.yu@lge.com>,
        Gwendal Grignou <gwendal@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 August 2014 09:26, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 21 August 2014 03:53, Chanho Min <chanho.min@lge.com> wrote:
>> It is fully legal for a controller to start handling busy-end interrupt
>> before it has signaled that the command has completed. So make sure
>> we do things in the proper order, Or it results that command interrupt
>> is ignored so it can cause unexpected operations. This is founded at some
>> toshiba emmc with the bellow warning.
>>
>> "mmc0: Got command interrupt 0x00000001 even though
>> no command operation was in progress."
>>
>> This issue has been also reported by Youssef TRIKI:
>> It is not specific to Toshiba devices, and happens with eMMC devices
>> as well as SD card which support Auto-CMD12 rather than CMD23.
>>
>> Also, similar patch is submitted by:
>> Gwendal Grignou <gwendal@chromium.org>
>>
>> Signed-off-by: Hankyung Yu <hankyung.yu@lge.com>
>> Signed-off-by: Chanho Min <chanho.min@lge.com>
>> Tested-by: Youssef TRIKI <youssef.triki@st.com>
>
> Hi Chanho,
>
> This patch has been around for quite some time, sorry for lack of
> response. Appreciate if we could get this tested on a few more
> variants of sdhci, I am not able to test myself.
>
> I plan to queue this for 3.18, unless someone objects soon.

Hi Chanho,

I was about to apply this one, but I am hitting a conflict. Even if
wasn't too hard for me to resolve it, I think it might need an extra
round of testing. Could you please re-spin and send a new version?

Kind regards
Uffe
