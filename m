Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3JCPK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:10:57 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:12602 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3JCPKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:10:55 -0400
Message-ID: <1380812843.5429.46.camel@misato.fc.hp.com>
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
Date: Thu, 03 Oct 2013 09:07:23 -0600
In-Reply-To: <524D7D81.9090903@asianux.com>
References: <524B8E97.1030707@asianux.com>
	  <1380727725.5429.13.camel@misato.fc.hp.com> <524C4CC9.3080402@gmail.com>
	 <1380742391.5429.37.camel@misato.fc.hp.com> <524CBF19.2030708@asianux.com>
	 <524D7D81.9090903@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 22:21 +0800, Chen Gang wrote:
> One root cause found (but not only one), allmodconfig will enable
> CONFIG_SYSFS_DEPRECATED which for new kernel on old distribution.
> 
> 
> I am comparing from allmodconfig config file to defconfig config file,
> the attachments are middle files (one enable CONFIG_SYSFS_DEPRECATED
> which can not boot up, the other disable it which can boot up).
> 
> The related information in "init/Kconfig"
> 
>   config SYSFS_DEPRECATED
>     bool "Enable deprecated sysfs features to support old userspace tools"
>     depends on SYSFS
>     default n
>     help
>       This option adds code that switches the layout of the "block" class
>       devices, to not show up in /sys/class/block/, but only in
>       /sys/block/.
> 
>       This switch is only active when the sysfs.deprecated=1 boot option is
>       passed or the SYSFS_DEPRECATED_V2 option is set.
> 
>       This option allows new kernels to run on old distributions and tools,
>       which might get confused by /sys/class/block/. Since 2007/2008 all
>       major distributions and tools handle this just fine.
> 
>       Recent distributions and userspace tools after 2009/2010 depend on
>       the existence of /sys/class/block/, and will not work with this
>       option enabled.
> 
>       Only if you are using a new kernel on an old distribution, you might
>       need to say Y here.
> 
> 
> I will continue to analyze another related issues for allmodconfig on
> my laptop (after disable SYSFS_DEPRECATED, for allmodconfig, it still
> can not boot up successfully, although my 'middle' config file can).

Since this is no longer a hotplug issue, I'd suggest you change the
subject line and resend it to the folks who worked on this config
option.  I won't be able to help on this one.

-Toshi


