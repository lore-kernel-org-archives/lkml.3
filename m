Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3BDQK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:10:28 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53371 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3BDQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:10:27 -0500
Message-ID: <510FDD7B.7060903@windriver.com>
Date: Mon, 4 Feb 2013 11:10:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH] OF: Fixup resursive locking code paths
References: <1359138107-14159-1-git-send-email-paul.gortmaker@windriver.com> <alpine.LFD.2.02.1302041147420.11905@ionos>
In-Reply-To: <alpine.LFD.2.02.1302041147420.11905@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-04 05:48 AM, Thomas Gleixner wrote:
> On Fri, 25 Jan 2013, Paul Gortmaker wrote:
> 
>> From: Thomas Gleixner <tglx@linutronix.de>
>>
>> There is no real reason to use a rwlock for devtree_lock. It even
>> could be a mutex, but unfortunately it's locked from cpu hotplug
>> paths which can't schedule :(
>>
>> So it needs to become a raw lock on rt as well.  The devtree_lock would
>> be the only user of a raw_rw_lock, so we are better off cleaning up the
>> recursive locking paths which allows us to convert devtree_lock to a
>> read_lock.
> 
> Hmm. It's already a rw_lock. For RT we want to change that thing to a
> raw_spinlock.

Thanks for the reminder.  Part 2 sent now that the cleanup got OK'd.

Paul.
--

> 
> Thanks,
> 
> 	tglx
> 
