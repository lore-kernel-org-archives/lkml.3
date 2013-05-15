Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3EOH5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:57:05 -0400
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:46193 "EHLO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab3EOH5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:57:02 -0400
Message-ID: <51933FB2.6040208@ge.com>
Date: Wed, 15 May 2013 08:56:34 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, gmate.amit@gmail.com,
        devel@driverdev.osuosl.org, manohar.vanga@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        yamanetoshi@gmail.com, yongjun_wei@trendmicro.com.cn, joe@perches.com
Subject: Re: [PATCH] staging: vme: fix error return code in vme_user_probe()
References: <CAPgLHd9MXzrkvKBtJYG6GZ2Xn9fBi6TO7NzJQDLgw2jCGqDupQ@mail.gmail.com> <5190A140.3020306@ge.com> <20130513085132.GI1360@mwanda> <51924281.2060509@ge.com> <20130514141906.GS30128@mwanda>
In-Reply-To: <20130514141906.GS30128@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/13 15:19, Dan Carpenter wrote:
> On Tue, May 14, 2013 at 02:56:17PM +0100, Martyn Welch wrote:
>> On 13/05/13 09:51, Dan Carpenter wrote:
>>> On Mon, May 13, 2013 at 09:16:00AM +0100, Martyn Welch wrote:
>>>> On 13/05/13 07:05, Wei Yongjun wrote:
>>>>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>>>>
>>>>> Fix to return -ENOMEM in the resource alloc error handling
>>>>> case instead of 0, as done elsewhere in this function.
>>>>>
>>>>
>>>> Hi Wei,
>>>>
>>>> Thanks for your patch. As this is resource allocation rather than memory
>>>> allocation that is failing, would -EAGAIN not make more sense than -ENOMEM?
>>>>
>>>
>>> ENOMEM is better.  EAGAIN is for when trylock() fails etc.  In other
>>> words we are not allowed to block and someone is using the lock we
>>> need.
>>>
>>
>> ENOMEM just doesn't seem to describe the error very well. This error will be
>> triggered if no free VME windows are available for the driver to use - there
>> are typically 8 master and 8 slave windows provided in hardware.
>>
>> How about EBUSY (Device or resource busy)?
> 
> EBUSY would work.
> 

Hi Wei,

Would you mind resubmitting your patch returning the error code EBUSY rather
than ENOMEM?

Martyn

-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
