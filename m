Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab3IMRhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:37:42 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:44495 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3IMRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:37:41 -0400
Message-ID: <1379093858.2197.24.camel@buesod1.americas.hpqcorp.net>
Subject: Re: GPT detection regression in efi.c from commit 27a7c64
From: Davidlohr Bueso <davidlohr@hp.com>
To: Matt Porter <matt.porter@linaro.org>
Cc: Karel Zak <kzak@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Date: Fri, 13 Sep 2013 10:37:38 -0700
In-Reply-To: <52334506.9030802@linaro.org>
References: <20130913145033.GA8502@ohporter.com>
	 <1379089736.2197.14.camel@buesod1.americas.hpqcorp.net>
	 <52334506.9030802@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 13:01 -0400, Matt Porter wrote:
> On 09/13/2013 12:28 PM, Davidlohr Bueso wrote:
[...]
> 
> >> I get that this is not compliant with UEFI. I bring this up because
> >> before this commit the is_pmbr_valid() check was less pedantic. In 3.11
> >> a PMBR formatted this way did not fail the check. For my particular
> >> case, I simply dded out LBA 1 and whacked the SizeInLBA field to comply
> >> with the spec and this patch and I'm back in business. We're updating
> >> the tools that we inherited to prepopulate our boards with a GPT to be
> >> compliant. However, I wondered if this would be a problem for all the
> >> people with Windows-generated GPTs as noted in [1].
> >
> > I guess this comes down to choosing whether or not we want Linux to be
> > more UEFI compliant or not. Should we care if Microsoft decides to go do
> > things out of the official spec? I don't know the policy here. The fact
> > is that *they* should update their partitioning tools and create valid
> > pMBRs. Any way, I'm ok with reverting this commit if deemed necessary.
> 
> I can't say first-hand that Windows 7/8 does what is claimed in this 
> description as I simply don't have access to any Windows machines here. 
> If it's true, I would have to agree with Linus that meeting reality if 
> more important than meeting the spec.

Yep, me too.

> 
> Hopefully somebody can confirm that Windows does indeed produce these 
> special PMBRs that need to be handled as an exception to the spec.

I've got a partition with Windows 7 and I can take a look during the
weekend. Do you know exactly what tool was used for creating the
partition?

Thanks,
Davidlohr

