Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbaAGCeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:34:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbaAGCeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:34:02 -0500
Date: Tue, 7 Jan 2014 10:34:06 +0800
From: Dave Young <dyoung@redhat.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, vgoyal@redhat.com, hpa@zytor.com
Subject: kexec: reuse 1st kernel as kexec/kdump kernel?
Message-ID: <20140107023405.GC3967@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I have a question in mind: can we copy and prepare kexec kernel while
normal booting?

Just like below wild idea:

Kernel uncompress itself (assume kernel is relocatable)
-> copy the kernel image somewhere for backup
  -> reserver crashkernel memory
    -> copy the backuped kernel image/initrd image to reserved memory
      -> copy the purgatory which can be embedded in elf section?
        -> prepare the e820 memory ranges which is for kdump kernel

So userspace only need to call kexec reboot, kexec_load is not necessary.
The initrd for kdump should be different, but we can add some different logic
which will be only for kdump and it can be skipped in normal boot.

Is it doable?

Thanks
Dave
