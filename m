Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaFPUFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:05:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58557 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaFPUFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:05:37 -0400
Date: Mon, 16 Jun 2014 22:05:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>, Dave Young <dyoung@redhat.com>,
        mjg59@srcf.ucam.org, bhe@redhat.com, jkosina@suse.cz, greg@kroah.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140616200526.GF8170@pd.tnic>
References: <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
 <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
 <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
 <20140613124609.GC5871@redhat.com>
 <20140613153620.GG4751@pd.tnic>
 <20140616173823.GC4515@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140616173823.GC4515@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 01:38:23PM -0400, Vivek Goyal wrote:
> And what's the sane default in this case?

COMMAND_LINE_SIZE

> Using current kernel's command line size will not work if future
> kernel decide to support even longer command line size.

When do you ever get to kexec a kernel with command line size differing
from the first kernel? This use case is pretty much non-existant to
say the least (mind you, I'm open to examples but am still waiting for
them). And even then you go and simply upgrade the first kernel.

Why are we even talking about this?

> I agree that some kind of upper value is good. But I am disagreeing
> that using current kernel's COMMAND_LINE_SIZE is better thing to do.

Again, stop arguing about some nonsensical cases and give me a real use
case where this is a problem.

> Also what's the upper limit on initramfs size? There is none. The issues
> you are trying to prevent can be easily created simply by passing in
> a large initrd file.
> 
> If we are not putting any sane defaults on size of kernel and initramfs, I
> am not really sure what do we gain here by putting an incorrect limit
> on kernel command line size.

You need to have a *sane* default length for a command line size - not
what's possible or what's not - something sane.

> Who knows that in future we might have to extend it beyond 2048. You
> can't say that 2048 wil never be changed. Nobody knows.

Dude, stop arguing this dumb case - if the command line size is changed,
you simply update the first kernel. What is the use case of having to
kexec a newer kernel on an older kernel? Spit it out already.

> > And even if this is a problem - which I seriously doubt - it would be
> > problem with the 1st kernel too, not only with the kexec-ed one.
> 
> Why it will be a problem with first kernel?

Because if a kernel overflows COMMAND_LINE_SIZE, then something's wrong
with that use case and needs to get information passed in a different
manner - not 2K of cmdline string. Again, where is the sane use case?

> So assuming that you will agree that we might have to extend kernel
> command line some day, my question is how would you support kexec from
> old kernel to newer kernel with larger command line size.

Why do I need to support that case?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
