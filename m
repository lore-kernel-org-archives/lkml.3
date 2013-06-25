Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3FYA7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 20:59:35 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56580 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3FYA7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 20:59:34 -0400
X-Spam-Score: -100.7
Message-ID: <51C8EB41.6060501@asianux.com>
Date: Tue, 25 Jun 2013 08:58:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/itimer.c: beautify code, not need check 'value',
 so save one instruction, simpler and easier for readers.t
References: <51C2E6F9.80107@asianux.com> <alpine.DEB.2.02.1306201458100.4013@ionos.tec.linutronix.de> <51C3B4B4.90603@asianux.com> <alpine.DEB.2.02.1306242242480.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306242242480.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 07:28 AM, Thomas Gleixner wrote:
> On Fri, 21 Jun 2013, Chen Gang wrote:
>>>>> > >> > Also can let code simpler and easier for readers: if checking parameter
>>>>> > >> > 'value', it will easily lead readers to think about why not return
>>>>> > >> > -EINVAL instead of -EFAULT, when checking parameter failed.
>>> > > So you are seriously claiming, that the check for !value makes people
>>> > > think that the return value should be -EINVAL?
>>> > > 
>>> > > That's hillarious.
>>> > > 
>> > That seems not a quite polite word, is it ?  ;-)
> My apologies for being so impolite. Let me rephrase it. Here is a
> "sample" changelog for your patch:
> 

It doesn't matter, I really don't (shouldn't) care about it.

Next time, I should try to send patch carefully, so may save the
maintainers' timer resource.

And excuse me for my poor English and either not familiar with kernel, I
am trying to improve them, and keep improving them.


>   Subject: itimers: Remove bogus NULL pointer check in sys_getitimer()
> 
>     People might be tricked into assuming that the return value for a
>     failed NULL pointer check should be -EINVAL instead of -EFAULT.
> 
>     Remove the misleading NULL pointer check to fix this nuisance.
> 
>     Aside of that this patch fixes the problem of NOMMU kernels, where
>     a NULL pointer dereference is a valid operation. This allows to
>     boot NOMMU kernels without working around the shortcomings of the
>     getitimer() system call, which have been ignored since this NULL
>     pointer check was introduced in Linux 0.96a.
> 

Really very good comments, at least for me now, I really can not write a
comment like that.

> 
> Please resubmit.

I will send patch v4 (patch v3 has sent, and should be obsoleted)

Thanks.
-- 
Chen Gang

Asianux Corporation
