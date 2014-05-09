Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbaEIQwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:52:01 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:53447 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135AbaEIQwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:52:00 -0400
MIME-Version: 1.0
In-Reply-To: <1399082069-6666-1-git-send-email-agross@codeaurora.org>
References: <1399082069-6666-1-git-send-email-agross@codeaurora.org>
Date: Fri, 9 May 2014 09:51:59 -0700
Message-ID: <CAJAp7OgN8rmnC9zsmt7FFcWUauebbfCg30_FC9BhgS3GkeZEFw@mail.gmail.com>
Subject: Re: [PATCH] i2c: qup: Fix pm_runtime_get_sync usage
From: Bjorn Andersson <bjorn@kryo.se>
To: Andy Gross <agross@codeaurora.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 6:54 PM, Andy Gross <agross@codeaurora.org> wrote:
[...]
> @@ -479,7 +479,7 @@ static int qup_i2c_xfer(struct i2c_adapter *adap,
>         int ret, idx;
>
>         ret = pm_runtime_get_sync(qup->dev);
> -       if (ret)
> +       if (ret < 0)
>                 goto out;

Sorry about that, thought I tested that path properly.
Wolfram, please pick this up as soon as possible as it renders the
driver useless if one enables pm runtime.

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Regards,
Bjorn
