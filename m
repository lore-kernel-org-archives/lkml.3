Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3DSSWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:22:01 -0400
Received: from longford.logfs.org ([213.229.74.203]:58856 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3DSSWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:22:00 -0400
Date: Fri, 19 Apr 2013 12:55:16 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Joe Perches <joe@perches.com>
Cc: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: Convert logging messages
Message-ID: <20130419165516.GA19480@logfs.org>
References: <1366394375.3901.36.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366394375.3901.36.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 April 2013 10:59:35 -0700, Joe Perches wrote:
>  	}
>  	list_add(&dev->list, &blkmtd_device_list);
> -	INFO("mtd%d: [%s] erase_size = %dKiB [%d]", dev->mtd.index,
> -			dev->mtd.name + strlen("block2mtd: "),
> -			dev->mtd.erasesize >> 10, dev->mtd.erasesize);
> +	pr_info("mtd%d: [%s] erase_size = %dKiB [%d]\n",
> +		dev->mtd.index,
> +		dev->mtd.name + strlen("block2mtd: "),
> +		dev->mtd.erasesize >> 10, dev->mtd.erasesize);

I personally dislike the indent-to-braces style because it causes
unnecessary churn in patches like this.  The reindenting improves
nothing at all.  On the contrary, when going through revision history
at some point in the future I have to waste brain time to verify
whether any function change has slipped in or not.  It doesn't just
waste my time right now, it will continue to waste time in the future.
It will waste time when people care about revision history because
they encounter a bug, want a fix quick and are pressed for time.

If you care about my ack, please remove random churn.  This is not a
competition about who gets the most lines in git blame.

Jörn

--
Public Domain  - Free as in Beer
General Public - Free as in Speech
BSD License    - Free as in Enterprise
Shared Source  - Free as in "Work will make you..."
