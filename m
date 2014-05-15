Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaEOTw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:52:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45287 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbaEOTw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:52:26 -0400
Message-ID: <53751AC8.6040902@zytor.com>
Date: Thu, 15 May 2014 12:51:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keir Fraser <keir.xen@gmail.com>
CC: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 7/9] x86: skip check for spurious faults for
 non-present faults
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com> <1397571337-20409-8-git-send-email-david.vrabel@citrix.com> <53750A96.2020201@zytor.com> <53751403.1010109@gmail.com>
In-Reply-To: <53751403.1010109@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 12:22 PM, Keir Fraser wrote:
>>
>> Are we chasing hardware errata here?  Or did someone go off and *assume*
>> that the x86 hardware architecture work a certain way?  Or is there
>> something way more subtle going on?
> 
> See Intel Developer's Manual Vol 3 Section 4.10.4.3, 3rd bullet... This
> is expected behaviour, probably to make copy-on-write faults faster.
> 

Hm, yes.  My memory of this comes from before these formal rules were
written down... I guess there is some wiggle room in there, presumably
as you say, for performance reasons (or implementation leeway, which is
another way to say performance.)

This does make a P bit switch architecturally different from W or NX, so
I'm okay with that, but I would like the patch adjusted in the following
ways:

1. Put in an explicit comment about the architectural difference
   between the P bit on one hand and an W and NX on the other; an SDM
   reference is good, and *why* this makes the specific filtering
   correct.

2. Please use the standard format for multiline comments;

	/*
         * blah
         * blah
         */

With that this should be okay.

	-hpa

