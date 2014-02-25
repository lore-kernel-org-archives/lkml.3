Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaBYXJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:09:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaBYXJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:09:29 -0500
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
From: Alexander Graf <agraf@suse.de>
X-Mailer: iPhone Mail (11B554a)
In-Reply-To: <530CD443.7010400@intel.com>
Date: Wed, 26 Feb 2014 07:09:10 +0800
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4B3C0B08-45E1-48EF-8030-A3365F0E7CF6@suse.de>
References: <1393284484-27637-1-git-send-email-agraf@suse.de> <530CD443.7010400@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Am 26.02.2014 um 01:34 schrieb Dave Hansen <dave.hansen@intel.com>:
> 
>> On 02/24/2014 03:28 PM, Alexander Graf wrote:
>> Configuration of tunables and Linux virtual memory settings has traditionally
>> happened via sysctl. Thanks to that there are well established ways to make
>> sysctl configuration bits persistent (sysctl.conf).
>> 
>> KSM introduced a sysfs based configuration path which is not covered by user
>> space persistent configuration frameworks.
>> 
>> In order to make life easy for sysadmins, this patch adds all access to all
>> KSM tunables via sysctl as well. That way sysctl.conf works for KSM as well,
>> giving us a streamlined way to make KSM configuration persistent.
> 
> Doesn't this essentially mean "don't use sysfs for configuration"?
> Seems like at least /sys/kernel/mm/transparent_hugepage would need the
> same treatment.
> 
> Couldn't we also (maybe in parallel) just teach the sysctl userspace
> about sysfs?  This way we don't have to do parallel sysctls and sysfs
> for *EVERYTHING* in the kernel:
> 
>    sysfs.kernel.mm.transparent_hugepage.enabled=enabled

It's pretty hard to filter this. We definitely do not want to expose all of sysfs through /proc/sys. But how do we know which files are actual configuration and which ones are dynamic system introspection data?

We could add a filter, but then we can just as well stick with the manual approach I followed here :).

> 
> Or do we just say "sysctls are the way to go for anything that might
> need to be persistent, don't use sysfs"?

IMHO there are 2 paths we can take:

1) Admit that using sysfs for configuration is a bad idea, use sysctl instead

2) Invent a streamlined way to set sysfs configuration variables similar to how we can set sysctl values

I'm not really sure which path is nicer. But the sitaution today is not exactly satisfactory. The most common solution to ksm configuration is an init  or systemd script that sets the respective config variables.


Alex