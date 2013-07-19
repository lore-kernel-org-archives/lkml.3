Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3GSWp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 18:45:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23995 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3GSWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 18:45:27 -0400
Date: Sat, 20 Jul 2013 01:45:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] relay: fix timer madness
Message-ID: <20130719224502.GA5687@mwanda>
References: <51DCC48E.8050003@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DCC48E.8050003@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 10:18:54AM +0800, zhangwei(Jovi) wrote:
> @@ -339,6 +339,10 @@ static void wakeup_readers(unsigned long data)
>  {
>  	struct rchan_buf *buf = (struct rchan_buf *)data;
>  	wake_up_interruptible(&buf->read_wait);
> +	/*
> +	 * Stupid polling for now:
> +	 */
> +	mod_timer(&buf->timer, HZ / 10);

mod_timer() takes an offset so probably "jiffies + HZ / 10" was
intended here and also below.  Certainly passing "HZ / 10" doesn't
make any kind of sense.

regards,
dan carpenter

