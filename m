Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaBERKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:10:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbaBERKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:10:33 -0500
Date: Wed, 5 Feb 2014 12:09:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jerry Hoemann <jerry.hoemann@hp.com>
Subject: Re: [PATCH] x86, apic: clean up handling of boot_cpu_physical_apicid
 in boot process
Message-ID: <20140205170959.GI6042@redhat.com>
References: <52D7A8F0.70807@jp.fujitsu.com>
 <alpine.DEB.2.02.1401252000050.10325@chino.kir.corp.google.com>
 <52E5CA8D.7000602@jp.fujitsu.com>
 <20140205163824.GF6042@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205163824.GF6042@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 11:38:24AM -0500, Vivek Goyal wrote:

[..]
> Initially we thought that cpu with "initial apicid" 0 is BSP. But
> Jerry from HP is reporting that on some of the machines he has, BSP
> does not have to have apic id 0.
> 
> If that's the case, we don't have a reliable way to figure out which is
> BSP in the system. Or am I missing something?

Or, can I look at "processor" field in /proc/cpuinfo. If this is 0, will
this always mean it represents the cpu on which kernel booted.

If yes, then in first kernel one can safely assume that boot cpu is bios
designated BSP also. And kdump scripts should be able to automate that.

Though this assumption can be broken in second kernel but as of today
nobody needs to know bios designated BSP in second kernel.

Thanks
Vivek
