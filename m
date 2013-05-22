Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab3EVV15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:27:57 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:63187 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3EVV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <1369255217-29764-1-git-send-email-sboyd@codeaurora.org>
References: <1369255217-29764-1-git-send-email-sboyd@codeaurora.org>
Date: Wed, 22 May 2013 16:27:55 -0500
Message-ID: <CAL_JsqLm5VAj-5ctWVsCmx5Jewv-hyi2j65XWo4h1WFBMPPumg@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/2] Remove most of_device_match() calls
From: Rob Herring <robherring2@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 3:40 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Sending this as an RFC with one driver converted to see what people
> think. The goal is to avoid having to run the match twice and be
> similar to how platform_device_id works right now. If people agree
> I can go through and send out patches for all the drivers doing
> the duplicate search (~100 files).
>

See this commit:

commit b1608d69cb804e414d0887140ba08a9398e4e638
Author: Grant Likely <grant.likely@secretlab.ca>
Date:   Wed May 18 11:19:24 2011 -0600

    drivercore: revert addition of of_match to struct device

    Commit b826291c, "drivercore/dt: add a match table pointer to struct
    device" added an of_match pointer to struct device to cache the
    of_match_table entry discovered at driver match time.  This was unsafe
    because matching is not an atomic operation with probing a driver.  If
    two or more drivers are attempted to be matched to a driver at the
    same time, then the cached matching entry pointer could get
    overwritten.

    This patch reverts the of_match cache pointer and reworks all users to
    call of_match_device() directly instead.

    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
