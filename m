Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaKYOwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:52:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50245 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaKYOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:51:59 -0500
Message-ID: <54749725.3050307@oracle.com>
Date: Tue, 25 Nov 2014 07:50:13 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com,
        ak@linux.intel.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com,
        raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com,
        avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com,
        athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com,
        daeseok.youn@gmail.com, keescook@chromium.org,
        yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com,
        axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>	 <alpine.DEB.2.11.1411242317380.6439@nanos> <1416889208.4335.127.camel@maggy.simpson.net>
In-Reply-To: <1416889208.4335.127.camel@maggy.simpson.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 09:20 PM, Mike Galbraith wrote:
> On Tue, 2014-11-25 at 00:35 +0100, Thomas Gleixner wrote:
>
>> Aside of the general issues I have with this (see the inline replies
>> to your changelog) the overall impression of this patch is that it is
>> a half baken and carelessly cobbled together extract of some data base
>> specific kernel hackery, which I prefer not to see at all.
>
> It culminates in a lumbering pseudo RT class of task disguised as a fair
> class task.  I'd expect more gain by twiddling knobs to let last buddy
> do its job than the 3% mentioned.
>
> You could perhaps create a SUPER_BATCH class that is not wakeup
> preempted by any fair class task of <= priority, not only BATCH and
> IDLE, but that's as nasty as this patch, though loads prettier.  The
> tick time thing doesn't feel right at all... if you're hurt badly by the
> tick, you're likely holding the lock too long methinks.
>
> 	-Mike
>
>

It is definitely not an attempt to solve any kind of RT problem. It 
would be a poor attempt if it indeed attempted to solve an RT problem. 
RT is all about guarantees. This patch does not help there at all and 
hence I have no intention of ever applying anything like this to 
SCHED_FIFO or SCHED_RR.

This problem is not caused by task holding the lock too long. It is 
caused by the task happening to acquire the lock just before its current 
timeslice is up. In that case, it does not matter how long the task 
holds the lock for.

--
Khalid
