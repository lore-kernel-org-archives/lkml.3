Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3J0OiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 10:38:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33124 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3J0OiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 10:38:15 -0400
Message-ID: <526D2550.8080600@infradead.org>
Date: Sun, 27 Oct 2013 07:38:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Krzysztof Mazur <krzysiek@podlesie.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH] DYNAMIC_DEBUG: use select DEBUG_FS instead of depends
 on
References: <1382821093-2484-1-git-send-email-krzysiek@podlesie.net> <20131027033000.GB32210@kroah.com> <20131027080151.GA26131@shrek.podlesie.net>
In-Reply-To: <20131027080151.GA26131@shrek.podlesie.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/13 01:01, Krzysztof Mazur wrote:
> On Sat, Oct 26, 2013 at 08:30:00PM -0700, Greg Kroah-Hartman wrote:
>> On Sat, Oct 26, 2013 at 10:58:13PM +0200, Krzysztof Mazur wrote:
>>> Depending on options that are configured later makes them hard
>>> to enable unless the user knows that he must go backwards.
>>
>> Really?  We've had this for well over 2 years, people are confused about
>> this?
>>
>> Where?
> 
> The v3.10 is ok - CONFIG_DYNAMIC_DEBUG is after CONFIG_DEBUG_FS.
> 
> Maybe it's just me, because on my config I have CONFIG_DEBUG_FS=y,
> and on the system I was testing usbatm I had CONFIG_DEBUG_FS=n.
> 
> BTW, on x86_64 to disable CONFIG_DEBUG_FS you need to disable
> CONFIG_AMD_IOMMU_STATS, which is enabled by default in the
> x86_64_defconfig (I think that CONFIG_AMD_IOMMU_STATS=n it's
> a better default). If you enable CONFIG_DEBUG_KERNEL you
> need to disable CONFIG_FTRACE which is enabled by default.
> So a lot of users will have CONFIG_DEBUG_FS already selected.

You are making a good argument for not using 'select' at all.

-- 
~Randy
