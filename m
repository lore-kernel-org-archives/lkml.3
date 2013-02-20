Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3BTWKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:10:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42823 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3BTWKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:10:33 -0500
Message-ID: <512549BE.70304@oracle.com>
Date: Wed, 20 Feb 2013 17:10:06 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com> <512522CF.1020901@oracle.com> <20130220210116.GD3570@htj.dyndns.org> <20130220132300.ccffde44.akpm@linux-foundation.org> <20130220213701.GE3570@htj.dyndns.org> <20130220140551.8017e795.akpm@linux-foundation.org>
In-Reply-To: <20130220140551.8017e795.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 05:05 PM, Andrew Morton wrote:
> I wonder if we should add some generic facility to handle this:
> 
> /*
>  * Query whether an unsigned type is `negative' when we don't know its size
>  */
> #define msb_is_set(v)	{ implementation goes here ;) }
> 
> Maybe not justified, dunno...

I do think that if you have to resort to using something like that there's
something terribly wrong with the code somewhere else, and that other thing
should be fixed first.

Maybe digging into the timers code and seeing why this is needed there will
prove me wrong...


Thanks,
Sasha
