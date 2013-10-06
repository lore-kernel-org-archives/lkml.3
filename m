Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3JFPuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:50:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:41415 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab3JFPuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:50:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1044,1371106800"; 
   d="scan'208";a="406205495"
Message-ID: <525186B2.1000205@linux.intel.com>
Date: Sun, 06 Oct 2013 08:50:10 -0700
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
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com> <201310041622.29259.gheskett@wdtv.com> <524F2B4C.7080702@linux.intel.com> <201310041917.01126.gheskett@wdtv.com>
In-Reply-To: <201310041917.01126.gheskett@wdtv.com>
Content-Type: text/plain; charset=windows-1256; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/2013 4:17 PM, Gene Heskett wrote:
>>> I hope this is a better explanation. :)
>>
>> The idea of power capping is to cap total power not power down and also
>> need root level access to modify.
>
> No.  Restricting it to root control only is NOT an option.  There has to be
> some mechanism whereby the users non-root program can control it.  We don't
> run this software as root, ever.  And the part of this software that needs
> the parport (or a pci card access) is running on a cpu core that has been
> isolated for its use by an isocpus= statement, not visible to top or any
> other system monitoring utility, so you would never know we are pounding on
> that port, both reads and multiple writes, at least 3 times every 23
> microseconds.  So you might see it as idle and turn it off.

I understand that you do not want to see powercapping in effect.
I think I mostly understand the realtime angle you're coming from as well.

However, powercapping is not done for energy savings, it is done for SURVIVAL.
It is not something optional that you can just turn off and ignore;
if you ignore it... something either has a thermal meltdown or trips a circuit breaker... or
in the case of a laptop/tablet kind of shape, you give the user burn blisters.

(the thermal meltdown effect can be either damage to the system or a hard reset done by a hardware safety
mechanism.. neither is what you want for your realtime workload)

The solution to not use powercapping in combination with realtime is to make sure there
is ample cooling for the system, and to make sure the circuit breakers are big enough...
.... not ways to try to turn it off from non-root.

(and note that powerclamp for example takes realtime priority into account by only running at "half priority"...
... but if the real realtime prevents clamping altogether, other, more dracionian things will kick in)


and if you wonder what linux does today without the framework; there are mechanisms that kick in
at the very end of the range, that are very draconian like taking the 3.0Ghz processor down to
effectively 100MHz, or even a system reboot. The point of what Jacob and Srinivas are trying to add
is to intervene slightly earlier (these failsafe mechanisms are still there) but much much more gently.

