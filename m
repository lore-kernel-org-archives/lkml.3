Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbaFPVJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:09:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50624 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbaFPVJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:09:38 -0400
Date: Mon, 16 Jun 2014 23:09:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>, Dave Young <dyoung@redhat.com>,
        mjg59@srcf.ucam.org, bhe@redhat.com, jkosina@suse.cz, greg@kroah.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140616210927.GJ8170@pd.tnic>
References: <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
 <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
 <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
 <20140613124609.GC5871@redhat.com>
 <20140613153620.GG4751@pd.tnic>
 <20140616173823.GC4515@redhat.com>
 <20140616200526.GF8170@pd.tnic>
 <20140616205331.GA13257@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140616205331.GA13257@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:53:31PM -0400, Vivek Goyal wrote:
> Kdump kernel uses a different command line. It adds extra command line
> options to currently running kernels.
> 
> Till recent past we used to pass new kernel's memory map using command
> line "memmap=" and when command line size was 256, we could easily exhaust
> command line on large machines.
> 
> Now we support 2048 and we have not seen that issue and now we have
> moved to passing memory ranges in bootparams so that issue does not
> exist. But kernel still does allow passing memmap= on command line.
> 
> One can do same thing using kexec too.
> 
> Agreed that it is a very corner case use case. Now we can say that we
> will not support it. I am fine with that but I atleast wanted a discussion
> and common understanding of what new syscall will support and what it
> will not.
> 
> Some arches still seem to have COMMAND_LINE_SIZE 256. They will more
> likely to hit this scenario at some point of time.
> 
> Given the fact you feel so strongly on putting this upper limit, I will
> introduce it. And put a comment that if the kernel we are kexecing into
> supports longer command line, the we will not support that size and one
> needs to upgrade first kernel.

Nah, I don't feel strongly about it - I just don't trust userspace and
think that every value we get from it should be "sanitized".

But if you say that you want to be able to pass bigger command line to
2nd kernel because this is how kexec passes info, then I'm fine with it.
This is actually a very valid use case which I was asking for, thanks!

I guess if a malicious user goes at lenths to manipulate
header->cmdline_size just so that kmalloc still succeeds and we're fine
with it then I certainly don't have anything against it. I.e., if user
really wants to shoot himself in the foot, user can.

So it is a good thing we talked about it then. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
