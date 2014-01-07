Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaAGOh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:37:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaAGOht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:37:49 -0500
Date: Tue, 7 Jan 2014 09:37:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com
Subject: Re: kexec: reuse 1st kernel as kexec/kdump kernel?
Message-ID: <20140107143723.GB1524@redhat.com>
References: <20140107023405.GC3967@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107023405.GC3967@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 10:34:06AM +0800, Dave Young wrote:
> Hi, all
> 
> I have a question in mind: can we copy and prepare kexec kernel while
> normal booting?
> 
> Just like below wild idea:
> 
> Kernel uncompress itself (assume kernel is relocatable)
> -> copy the kernel image somewhere for backup
>   -> reserver crashkernel memory
>     -> copy the backuped kernel image/initrd image to reserved memory
>       -> copy the purgatory which can be embedded in elf section?
>         -> prepare the e820 memory ranges which is for kdump kernel
> 
> So userspace only need to call kexec reboot, kexec_load is not necessary.
> The initrd for kdump should be different, but we can add some different logic
> which will be only for kdump and it can be skipped in normal boot.
> 
> Is it doable?

What's the advantage of doing all this? Why are you trying to skip load
step.

Thanks
Vivek
