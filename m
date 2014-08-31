Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaHaXUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:20:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:28850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaHaXUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:20:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="379544899"
Message-ID: <5403ADA8.1090903@linux.intel.com>
Date: Sun, 31 Aug 2014 16:20:08 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, falcon@meizu.com,
        tiwai@suse.de, linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com> <540334B2.7000009@linux.intel.com> <20140831175040.GA17827@core.coreip.homeip.net> <5403767E.1020107@linux.intel.com> <20140831193140.GA12678@kroah.com> <20140831201407.GB19881@core.coreip.homeip.net> <20140831204035.GA4793@kroah.com> <20140831215313.GA28690@mtj.dyndns.org> <20140831221534.GA18064@kroah.com> <20140831225312.GA29948@mtj.dyndns.org>
In-Reply-To: <20140831225312.GA29948@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/2014 3:53 PM, Tejun Heo wrote:
> Hello,
>
> On Sun, Aug 31, 2014 at 03:15:34PM -0700, Greg KH wrote:
>> For the use cases we have today, it would work.  We have a few drivers
>> that take a _long_ time in their probe callback, and they need to be
>> made async for various reasons (modprobe timeout killer, touchscreen
>> init sequence stalling boot, etc.)
>
> Oh, but there already is a reported case which fails.  Hard drives
> with a lot of platters take > 10secs to spin up and there are
> configurations which regularly fail the initial reset and it's quite
> rare but probing time taking over 30s does happen in the wild.  We
> can't mark libata as requiring async probing on module load
> unconditionally but at the same time we need them to be asynchronous
> for use cases which don't depend on synchronous behavior has has
> timeout.

libata probing is already async thankfully.

