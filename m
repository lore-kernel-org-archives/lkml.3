Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434AbaEFIbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:31:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58164 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934253AbaEFIbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:31:53 -0400
Message-ID: <53689DF1.4070008@ti.com>
Date: Tue, 6 May 2014 11:31:45 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] Input: pixcir_i2c_ts: Initialize interrupt mode
 and power mode
References: <1399280678-23925-1-git-send-email-rogerq@ti.com> <1399280678-23925-3-git-send-email-rogerq@ti.com> <20140506051922.GA2608@core.coreip.homeip.net>
In-Reply-To: <20140506051922.GA2608@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On 05/06/2014 08:19 AM, Dmitry Torokhov wrote:
> Hi Roger,
> 
> On Mon, May 05, 2014 at 12:04:33PM +0300, Roger Quadros wrote:
>> @@ -192,8 +364,8 @@ static int pixcir_i2c_ts_remove(struct i2c_client *client)
>>  
>>  	device_init_wakeup(&client->dev, 0);
>>  
>> -	tsdata->exiting = true;
>> -	mb();
>> +	if (!tsdata->exiting)
>> +		pixcir_stop(tsdata);
>>  
> 
> I think if we change tsdata->exiting to tsdata->running we won't have to
> do it here. Does the version of the patch below work for you?
> 

The call to pixcir_stop() was not required in the original version as well. It seems
that the root of the problem for remove() and suspend() that I was trying to solve
was in the pixcir_stop() function. i.e. the order of mb() and synchronize_irq();

But I like your version more since "running" reflects the behaviour more accurately
than "exiting".

cheers,
-roger
