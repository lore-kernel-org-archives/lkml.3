Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab3KMSGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:06:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:53267 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759205Ab3KMSGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:06:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="320599510"
Message-ID: <5283C0AE.4050403@linux.intel.com>
Date: Wed, 13 Nov 2013 10:10:54 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 0/3] Bring SFI support to out-of-tree driver modules on
 Intel Mid
References: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com> <20131113081445.GA19388@infradead.org> <20131113111934.GB9654@gmail.com>
In-Reply-To: <20131113111934.GB9654@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 03:19 AM, Ingo Molnar wrote:
>
> * Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Tue, Nov 12, 2013 at 02:13:37PM -0800, David Cohen wrote:
>>
>>> Hi,
>>>
>>> This patchset extends sfi_device() macro support to driver modules.
>>> The main use case is to allow external driver modules to be enumerated
>>> by SFI on Intel Mid platforms.
>>
>> How about you merge those module again?  Remember code added to the
>> kernel without users isn't testable, and out of tree modules do not
>> bring us any value add.
>
> I wanted to make the exact same point.
>
> I recently had to revert a similarly misguided attempt which added bloat
> for out of tree modules without merging it in tree, see commit
> b5dfcb09debc ("Revert "x86/UV: Add uvtrace support").

I was a bit reluctant in sending these patches, but I can tell my
background to explain why:

I work most of my time with embedded platforms and I got the duty to
maintain and sync Intel Mid codes from our internal tree to upstream
(if you check out there Android trees supporting Intel platform you'll
see it's completely different to what we have officially on Linux).

Unfortunately some drivers depend on Intel Mid to support a legacy
device enumeration with SFI + platform codes (these platform codes are
placed into arch/x86/platform/intel-mid/device_libs/). It means I need
to support in my internal tree files that belong to drivers I don't
own. Most of times it's OK, but regardless my will, we've drivers that
can't be upstreamed right away.

In order to keep sanity in Intel Mid codes between internal tree and
upstream, I'm trying to make non-upstreamable drivers to not mix
platform codes to Intel Mid until they are ready to get merged to Linux
kernel officially. This change makes Linux more friendly for drivers to
reach time-to-market and do upstream work at same time.
One other reason is to keep my internal tree closer to upstream and
make things easier for upstreaming of Intel Mid patches themselves
(which is my main interest).

But this code is testable. I used the word "external" because all the
platform code merged into Linux are compiled as builtin. But my tests
prior to send these patches were done by converting some of those codes
to be compiled as module (I am glad to share the patches for tests).

Br, David Cohen

>
> Thanks,
>
> 	Ingo
>

