Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaCDWpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:45:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41238 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaCDWpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:45:23 -0500
Message-ID: <5316574F.6040105@oracle.com>
Date: Tue, 04 Mar 2014 15:44:31 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>	<531641A8.40306@zytor.com>	<53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk>
In-Reply-To: <20140304222356.41c55bbc@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 03:23 PM, One Thousand Gnomes wrote:
> Obvious bug
>
> | Usage model is a thread mmaps this file during initialization. It then
> | writes a 1 to the mmap'd file after it grabs the lock in its critical
> | section where it wants immunity from pre-emption.
>
> You need to write it first or you can be pre-empted taking the lock
> before asking for immunity.

Ah, yes. Thanks, Alan!

>
> Presumably you could equally use something to group tasks (say a control
> group of some form) and implement voluntary pre-emption within the group
> only when in user space. Ie they only pre-empt each other by yielding but
> they can be pre-empted by other tasks outside the group ?
>

I had suggested that to database folks initially, but they use mutexes 
that are shared across processes and they do not believe they can 
control the environment in customer scenario where they can ensure right 
tasks will always be in the right control group. Besides they want to 
use a common mechanism across multiple OSs and pre-emption delay is 
already in use on other OSs. Good idea though.

Thanks,
Khalid
