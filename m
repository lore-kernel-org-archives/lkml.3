Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3C3OwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:52:16 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:33946 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3C3OwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:52:14 -0400
Date: Sat, 30 Mar 2013 15:52:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] i2c: Remove detach_adapter
Message-ID: <20130330155201.1e145ed6@endymion.delvare>
In-Reply-To: <1362853009-20789-2-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
	<1362853009-20789-2-git-send-email-lars@metafoo.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Sat,  9 Mar 2013 19:16:44 +0100, Lars-Peter Clausen wrote:
> The detach_adapter callback has been deprecated for quite some time and has no
> user left. Keeping it alive blocks other cleanups, so remove it.

I'm all for it. Originally I intended to remove both attach_adapter and
detach_adapter at the same time, unfortunately there are still users of
attach_adapter around, despite it being deprecated for 2 or 3 years
now. So the patch removing them is still sitting on my disk. Getting
rid of at least detach_adapter now is a good idea.

One minor comment:

> @@ -1088,11 +1077,9 @@ int i2c_del_adapter(struct i2c_adapter *adap)
>  
>  	/* Tell drivers about this removal */
>  	mutex_lock(&core_lock);
> -	res = bus_for_each_drv(&i2c_bus_type, NULL, adap,
> +	bus_for_each_drv(&i2c_bus_type, NULL, adap,
>  			       __process_removed_adapter);

This would fit on a single line now.

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
