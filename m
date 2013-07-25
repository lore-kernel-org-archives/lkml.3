Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3GYVia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:38:30 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:33767 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GYVi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:38:27 -0400
Date: Thu, 25 Jul 2013 23:38:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, dave@sr71.net,
        kosaki.motohiro@gmail.com, isimatu.yasuaki@jp.fujitsu.com,
        tangchen@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH v2] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
Message-ID: <20130725213822.GG18254@gmail.com>
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
 <20130722083721.GC25976@gmail.com>
 <1374513120.16322.21.camel@misato.fc.hp.com>
 <20130723080101.GB15255@gmail.com>
 <1374612301.16322.136.camel@misato.fc.hp.com>
 <20130724042041.GA8504@gmail.com>
 <1374685121.16322.218.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374685121.16322.218.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Toshi Kani <toshi.kani@hp.com> wrote:

> > You claimed that the only purpose of this on x86 was 
> > that testing was done on non-hotplug systems, using 
> > this interface. Non-hotplug systems have e820 maps.
> 
> Right.  Sorry, I first thought that the interface needed 
> to work as defined, i.e. detect a new memory.  But for 
> the test purpose on non-hotplug systems, that is not 
> necessary.  So, I agree that we can check e820.
> 
> I summarized two options in the email below.
> https://lkml.org/lkml/2013/7/23/602
> 
> Option 1) adds a check with e820.  Option 2) deprecates 
> the interface by removing the config option from x86 
> Kconfig.  I was thinking that we could evaluate two 
> options after this patch gets in.  Does it make sense?

Yeah.

That having said, if the e820 check is too difficult to 
pull off straight away, I also don't mind keeping it as-is 
if it's useful for testing. Just make sure you document it 
as "you need to be careful with this" (beyond it being a 
root-only interface to begin with).

Thanks,

	Ingo
