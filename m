Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbaICNhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:37:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43737 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbaICNho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:37:44 -0400
Date: Wed, 3 Sep 2014 06:37:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: Re: [PATCH] mmc: sdhci-msm: Make tuning block table endian agnostic
Message-ID: <20140903133742.GB28256@codeaurora.org>
References: <1409702308-3023-1-git-send-email-sboyd@codeaurora.org>
 <CAPDyKFoboJGTzF3aQ=YBpWyVT6opTMgz_6gpOo5BRX30+hfCBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFoboJGTzF3aQ=YBpWyVT6opTMgz_6gpOo5BRX30+hfCBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Ulf Hansson wrote:
> On 3 September 2014 01:58, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > If we're tuning on a big-endian CPU we'll never determine we properly
> > tuned the device because we compare the data we received from the
> > controller with a table that assumes the CPU is little-endian.
> > Change the table to be an array of bytes instead of 32-bit words
> > so we can use memcmp() without needing to byte-swap every word
> > depending on the endianess of the CPU.
> >
> > Cc: Asutosh Das <asutoshd@codeaurora.org>
> > Cc: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> > Cc: Georgi Djakov <gdjakov@mm-sol.com>
> > Fixes: 415b5a75da43 "mmc: sdhci-msm: Add platform_execute_tuning implementation"
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Hi Stephen,
> 
> If you want me to pick this up, please repost to linux-mmc as well.
> Otherwise you have my ack for it!
> 

Ok I'll repost it now.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
