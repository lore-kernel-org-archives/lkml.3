Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3IWJ2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:28:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3IWJ17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:27:59 -0400
Message-ID: <1379928463.1953.30.camel@dhcp-128-237.ams.redhat.com>
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
From: Bart Kuivenhoven <bemk@redhat.com>
Reply-To: bemk@redhat.com
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jcm@redhat.com, msalter@redhat.com
Date: Mon, 23 Sep 2013 11:27:43 +0200
In-Reply-To: <20130921154127.GD21381@console-pimps.org>
References: <1379525333-4373-1-git-send-email-bemk@redhat.com>
	 <20130920152859.GC21381@console-pimps.org>
	 <1379708486.12705.131.camel@dhcp-128-237.ams.redhat.com>
	 <20130921154127.GD21381@console-pimps.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-21 at 16:41 +0100, Matt Fleming wrote:
> On Fri, 20 Sep, at 10:21:26PM, Bart Kuivenhoven wrote:
> > Well, isn't it so, that the kernel expects a setup in which interrupts
> > are disabled before the decompressed image is loaded?
>  
> Yes, but I wasn't advocating leaving interrupts enabled, rather, because
> interrupts are disabled we don't need to build an empty IDT, which will
> never be used.

Ah, well in that case I think you'll like the new version of my patch
that I'll send out soon.

> > What we can do is remove the lidt instruction and IDT pointer, but that
> > still doesn't change anything with regards to the kernels expectations.
> > 
> > And no, I haven't witnessed a triple fault, this is purely theoretical,
> > with a very slim chance of it actually happening. That does not mean
> > that it can't happen though.
>  
> Right, but the answer to my question will dictate how aggressively we
> apply your patch - whether it goes in the 'urgent' queue to be pushed
> quickly or whether we give it more testing. Patches that fix serious
> issues that users are hitting tend to make it into the next release. For
> patches that fix theoretical bugs, we'll usually put it through more
> strenuous testing first.

I haven't seen it happen.

Even if it happens, the CPU will just reset and try again, with a very
high likelihood that it will succeed that time.

Given these circumstances, I'd say you're more than welcome to put my
work through some serious tests rather than giving it 'urgent' status.

-- 
Kind regards/Met vriendelijke groet,
Bart Kuivenhoven.

Intern Fedora ARM,
Red Hat.

