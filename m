Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3JWPx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 11:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3JWPx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 11:53:28 -0400
Date: Wed, 23 Oct 2013 11:51:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: jerry.hoemann@hp.com, hpa@linux.intel.com, ebiederm@xmission.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131023155127.GA17437@redhat.com>
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
 <20131022220803.GA32387@anatevka.fc.hp.com>
 <526712B2.7070108@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526712B2.7070108@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:05:06AM +0900, HATAYAMA Daisuke wrote:

[..]
> >Do you literally mean a human at each boot will have to configure
> >the kdump configuration files for passing disable_cpu_apic?
> >Or do you envision the setting of disable_cpu_apic being put into
> >the kdump initialization scripts?
> >
> >thanks
> >
> >Jerry
> 
> Nearer to the former case, but this is not what a human should do. It's
> a cumbersome task. I think, on fedora/RHEL system for example, kdump
> service should check at each boot automatically.

Hi Hatayama,

So what information should I look for to prepare disable_cpu_apic=X in
kdump script?

Is BSP processor info exported to user space somewhere? Or assuming that
processor 0 is BSP and corresponding apicid should be disabled in kdump
kernel is good enough?

I am looking at /proc/cpuinfo and following 3 fields seem interesting.

processor: 0
apicid		: 0
initial apicid	: 0

What's the difference between apicid and "initial apicid". I guess
initial apicid reflects the apicid number as set by firmware and then
kernel can overwrite it and new number would be reflected in "apicid"?

If that's the case, then I guess we should be looking at "apicid" of
processor "0" and set that in disable_cpu_apic? Because that's the
number kdump kernel  boot should see in apic upon boot.

Thanks
Vivek
