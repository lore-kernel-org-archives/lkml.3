Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab3BOThm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:37:42 -0500
Received: from sauhun.de ([89.238.76.85]:34071 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3BOThl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:37:41 -0500
Date: Fri, 15 Feb 2013 20:37:36 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: mux: Remove unneeded platform_set_drvdata to NULL
 in remove
Message-ID: <20130215193736.GD4351@the-dreams.de>
References: <1360953682-25066-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360953682-25066-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 10:41:22AM -0800, Doug Anderson wrote:
> Stephen Warren pointed out as part of a code review of another mux
> driver that there should be no need to have
> "platform_set_drvdata(pdev, NULL)" in the remove function.  Get rid of
> it in the i2c-mux-gpio driver.
> 
> See Stephen's comment at:
>   http://www.gossamer-threads.com/lists/linux/kernel/1678627?do=post_view_threaded#1678627
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I think we should do this at least I2C subsystem wide (51 occasions of
setting some *_drvdata to NULL), even better kernel-wide. Patching
individual drivers won't cut the confusion around this issue, I am
afraid.

Thanks,

   Wolfram

