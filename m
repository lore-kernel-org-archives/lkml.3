Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaFMMqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaFMMqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:46:51 -0400
Date: Fri, 13 Jun 2014 08:46:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: WANG Chao <chaowang@redhat.com>, Dave Young <dyoung@redhat.com>,
        mjg59@srcf.ucam.org, bhe@redhat.com, jkosina@suse.cz, greg@kroah.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140613124609.GC5871@redhat.com>
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

On Fri, Jun 13, 2014 at 09:50:11AM +0200, Borislav Petkov wrote:
> On Mon, Jun 09, 2014 at 11:41:37AM -0400, Vivek Goyal wrote:
> > IIUC, COMMAND_LINE_SIZE gives max limits of running kernel and it does
> > not tell us anything about command line size supported by kernel being
> > loaded.
> 
> Whatever you do, you do need a sane default because even querying the
> boot protocol is not reliable as the to-be-loaded kernel's boot protocol
> might be manipulated too, before signing (who knows what people do
> in the wild).

If signature verification is on, that should catch any manipulation to
to protocol headers.

If not, then we really can't do anything about it. A large memory
allocation will fail and user will get error. 

This is not different than length of kernel or length of initrd. Somebody
might prepare a very huge file and pass that fd to kernel and kernel will
try to read the whole thing in. If file is too large, memory allocation
will fail and user space will get error. We don't try to put an upper
limit on size of kernel image or initrd.

> 
> So having a sane, unconditional fallback COMMAND_LINE_SIZE from the
> first kernel is a must, methinks.

I disagree here. What if new kernel supports (2 * COMMAND_LINE_SIZE) length
command line. We don't want to truncate command line to smaller size
because running kernel does not support that long a command line.

Thanks
Vivek

