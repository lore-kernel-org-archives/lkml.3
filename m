Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaBEQig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:38:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbaBEQie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:38:34 -0500
Date: Wed, 5 Feb 2014 11:38:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jerry Hoemann <jerry.hoemann@hp.com>
Subject: Re: [PATCH] x86, apic: clean up handling of boot_cpu_physical_apicid
 in boot process
Message-ID: <20140205163824.GF6042@redhat.com>
References: <52D7A8F0.70807@jp.fujitsu.com>
 <alpine.DEB.2.02.1401252000050.10325@chino.kir.corp.google.com>
 <52E5CA8D.7000602@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E5CA8D.7000602@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 11:55:09AM +0900, HATAYAMA Daisuke wrote:

[..]
> ``bsp'' and ``boot cpu'' are different, but certainly they are close
> for most of people who don't need to focus the difference.

I agree. Especially this difference is becoming visible in kdump
context where we skip BIOS and can trigger a fresh boot on an AP.

Hatayama, I think distinguishing BSP and boot cpu makes sense and
we also need to find a way to export this information to user
space. So that we can figure out who is BSP and tell second kernel
not to bring up that cpu.

Initially we thought that cpu with "initial apicid" 0 is BSP. But
Jerry from HP is reporting that on some of the machines he has, BSP
does not have to have apic id 0.

If that's the case, we don't have a reliable way to figure out which is
BSP in the system. Or am I missing something?

Thanks
Vivek
