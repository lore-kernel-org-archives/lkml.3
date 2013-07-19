Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676Ab3GSLQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:16:52 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:49485 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997Ab3GSLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:16:51 -0400
Message-ID: <51E91DF3.50002@st.com>
Date: Fri, 19 Jul 2013 12:07:31 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, alipowski@interia.pl,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@gmail.com
Subject: Re: [PATCH v1 1/2] media: rc: Add user count to rc dev.
References: <1374223132-4924-1-git-send-email-srinivas.kandagatla@st.com> <1374223167-4980-1-git-send-email-srinivas.kandagatla@st.com> <20130719110147.GA1104@pequod.mess.org>
In-Reply-To: <20130719110147.GA1104@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/13 12:01, Sean Young wrote:

>> +	int rval = 0;
>>  
>> -	return rdev->open(rdev);
>> +	if (!rdev->users++)
>> +		rval = rdev->open(rdev);
>> +
>> +	if (rval)
>> +		rdev->users--;
>> +
>> +	return rval;
> 
> This looks racey. Some locking is needed, I think rc_dev->lock should work
> fine for this. Here and in the lirc code path too.
thanks Sean,
It makes sense, will fix this in v2.


Srini

> 
> Sean
> 
>>  }
>
