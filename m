Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3IUPls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:41:48 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48131 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab3IUPlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:41:47 -0400
Date: Sat, 21 Sep 2013 16:41:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bart Kuivenhoven <bemk@redhat.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jcm@redhat.com, msalter@redhat.com
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
Message-ID: <20130921154127.GD21381@console-pimps.org>
References: <1379525333-4373-1-git-send-email-bemk@redhat.com>
 <20130920152859.GC21381@console-pimps.org>
 <1379708486.12705.131.camel@dhcp-128-237.ams.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379708486.12705.131.camel@dhcp-128-237.ams.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Sep, at 10:21:26PM, Bart Kuivenhoven wrote:
> Well, isn't it so, that the kernel expects a setup in which interrupts
> are disabled before the decompressed image is loaded?
 
Yes, but I wasn't advocating leaving interrupts enabled, rather, because
interrupts are disabled we don't need to build an empty IDT, which will
never be used.

> What we can do is remove the lidt instruction and IDT pointer, but that
> still doesn't change anything with regards to the kernels expectations.
> 
> And no, I haven't witnessed a triple fault, this is purely theoretical,
> with a very slim chance of it actually happening. That does not mean
> that it can't happen though.
 
Right, but the answer to my question will dictate how aggressively we
apply your patch - whether it goes in the 'urgent' queue to be pushed
quickly or whether we give it more testing. Patches that fix serious
issues that users are hitting tend to make it into the next release. For
patches that fix theoretical bugs, we'll usually put it through more
strenuous testing first.

-- 
Matt Fleming, Intel Open Source Technology Center
