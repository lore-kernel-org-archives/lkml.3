Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3CFQOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:14:51 -0500
Received: from mail1.windriver.com ([147.11.146.13]:57054 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3CFQOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:14:48 -0500
Message-ID: <51376B5D.7040108@windriver.com>
Date: Wed, 6 Mar 2013 11:14:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Threaded irqs + 100% CPU RT task = RCU stall
References: <20130306154917.GA15249@windriver.com> <alpine.LFD.2.02.1303061651360.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303061651360.22263@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-06 10:58 AM, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, Paul Gortmaker wrote:
>> So, I guess the question is, whether we want to try and make the system
>> fail in a more meaningful way -- kind of like the rt throttling message
>> does - as it lets users know they've hit the wall?  Something watching
> 
> That Joe Doe should have noticed the throttler message, which came
> before the stall, shouldn't he?

Actually it isn't showing up at all -- just the RCU stall itself.
Now that you mention it, I do wonder why the throttler message 
isn't tripped though...

Paul.
--

> 
>> for kstat_incr_softirqs traffic perhaps?  Or other options?
> 
> The rcu stall detector could use the softirq counter and if it did not
> change in the stall period print: "Caused by softirq starvation" or
> something like that.
> 
> Thanks,
> 
> 	tglx
> 
> 
