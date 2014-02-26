Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaBZADD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:03:03 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39134 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaBZADA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:03:00 -0500
MIME-Version: 1.0
In-Reply-To: <530CD443.7010400@intel.com>
References: <1393284484-27637-1-git-send-email-agraf@suse.de> <530CD443.7010400@intel.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 26 Feb 2014 01:02:39 +0100
Message-ID: <CAPXgP10NhyepKXVboF+=AbXD=0kH6XFbijUL-s8aUjcLKq4myQ@mail.gmail.com>
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
To: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Graf <agraf@suse.de>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 6:34 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 02/24/2014 03:28 PM, Alexander Graf wrote:
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
>         sysfs.kernel.mm.transparent_hugepage.enabled=enabled
>
> Or do we just say "sysctls are the way to go for anything that might
> need to be persistent, don't use sysfs"?

Support in sysctl for setting static data in /sys might make sense for
some rare use cases.

It's still not obvious how to handle the dynamic nature of most of the
data that is created by modules, and which data belongs into udev
rules and which in the "sysctl /sys" settings.

Kay
