Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab3ENN4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:56:24 -0400
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:53200 "EHLO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab3ENN4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:56:23 -0400
Message-ID: <51924281.2060509@ge.com>
Date: Tue, 14 May 2013 14:56:17 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Wei Yongjun <weiyj.lk@gmail.com>, gmate.amit@gmail.com,
        devel@driverdev.osuosl.org, manohar.vanga@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        yamanetoshi@gmail.com, yongjun_wei@trendmicro.com.cn, joe@perches.com
Subject: Re: [PATCH] staging: vme: fix error return code in vme_user_probe()
References: <CAPgLHd9MXzrkvKBtJYG6GZ2Xn9fBi6TO7NzJQDLgw2jCGqDupQ@mail.gmail.com> <5190A140.3020306@ge.com> <20130513085132.GI1360@mwanda>
In-Reply-To: <20130513085132.GI1360@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/13 09:51, Dan Carpenter wrote:
> On Mon, May 13, 2013 at 09:16:00AM +0100, Martyn Welch wrote:
>> On 13/05/13 07:05, Wei Yongjun wrote:
>>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>>
>>> Fix to return -ENOMEM in the resource alloc error handling
>>> case instead of 0, as done elsewhere in this function.
>>>
>>
>> Hi Wei,
>>
>> Thanks for your patch. As this is resource allocation rather than memory
>> allocation that is failing, would -EAGAIN not make more sense than -ENOMEM?
>>
> 
> ENOMEM is better.  EAGAIN is for when trylock() fails etc.  In other
> words we are not allowed to block and someone is using the lock we
> need.
> 

ENOMEM just doesn't seem to describe the error very well. This error will be
triggered if no free VME windows are available for the driver to use - there
are typically 8 master and 8 slave windows provided in hardware.

How about EBUSY (Device or resource busy)?

> It feels like we discuss error codes a lot on LKML and they should
> be documented under Documententation/.  The closest thing is
> Documentation/i2c/fault-codes.
> 

I'd been looking at the errno man page since I was under the impression that
these values would typically find their way back to user space.

Martyn

-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
