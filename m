Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab3GRSel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:34:41 -0400
Received: from www.sr71.net ([198.145.64.142]:33568 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329Ab3GRSek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:34:40 -0400
Message-ID: <51E83536.6070100@sr71.net>
Date: Thu, 18 Jul 2013 11:34:30 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Dave Hansen <dave.hansen@intel.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
References: <1374097503-25515-1-git-send-email-toshi.kani@hp.com>  <51E80973.9000308@intel.com> <1374164815.24916.84.camel@misato.fc.hp.com>
In-Reply-To: <1374164815.24916.84.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 09:26 AM, Toshi Kani wrote:
> On Thu, 2013-07-18 at 08:27 -0700, Dave Hansen wrote:
>> I'd really prefer you don't do this.  Do you really have random
>> processes on your system poking at random sysfs files and then
>> complaining when things break?
> 
> I am afraid that the "probe" interface does not provide the level of
> quality suitable for regular users.  It takes any value and blindly
> extends the page table.

That's like saying that /dev/sda takes any value and blindly writes it
to the disk.

> Also, we are not aware of the use of this
> interface on x86.  Would you elaborate why you need this interface on
> x86?  Is it for your testing, or is it necessary for end-users?  If the
> former, can you modify .config file to enable it?

For me, it's testing.  It allows testing of the memory hotplug software
stack without actual hardware, which is incredibly valuable.  That
includes testing on distribution kernels which I do not want to modify.
 I thought there were some hypervisor users which don't use ACPI for
hotplug event notifications too.

All that I'm asking is that you either leave it the way it is, or make a
Kconfig menu entry for it.

But, really, what's the problem that you're solving?  Has this caused
you issues somehow?  It's been there for, what, 10 years?  Surely it's
part of the ABI.


