Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3AJX5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:57:38 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:53567 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3AJX5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:57:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=W_++TL0+5iu=HUchGQ47q4AWxNi5sy37ysM=EMb+NFmA@mail.gmail.com>
References: <1354251857-21587-1-git-send-email-dianders@chromium.org>
	<1357842269-15062-1-git-send-email-dianders@chromium.org>
	<20130110230121.GA20584@quad.lixom.net>
	<CAD=FV=W_++TL0+5iu=HUchGQ47q4AWxNi5sy37ysM=EMb+NFmA@mail.gmail.com>
Date: Thu, 10 Jan 2013 15:57:31 -0800
Message-ID: <CAD=FV=UkbSF9qXvV2eSh=OhD726sp7oT4qxQAb+7dr3WQQnubA@mail.gmail.com>
Subject: Re: [REPOST PATCH v3 1/4] mmc: dw_mmc: Add "disable-wp" device tree property
From: Doug Anderson <dianders@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Olof Johansson <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Will Newton <will.newton@imgtec.com>, Chris Ball <cjb@laptop.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A followup as I did more investigation here...

On Thu, Jan 10, 2013 at 3:23 PM, Doug Anderson <dianders@chromium.org> wrote:
> Olof,
>
> Thanks for your comments.
>
> On Thu, Jan 10, 2013 at 3:01 PM, Olof Johansson <olof@lixom.net> wrote:
>>
>> The previous code used the controller-common quirk field to set a
>> per-controller DW_MCI_QUIRK_NO_WRITE_PROTECT. Is there really need to
>> do this per-slot? And if so, please explain in the commit message why
>> there is need for a brand new quirk for the same functionality.
>
> I'm happy to move back to using a per-controller quirk here--it
> simplifies the code quite a bit since it can use all of the
> preexisting quirks code.  I originally coded it up as per-slot since
> generally each slot needs its own write-protect line.  Without ever
> seeing any hardware using multiple slots per controller I can't say
> how common this would be, so it may be overkill to handle that
> situation.

Actually, it looks like the per-controller
DW_MCI_QUIRK_NO_WRITE_PROTECT was added at the same time as the code
using it was added to 'drivers/mmc/host/dw_mmc-exynos.c'.  Since this
patch series removes the code from dw_mmc-exynos.c I can also remove
the controller-level quirk.

...I'll plan to spin a new rev tomorrow that leaves the 'no write
protect' quirk at the slot level but removes the old controller-level
quirk.  :)

-Doug
