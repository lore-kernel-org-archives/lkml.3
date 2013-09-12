Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3ILAZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:25:49 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37571 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3ILAZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <7463564f181640d2ad9658ce0ef7a7b5@SN2PR03MB061.namprd03.prod.outlook.com>
References: <CAPgLHd-5dt70Tn+3SXXu9QudpwpHaO1FNf-LZWQmDq413KLbQg@mail.gmail.com>
	<7463564f181640d2ad9658ce0ef7a7b5@SN2PR03MB061.namprd03.prod.outlook.com>
Date: Thu, 12 Sep 2013 08:25:47 +0800
Message-ID: <CAPgLHd_7MKG75y0NiXFVV-w8dtRWPdT8CtrMWyN_a1LM0MD9Lw@mail.gmail.com>
Subject: Re: [PATCH] Drivers: hv: vmbus: fix error return code in vmbus_connect()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kys@microsoft.com
Cc: haiyangz@microsoft.com, yongjun_wei@trendmicro.com.cn,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 04:03 AM, KY Srinivasan wrote:
>
>> -----Original Message-----
>> From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
>> Sent: Wednesday, September 11, 2013 4:20 AM
>> To: KY Srinivasan; Haiyang Zhang
>> Cc: yongjun_wei@trendmicro.com.cn; devel@linuxdriverproject.org; linux-
>> kernel@vger.kernel.org
>> Subject: [PATCH] Drivers: hv: vmbus: fix error return code in vmbus_connect()
>>
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Fix to return -EINVAL in the version check error handling
>> case instead of 0, as done elsewhere in this function.
> The return will not be zero in this case. If you look at the function 
> vmbus_negotiate_version(), in case the host refuses the version, the
> return value will be set to -ECONNREFUSED

look at the code:

 196         do {
 197                 ret = vmbus_negotiate_version(msginfo, version);
 198                 if (ret)
 199                         goto cleanup;
 200 
 201                 if (vmbus_connection.conn_state == CONNECTED)
 202                         break;
 203 
 204                 version = vmbus_get_next_version(version);
 205         } while (version != VERSION_INVAL);
 206 
 207         if (version == VERSION_INVAL)
 208                 goto cleanup;

if function vmbus_negotiate_version() return error, the code
will goto cleanup. 

If 'version == VERSION_INVAL' is true, I think we tried all
of the VERSION_WS2008/VERSION_WIN7/VERSION_WIN8, but still
can not get the connection.

 



