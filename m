Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbbARVAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 16:00:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38118 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbARVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 16:00:38 -0500
Date: Sun, 18 Jan 2015 22:00:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Colin King <colin.king@canonical.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / clock_ops: initialize ret to avoid garbage being
 returned
Message-ID: <20150118210036.GA31807@amd>
References: <1420731061-5029-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420731061-5029-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2015-01-08 15:31:01, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> cppcheck detected an unitialised ret:
>   [drivers/base/power/clock_ops.c:53]: (error) Uninitialized variable: ret
> 
> ret is only assigned if ce->status < PCE_STATUS_ERROR, if this is false
> then __pm_clk_enable returns whatever garbage ret picks up from the stack.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

> ---
>  drivers/base/power/clock_ops.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
> index d626576..5bd283d 100644
> --- a/drivers/base/power/clock_ops.c
> +++ b/drivers/base/power/clock_ops.c
> @@ -39,7 +39,7 @@ struct pm_clock_entry {
>   */
>  static inline int __pm_clk_enable(struct device *dev, struct pm_clock_entry *ce)
>  {
> -	int ret;
> +	int ret = 0;
>  
>  	if (ce->status < PCE_STATUS_ERROR) {
>  		ret = clk_enable(ce->clk);

Actually, is this right solution? If clock entry has an error, we
won't enable it, and should probably return some kind of error...?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
