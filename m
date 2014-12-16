Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095AbaLPFi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:38:29 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:36823 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaLPFi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:38:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAE_wzQ_Lz7pv1io6UMAXjesVeurbC=as2BuxBrA+XXkh5b+AWA@mail.gmail.com>
References: <20141216001058.GA31286@dtor-ws>
	<CAKohpo=mcG99N5q_CCua8Hdydo=ydHKD-CiTJO9SsAhLvkTJHw@mail.gmail.com>
	<CAE_wzQ_Lz7pv1io6UMAXjesVeurbC=as2BuxBrA+XXkh5b+AWA@mail.gmail.com>
Date: Tue, 16 Dec 2014 11:08:27 +0530
Message-ID: <CAKohpon_z5duigPptOpT1wrLkWLgDqGQq8+1J7oofujy7Q4MtA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq-dt: defer probing if OPP table is not ready
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lucas Stach <l.stach@pengutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2014 at 11:02, Dmitry Torokhov <dtor@chromium.org> wrote:
> Yes we will. Which simply means that this WARN is stupid. We also will
> hit it if there is no opp table and the allocation below fails; or if
> it succeeds then dev_pm_opp_init_cpufreq_table() will fail and we'll
> hit this code path again.
>
> We should either drop that WARN() or handle -ENODEV there properly.

Yeah, we should drop it. Its just too hard for such cases. You will take care
of that in your series?

For your patch:

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

--
viresh
