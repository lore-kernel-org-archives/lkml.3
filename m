Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936589Ab3DRUNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 16:13:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41647 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935995Ab3DRUNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 16:13:53 -0400
Message-ID: <517053EF.2030900@zytor.com>
Date: Thu, 18 Apr 2013 13:13:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Darren Hart <darren.hart@intel.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt@console-pimps.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <20130418163325.GA6884@leaf> <5170216C.9020300@zytor.com> <20130418164457.GB6884@leaf> <51704FA8.7060801@console-pimps.org> <1366315083.13667.19.camel@x230.lan> <51705366.8070001@intel.com>
In-Reply-To: <51705366.8070001@intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 01:11 PM, Darren Hart wrote:
>>
>> I would expect that if there are any 32-bit UEFI systems that ship with
>> BGRT support (and Darren makes it sound like that's a possibility),
>> there's a realistic chance of the BGRT ending up allocated above the
>> highmem barrier.
> 
> I can certainly ensure we sit below that barrier on the MinnowBoard. We
> can also speak with the Intel UEFI firmware development teams to see
> about making that a requirement. I don't know if we'll be successful,
> but Matt, Peter, and I have recently coaxed some changes of that nature in.
> 

No, that is the wrong approach.  The HIGHMEM barrier is a Linux kernel
construct and isn't even guaranteed to be the same from one boot *of the
same kernel* to another.  The value 896M is merely the default, but it
can be affected by both compile time and command line options.

	-hpa

