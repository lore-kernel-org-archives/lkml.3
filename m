Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab3JGPrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:47:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:56135 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab3JGPrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:47:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1051,1371106800"; 
   d="scan'208";a="406678386"
Message-ID: <5252D752.90401@linux.intel.com>
Date: Mon, 07 Oct 2013 08:46:26 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 3/6] PowerCap: Added to drivers build
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com> <201310041917.01126.gheskett@wdtv.com> <525186B2.1000205@linux.intel.com> <201310061616.00303.gheskett@wdtv.com>
In-Reply-To: <201310061616.00303.gheskett@wdtv.com>
Content-Type: text/plain; charset=windows-1256; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/2013 1:15 PM, Gene Heskett wrote:
>> and if you wonder what linux does today without the framework; there are
>> mechanisms that kick in at the very end of the range, that are very
>> draconian like taking the 3.0Ghz processor down to effectively 100MHz,
>> or even a system reboot. The point of what Jacob and Srinivas are trying
>> to add is to intervene slightly earlier (these failsafe mechanisms are
>> still there) but much much more gently.
>
> First off, we are not using the type of boards for controllers that would
> burn anything up sans its normal cooling, which is entirely passive on an
> atom powered board as you well know.  So there is no fan to fail and start
> your doomsday scenario in abut 30% of the cases now, but there are a rather
> dukes mixture of other boards being used yet.  Those will be replaced in
> due time as they fail, or the IRQ latency finally starts costing the shop
> owner money because the machine can't be run at the optimum speed with that
> poorly architect-ed board, probably with Atoms or BBB's.

so if your system today never hits the thermal shutdown...
... you're not going to hit anything powercapping either.



> If you insist on doing this, in the face of ample evidence its nothing but
> a feel good action on your part, then the least we ask is for a tally
> signal output, far enough in advance, say 0.25 seconds, to do a graceful,

btw one thing to note that this is just the kernel mechanism; the actual
knobs that it provides get turned by some userspace daemon..
I would fully expect that if you even ship such a daemon on your realtime device,
that you build in the notification for sure.


> In fact, I'd go so far as to say that any hardware capable of self-
> destructing in normal operation, does not need to guarded by this proposed
> function, but blacklisted instead, it is patently a defective design from
> square one regardless of the brand name on the box.  Or just let it burn
> up, the warranty returns will educate the maker/designer soon enough.

self-destruct or reboot... either case you will not like it.


