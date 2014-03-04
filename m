Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbaCDKSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:18:07 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35275 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbaCDKSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:18:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140304090419.GT26722@mwanda>
References: <1905523.1xUMUtkBrU@daeseok-laptop.cloud.net>
	<20140304090419.GT26722@mwanda>
Date: Tue, 4 Mar 2014 19:18:03 +0900
Message-ID: <CAHb8M2AVv1bLT+StC2QsubOiM+n+mEb2TmSp_yCbCMJsAG2pLw@mail.gmail.com>
Subject: Re: [PATCH 4/7] staging: cxt1e1: fix checkpatch error 'assignment in
 if condition'
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, shaun@xresource.ca,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        ying.xue@windriver.com, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it need to add brace in inner loop.
I will send again.

Thanks for review.
Daeseok Youn

2014-03-04 18:04 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Tue, Mar 04, 2014 at 11:09:39AM +0900, Daeseok Youn wrote:
>> @@ -1174,7 +1179,8 @@ cleanup_hdlc(void)
>>  			ci = (ci_t *)(netdev_priv(hi->ndev));
>>  			for (j = 0; j < ci->max_port; j++)
>>  				for (k = 0; k < MUSYCC_NCHANS; k++)
>> -					if ((ndev = ci->port[j].chan[k]->user))
>> +					ndev = ci->port[j].chan[k]->user;
>> +					if (ndev)
>>  					{
>>  						do_deluser(ndev, 0);
>>  					}
>
>
> This patch introduces a bug here because the inner for loop now has two
> statement but no curly braces.
>
> regards,
> dan carpenter
>
