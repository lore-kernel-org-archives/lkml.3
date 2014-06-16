Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaFPUyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaFPUyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:54:13 -0400
Date: Mon, 16 Jun 2014 16:53:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: WANG Chao <chaowang@redhat.com>, Dave Young <dyoung@redhat.com>,
        mjg59@srcf.ucam.org, bhe@redhat.com, jkosina@suse.cz, greg@kroah.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140616205331.GA13257@redhat.com>
References: <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
 <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
 <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
 <20140613124609.GC5871@redhat.com>
 <20140613153620.GG4751@pd.tnic>
 <20140616173823.GC4515@redhat.com>
 <20140616200526.GF8170@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616200526.GF8170@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:05:26PM +0200, Borislav Petkov wrote:
> On Mon, Jun 16, 2014 at 01:38:23PM -0400, Vivek Goyal wrote:
> > And what's the sane default in this case?
> 
> COMMAND_LINE_SIZE
> 
> > Using current kernel's command line size will not work if future
> > kernel decide to support even longer command line size.
> 
> When do you ever get to kexec a kernel with command line size differing
> from the first kernel?This use case is pretty much non-existant to
> say the least (mind you, I'm open to examples but am still waiting for
> them). And even then you go and simply upgrade the first kernel.

Kdump kernel uses a different command line. It adds extra command line
options to currently running kernels.

Till recent past we used to pass new kernel's memory map using command
line "memmap=" and when command line size was 256, we could easily exhaust
command line on large machines.

Now we support 2048 and we have not seen that issue and now we have
moved to passing memory ranges in bootparams so that issue does not
exist. But kernel still does allow passing memmap= on command line.

One can do same thing using kexec too.

Agreed that it is a very corner case use case. Now we can say that we
will not support it. I am fine with that but I atleast wanted a discussion
and common understanding of what new syscall will support and what it
will not.

Some arches still seem to have COMMAND_LINE_SIZE 256. They will more
likely to hit this scenario at some point of time.

Given the fact you feel so strongly on putting this upper limit, I will
introduce it. And put a comment that if the kernel we are kexecing into
supports longer command line, the we will not support that size and one
needs to upgrade first kernel.

Thanks
Vivek
