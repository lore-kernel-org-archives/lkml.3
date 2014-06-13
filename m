Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaFMIBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:01:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaFMIBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:01:18 -0400
Date: Fri, 13 Jun 2014 16:00:28 +0800
From: WANG Chao <chaowang@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        mjg59@srcf.ucam.org, bhe@redhat.com, jkosina@suse.cz, greg@kroah.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140613080028.GK15034@dhcp-17-89.nay.redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
 <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
 <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613075011.GA4751@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/14 at 09:50am, Borislav Petkov wrote:
> On Mon, Jun 09, 2014 at 11:41:37AM -0400, Vivek Goyal wrote:
> > IIUC, COMMAND_LINE_SIZE gives max limits of running kernel and it does
> > not tell us anything about command line size supported by kernel being
> > loaded.
> 
> Whatever you do, you do need a sane default because even querying the
> boot protocol is not reliable as the to-be-loaded kernel's boot protocol
> might be manipulated too, before signing (who knows what people do
> in the wild).

Make sense.

> 
> So having a sane, unconditional fallback COMMAND_LINE_SIZE from the
> first kernel is a must, methinks.

By greping for COMMAND_LINE_SIZE for different arch, I think 8K being
the fallback, in general, is good for now and the future:

alpha/include/uapi/asm/setup.h
4:#define COMMAND_LINE_SIZE     256

arm/include/uapi/asm/setup.h
19:#define COMMAND_LINE_SIZE 1024

avr32/include/uapi/asm/setup.h
14:#define COMMAND_LINE_SIZE 256

cris/include/uapi/asm/setup.h
4:#define COMMAND_LINE_SIZE     256

frv/include/uapi/asm/setup.h
15:#define COMMAND_LINE_SIZE       512

ia64/include/uapi/asm/setup.h
4:#define COMMAND_LINE_SIZE     2048

m32r/include/uapi/asm/setup.h
8:#define COMMAND_LINE_SIZE       512

m68k/include/uapi/asm/setup.h
14:#define COMMAND_LINE_SIZE 256

mips/include/uapi/asm/setup.h
4:#define COMMAND_LINE_SIZE     4096

parisc/include/uapi/asm/setup.h
4:#define COMMAND_LINE_SIZE     1024

powerpc/include/uapi/asm/setup.h
4:#define COMMAND_LINE_SIZE     2048

s390/include/uapi/asm/setup.h
9:#define COMMAND_LINE_SIZE     4096

um/include/asm/setup.h
8:#define COMMAND_LINE_SIZE 4096

x86/include/asm/setup.h
6:#define COMMAND_LINE_SIZE 2048

xtensa/include/uapi/asm/setup.h
14:#define COMMAND_LINE_SIZE    256

c6x/include/uapi/asm/setup.h
4:#define COMMAND_LINE_SIZE   1024

microblaze/include/uapi/asm/setup.h
14:#define COMMAND_LINE_SIZE    256

mn10300/include/uapi/asm/param.h
16:#define COMMAND_LINE_SIZE 256

score/include/uapi/asm/setup.h
4:#define COMMAND_LINE_SIZE     256

tile/include/uapi/asm/setup.h
18:#define COMMAND_LINE_SIZE    2048

arc/include/asm/setup.h
15:#define COMMAND_LINE_SIZE 256

arm64/include/uapi/asm/setup.h
24:#define COMMAND_LINE_SIZE    2048
