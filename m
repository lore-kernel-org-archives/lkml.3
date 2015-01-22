Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbbAVR6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:58:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50391 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbbAVR6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:58:22 -0500
Date: Thu, 22 Jan 2015 18:58:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: James Dingwall <james@dingwall.me.uk>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.18.2 / xen 4.4.1 dom0 - microcode oops
Message-ID: <20150122175818.GB3554@pd.tnic>
References: <20150122055242.GA11089@dingwall.me.uk>
 <20150122082003.GA3441@pd.tnic>
 <54C10DB6.2050708@oracle.com>
 <54C10ED0.1010302@oracle.com>
 <20150122153002.GA3554@pd.tnic>
 <20150122174315.GA32051@dingwall.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150122174315.GA32051@dingwall.me.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 05:43:15PM +0000, James Dingwall wrote:
> This patch solves it for me on my dom0 with 3.18.3, now there is
> nothing printed at all from the microcode driver which doesn't seem
> surprising given where the return is.

Yap, xen does/will update microcode differently...

> I'll check it on bare metal at the next opportunity but from my
> understanding of what is happening there I don't see that it should
> have any impact at all.

Yeah, it shouldn't have any effect on baremetal in the sense that it
should load properly there. And it is a fix for baremetal too, as Boris
pointed out.

I'm still curious as to why does it say this on your machine:

[  176.855832] microcode: CPU0 sig=0x10676, pf=0x1, revision=0x60c
[  176.855844] microcode: CPU0 update to revision 0x60f failed

?

This basically says that we do try to update with the patch but the
hardware doesn't accept it.

Is this new? Did it ever update microcode properly?

Where do you get the microcode for that machine?

Can you run the scriptlet below as root and send me the results? You'd
need the msr-tools package and the msr.ko kernel module loaded. Ask if
you need help.

Also, please send me a full dmesg with "ignore_loglevel log_buf_len=16M
debug" on the kernel command line, privately is fine too.

Thanks.

--
#!/bin/bash

echo "/proc/cpuinfo: "
cat /proc/cpuinfo

echo; echo "dmesg: "
dmesg | grep -i microcode
modprobe msr 2>/dev/null

echo ; echo "MSRs: (0x8b) "
rdmsr --all 0x8b
--

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
