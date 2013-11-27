Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3K0DiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:38:15 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42040 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3K0DiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:38:11 -0500
Message-ID: <529569A5.1020008@gmail.com>
Date: Wed, 27 Nov 2013 11:40:21 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: hans.verkuil@cisco.com, m.chehab@samsung.com, rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] drivers: staging: media: go7007: go7007-usb.c use pr_*()
 instead of dev_*() before 'go' initialized in go7007_usb_probe()
References: <528AEFB7.4060301@gmail.com>  <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>  <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>  <52956442.50001@gmail.com> <1385522475.18487.34.camel@joe-AO722>
In-Reply-To: <1385522475.18487.34.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 11:21 AM, Joe Perches wrote:
> On Wed, 2013-11-27 at 11:17 +0800, Chen Gang wrote:
>> dev_*() assumes 'go' is already initialized, so need use pr_*() instead
>> of before 'go' initialized.
> []
>> diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
> []
>> @@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
>>  	char *name;
>>  	int video_pipe, i, v_urb_len;
>>  
>> -	dev_dbg(go->dev, "probing new GO7007 USB board\n");
>> +	pr_devel("probing new GO7007 USB board\n");
> 
> pr_devel is commonly compiled out completely unless DEBUG is #defined.
> You probably want to use pr_debug here.
>  
> 

Oh, yes, it is my fault, I will send patch v2.  :-)


Thanks.
-- 
Chen Gang
