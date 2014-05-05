Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaEEIoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:44:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37082 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbaEEIoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:44:17 -0400
Message-ID: <53674F5A.3080006@ti.com>
Date: Mon, 5 May 2014 11:44:10 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] Input: pixcir_i2c_ts: Use devres managed resource
 allocations
References: <1398861392-8959-1-git-send-email-rogerq@ti.com> <1398861392-8959-2-git-send-email-rogerq@ti.com> <20140430163041.GB13624@core.coreip.homeip.net>
In-Reply-To: <20140430163041.GB13624@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 07:30 PM, Dmitry Torokhov wrote:
> Hi Roger,
> 
> On Wed, Apr 30, 2014 at 03:36:26PM +0300, Roger Quadros wrote:
> 
>>  static int pixcir_i2c_ts_remove(struct i2c_client *client)
>> @@ -198,10 +194,8 @@ static int pixcir_i2c_ts_remove(struct i2c_client *client)
>>  
>>  	tsdata->exiting = true;
>>  	mb();
>> -	free_irq(client->irq, tsdata);
>>  
>>  	input_unregister_device(tsdata->input);
> 
> There is no need to call input_unregister_device for managed input
> devices.

OK. I'll remove that.

> 
>> -	kfree(tsdata);
>>  
>>  	return 0;
>>  }

cheers,
-roger
