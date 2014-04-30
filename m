Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbaD3QbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:31:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38065 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933742AbaD3QbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:31:01 -0400
Date: Wed, 30 Apr 2014 09:30:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: rydberg@euromail.se, balbi@ti.com, dmurphy@ti.com, mugunthanvnm@ti.com,
        nsekhar@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/7] Input: pixcir_i2c_ts: Use devres managed resource
 allocations
Message-ID: <20140430163041.GB13624@core.coreip.homeip.net>
References: <1398861392-8959-1-git-send-email-rogerq@ti.com>
 <1398861392-8959-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398861392-8959-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Wed, Apr 30, 2014 at 03:36:26PM +0300, Roger Quadros wrote:

>  static int pixcir_i2c_ts_remove(struct i2c_client *client)
> @@ -198,10 +194,8 @@ static int pixcir_i2c_ts_remove(struct i2c_client *client)
>  
>  	tsdata->exiting = true;
>  	mb();
> -	free_irq(client->irq, tsdata);
>  
>  	input_unregister_device(tsdata->input);

There is no need to call input_unregister_device for managed input
devices.

> -	kfree(tsdata);
>  
>  	return 0;
>  }
> -- 
> 1.8.3.2
> 

Thanks.

-- 
Dmitry
