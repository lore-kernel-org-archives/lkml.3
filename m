Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab3GJPIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:08:31 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36156 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3GJPI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <51DD1D46.2000001@imgtec.com>
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
	<1373411961-23812-1-git-send-email-dianders@chromium.org>
	<1373411961-23812-3-git-send-email-dianders@chromium.org>
	<51DD1D46.2000001@imgtec.com>
Date: Wed, 10 Jul 2013 08:08:28 -0700
X-Google-Sender-Auth: ohwGOj3rdoqzRf4WOYfp2W3QeO8
Message-ID: <CAD=FV=VmWHfM-Y5O41hwH7kbXR7QpitgCcD9R4g8V-Tqr0fiog@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] mmc: dw_mmc: Add suspend_noirq/resume_noirq
 callbacks for dw_mmc-pltfm
From: Doug Anderson <dianders@chromium.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

On Wed, Jul 10, 2013 at 1:37 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> -SIMPLE_DEV_PM_OPS(dw_mci_pltfm_pmops, dw_mci_pltfm_suspend, dw_mci_pltfm_resume);
>> +const struct dev_pm_ops dw_mci_pltfm_pmops = {
>> +     SET_SYSTEM_SLEEP_PM_OPS(dw_mci_pltfm_suspend, dw_mci_pltfm_resume)
>> +     .suspend_noirq = dw_mci_pltfm_suspend_noirq,
>> +     .resume_noirq = dw_mci_pltfm_resume_noirq,
>> +};
>
> Does Exynos support hibernation? I see that SET_SYSTEM_SLEEP_PM_OPS sets
> freeze, thaw, poweroff, and restore callbacks too. You may not need the
> hibernation specific _noirq callbacks though in which case it's probably
> fine as it is.

Thank you for your review and good suggestions.  You're right that I
should add the other "noirq" variants in here.  Even if hibernation
isn't supported now that's the right thing to do.  I will fix that and
send v3 with your "Reviewed-by".


-Doug
