Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3KKIlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:41:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43789 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3KKIlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:41:10 -0500
X-IronPort-AV: E=Sophos;i="4.93,676,1378828800"; 
   d="scan'208";a="8999769"
Message-ID: <528097A3.9040908@cn.fujitsu.com>
Date: Mon, 11 Nov 2013 16:38:59 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
References: <1383300583-6953-1-git-send-email-duanj.fnst@cn.fujitsu.com> <CAPgLHd_p+LJmBX6FCy1+mF3VTHkBoPa83SNXciqb28pa3QE7TA@mail.gmail.com>
In-Reply-To: <CAPgLHd_p+LJmBX6FCy1+mF3VTHkBoPa83SNXciqb28pa3QE7TA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/11 16:39:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/11 16:39:24
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年11月11日 15:43, Wei Yongjun 写道:
> On 11/01/2013 06:09 PM, Duan Jiong wrote:
>> This patch fixes coccinelle error regarding usage of IS_ERR and
>> PTR_ERR instead of PTR_ERR_OR_ZERO.
>>
>> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
>> ---
>>  drivers/misc/carma/carma-fpga.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
>> index 08b18f3..9a32e98 100644
>> --- a/drivers/misc/carma/carma-fpga.c
>> +++ b/drivers/misc/carma/carma-fpga.c
>> @@ -956,10 +956,7 @@ static int data_debugfs_init(struct fpga_device *priv)
>>  {
>>  	priv->dbg_entry = debugfs_create_file(drv_name, S_IRUGO, NULL, priv,
>>  					      &data_debug_fops);
>> -	if (IS_ERR(priv->dbg_entry))
>> -		return PTR_ERR(priv->dbg_entry);
>> -
>> -	return 0;
>> +	return PTR_ERR_OR_ZERO(priv->dbg_entry);
>>  }
> 
> Those code has make sure that CONFIG_DEBUG_FS is enabled, so
> debugfs_create_file() never return PTR_ERR(), only NULL will
> be returned when error occurs.
> 
>

You can see the definition about PTR_ERR_OR_ZERO in include/linux/err.h,
it is merely used to simplify the code.

Thanks,
  Duan

