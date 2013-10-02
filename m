Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3JBPcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:32:19 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:8060 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3JBPcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:32:16 -0400
Message-ID: <1380727725.5429.13.camel@misato.fc.hp.com>
Subject: Re: [Suggestion] about calling debug_hotplug_cpu() which enabled by
 'allmodconfig' for a x86_64 dual core laptop.
From: Toshi Kani <toshi.kani@hp.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 02 Oct 2013 09:28:45 -0600
In-Reply-To: <524B8E97.1030707@asianux.com>
References: <524B8E97.1030707@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 03:10 +0000, Chen Gang wrote:
> Hello Maintainers:
> 
> Under my x86_64 dual core laptop, I build kernel next-20130927 with
> 'allmodconfig', and install it, the machine can not start. Related
> information is:
> 
>   after call debug_hotplug_cpu(), output "cpu 0 is offline" .... and then "Failed to execute /init".
> 
> After remove "_debug_hotplug_cpu(0, 0);", can pass the issue (but will
> fail in another place). I guess, the reason is my laptop cpu is not
> 'hotplug', but have to call debug_hotplug_cpu() with allmodconfig.
> 
> 
> I will continue analyzing, welcome any additional suggestions or
> completions.

allmodconfig sets CONFIG_DEBUG_HOTPLUG_CPU0 to y (which is defined as
"def_bool n"), which puts CPU0 offline during boot for testing.  This
debug feature is causing the problem on your laptop.  I am not familiar
with allmodconfig, but it seems that it enables all the config options,
preferably with 'm'.

Thanks,
-Toshi

