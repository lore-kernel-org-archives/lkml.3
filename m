Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaHEUNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:13:00 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:40918 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaHEUM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.03.1408042203100.87047@linaro.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
	<1407202310-3359-9-git-send-email-sboyd@codeaurora.org>
	<alpine.OSX.2.03.1408042203100.87047@linaro.org>
Date: Tue, 5 Aug 2014 13:12:57 -0700
Message-ID: <CAJAp7OiXW1A-H4io2kST_Y6LdVP+EYkXoU3GaWTRt_+CyXruQA@mail.gmail.com>
Subject: Re: [PATCH 8/8] msm: scm: Move the scm driver to drivers/soc/qcom
From: Bjorn Andersson <bjorn@kryo.se>
To: Lina Iyer <lina.iyer@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 9:07 PM, Lina Iyer <lina.iyer@linaro.org> wrote:
> On Mon, 4 Aug 2014, Stephen Boyd wrote:
[...]
> Could we move scm-boot.c as well to drivers/soc/qcom and scm-boot.h to include/soc/qcom ?

Yes, we can do that.

But as of now we seem to only have one caller of this wrapper, so
maybe we could move the functionality into platsmp.c and drop the file
instead?

I looked at this a while back and was considering suggesting that we
move the scm access behind firmware_ops, but then we should probably
also extend the ops struct with all the needed ops related to firmware
loading and other things; so I'm not sure if it's a beneficial move.

Regards,
Bjorn
