Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaF0Q6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:58:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22091 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaF0Q6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:58:21 -0400
Message-ID: <53ADA30C.7090908@oracle.com>
Date: Fri, 27 Jun 2014 12:59:56 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86-ml <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 2 RAS fixes for 3.17, refreshed
References: <20140622164603.GA3385@pd.tnic> <20140624132439.GH4439@pd.tnic> <20140624132701.GB28885@laptop.dumpdata.com> <20140627150155.GG23153@pd.tnic> <53AD89FB.7090609@oracle.com> <20140627160841.GH23153@pd.tnic>
In-Reply-To: <20140627160841.GH23153@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 12:08 PM, Borislav Petkov wrote:
> On Fri, Jun 27, 2014 at 11:12:59AM -0400, Boris Ostrovsky wrote:
>> Yes, it fails because xen_late_init_mcelog() registers /dev/mcelog and (I
>> think) it happens before mcheck_init_device().
> Yes, mcheck_init_device is device_initcall_sync() while
> xen_late_init_mcelog() is device_initcall().
>
>> In other words, misc_register() expected to fail in mcheck/mce.c on
>> (privileged?) PV guests (provided right CONFIG_XEN_* is set).
> So
>
> 	cef12ee52b05 ("xen/mce: Add mcelog support for Xen platform")
>
> made it this way so that xen's init routine runs first.
>
> So it is not the case that misc_register() fails often on xen but it is
> *supposed* to fail by design, when running in dom0. And *then* you need
> the notifier *not* unregistered on the error path so that the timers do
> get deleted properly.
>
> Ok, I see it now. Frankly, I'm not really sure I want to rush this in
> now because it might break something else, Who TF knows what.
>
> Right now my gut feeling tells me we should still queue it for 3.17 and
> have it run for a while in linux-next. We can backport it to stable
> later after some testing...

I don't have a problem with having it soak in linux-next for a while but 
I am not too crazy about releasing 3.16 with this bug (even knowing that 
there will be a backport later). When we hit this problem the results 
are rather unpleasant in that it's not immediately clear what's happened.

We are still at rc2 so we have 3-4 weeks before 3.16 goes out.


-boris


