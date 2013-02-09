Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3BIKXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:23:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39168 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3BIKXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:23:32 -0500
Date: Sat, 9 Feb 2013 10:22:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philip Avinash <avinashphilip@ti.com>
Cc: khilman@ti.com, tony@atomide.com, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, afzal@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, hvaibhav@ti.com
Subject: Re: [PATCH v2 3/4] mtd: devices: elm: Low power transition support
Message-ID: <20130209102243.GH17852@n2100.arm.linux.org.uk>
References: <1360240618-11094-1-git-send-email-avinashphilip@ti.com> <1360240618-11094-4-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360240618-11094-4-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 06:06:57PM +0530, Philip Avinash wrote:
> +static int elm_suspend(struct device *dev)
> +{
> +	struct elm_info *info = dev_get_drvdata(dev);
> +	wait_queue_head_t wq;
> +	DECLARE_WAITQUEUE(wait, current);
> +
> +	init_waitqueue_head(&wq);
> +	while (1) {
> +		/* Make sure that ELM not running */
> +		if (info->idle) {
> +			add_wait_queue(&wq, &wait);
> +			schedule();
> +			remove_wait_queue(&wq, &wait);
> +		} else {
> +			break;
> +		}
> +	}

The above code looks really wrong - it will just spin endlessly with the
waitqueues doing nothing useful.  What are you trying to do here?
