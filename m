Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3FGSOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:14:51 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:62862 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab3FGSOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:14:47 -0400
MIME-Version: 1.0
In-Reply-To: <2536139.bTRcfOkXer@flatron>
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
	<1370626110-1731-1-git-send-email-dianders@chromium.org>
	<2536139.bTRcfOkXer@flatron>
Date: Fri, 7 Jun 2013 11:14:44 -0700
X-Google-Sender-Auth: wh83B8BSElfbwpJLySeIiBT_Lig
Message-ID: <CAD=FV=WOWk==gjnuEwZfywU2Wxccj7AbSVNj_zuF0bnn8uDf4w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mmc: dw_mmc: Handle late vmmc regulators with EPROBE_DEFER
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Fri, Jun 7, 2013 at 10:42 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> A question just out of curiousity: Is it really correct to have one vmmc
> regulator for the whole device, instead of one regulator per slot?
>
> This might be something obvious, but I don't know any details about
> dw_mmc, so sorry if it's the case.

I don't actually know.  I've never seen a multi-slot implementation so
I end up doing lots of speculation when I make changes.  Certainly the
code I'm moving wouldn't have worked correctly in the
more-than-one-slot case.  There's only space to pass one regulator
(it's not per-slot) and that one regulator would have just been
enabled multiple times.  ...and it would have only been disabled once
in places like suspend/resume.

If there is every a multi-slot implementation that needs vmmc on a
per-slot it seems like we could address at that time?

Thanks!

-Doug
