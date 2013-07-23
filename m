Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab3GWVfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:35:42 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:16827 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3GWVfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:35:41 -0400
Message-ID: <1374615285.16322.164.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
From: Toshi Kani <toshi.kani@hp.com>
To: Dave Hansen <dave@sr71.net>
Cc: Ingo Molnar <mingo@kernel.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        kosaki.motohiro@gmail.com, isimatu.yasuaki@jp.fujitsu.com,
        tangchen@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Date: Tue, 23 Jul 2013 15:34:45 -0600
In-Reply-To: <51EEEE9F.2060600@sr71.net>
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
	  <20130722083721.GC25976@gmail.com>
	  <1374513120.16322.21.camel@misato.fc.hp.com>
	  <20130723080101.GB15255@gmail.com>
	 <1374612301.16322.136.camel@misato.fc.hp.com> <51EEEE9F.2060600@sr71.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 13:59 -0700, Dave Hansen wrote:
> On 07/23/2013 01:45 PM, Toshi Kani wrote:
> > Dave, is this how you are testing?  Do you always specify a valid memory
> > address for your testing?
> 
> For the moment, yes.
> 
> I'm actually working on some other patches that add the kernel metadata
> for memory ranges even if they're not backed by physical memory.  But
> _that_ is just for testing and I'll just have to modify whatever you do
> here in those patches anyway.
> 
> It sounds like you're pretty confident that it has no users, so why
> don't you just go ahead and axe it on x86 and config it out completely?
>  Folks that need it can just hack it back in.

Well, I am only confident that this interface is not necessary for ACPI
hotplug.  As we found you as a user of this interface for testing on a
system without hotplug support, it is prudent to assume that there may
be other users as well.  So, I am willing to keep the interface
configurable (with default disabled) for now.

The question is what to do in the next step.  There are two options:

1) Make the interface safe to use
2) Remove the config option from x86 Kconfig

Both options will achieve the same goal -- prevent the crash.  Once this
first patch gets in, we will see if there are more users on the
interface.  Then, we can decide if we go with 1) for keeping it in the
long term, or deprecate with 2).

Thanks,
-Toshi

