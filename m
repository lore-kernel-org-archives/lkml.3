Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3KHEOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 23:14:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45702 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3KHEOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 23:14:41 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <527C64E2.4000501@jp.fujitsu.com>
Date: Fri, 08 Nov 2013 13:13:22 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Baoquan He <bhe@redhat.com>
CC: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6> <20131108033043.GA3133@dhcp-16-105.nay.redhat.com>
In-Reply-To: <20131108033043.GA3133@dhcp-16-105.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/08 12:30), Baoquan He wrote:
> Hi,
>
> Reccently people reported kexec didn't work correctly. After check, it's
> a regression. Since a code block which migrate current thread to cpu0
> when executing "kexec -e", this can be reproduced by setting affinity to
> CPUn(n!=0). You can find this patch in this link:
> https://lkml.org/lkml/2013/11/5/88
>
> Then I thought why we don't do this in kdump. I tried migrating current
> thread to cpu0 when crash happened, it works very well. Set affinity to
> make crash happened on CPUn(n!=0), then all cpus can be brought up and
> dump is successful. I pasted the patch as below.
>
> Only one thing worried me, whether the context related to crash cpu will
> be different, and do we care which cpu crashed. If it need be cared, or
> it doesn't involve difference, That will be great. Multiple CPUs can be
> supported easily in this simpler way. Meanwhile, this patch just try to
> migrate, if it's failed, we can avoid to bring up bsp.
>
> Watch do you think about it?
>

We have already discussed this idea. It's the idea of my first patch and
it was nacked. See the following url. (Sorry, I removed explanation of
development history from patch description at v4 patch, but I've planned
to write what ideas doesn't work well in documentation of this work.)

https://lkml.org/lkml/2012/4/15/181

The key reason why we cannot do that is the environment we are running
must be considered broken. Either interrupts or scheduler could no longer
work. Tables for interrupts can be broken. The other cpus except for the
crashing cpu are no longer guaranteed to be running sanely. Migrating cpu
from the crashing cpu to cpu0 reduces reliability of kdump.

-- 
Thanks.
HATAYAMA, Daisuke

