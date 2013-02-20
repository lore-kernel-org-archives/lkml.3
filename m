Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3BTWPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:15:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39921 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3BTWPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:15:47 -0500
Message-ID: <51254AF8.9040708@oracle.com>
Date: Wed, 20 Feb 2013 17:15:20 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com> <512522CF.1020901@oracle.com> <20130220210116.GD3570@htj.dyndns.org> <20130220132300.ccffde44.akpm@linux-foundation.org> <20130220213701.GE3570@htj.dyndns.org> <20130220140551.8017e795.akpm@linux-foundation.org> <512549BE.70304@oracle.com> <CAOS58YM77VdO9EoH-5LKZ0NBR0d41GE900goqktU29Oi5=Ov8g@mail.gmail.com>
In-Reply-To: <CAOS58YM77VdO9EoH-5LKZ0NBR0d41GE900goqktU29Oi5=Ov8g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 05:12 PM, Tejun Heo wrote:
> On Wed, Feb 20, 2013 at 2:10 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> I do think that if you have to resort to using something like that there's
>> something terribly wrong with the code somewhere else, and that other thing
>> should be fixed first.
>>
>> Maybe digging into the timers code and seeing why this is needed there will
>> prove me wrong...
> 
> The problem is that userland can feed us any timer_t which makes it
> necessary to properly sanitize the value before using it.

Why can the timer be negative in the first place though? Why isn't the timer
defined as an 'unsigned int' instead of an 'int' so that all values of timer
would be legitimate?


Thanks,
sasha

