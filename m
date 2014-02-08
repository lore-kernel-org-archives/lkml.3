Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaBHSAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 13:00:25 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:57467 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaBHSAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 13:00:24 -0500
Date: Sat, 8 Feb 2014 19:00:20 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Andi Kleen <ak@linux.intel.com>
Cc: mmarek@suse.cz, linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 5/6] kbuild: Use single pass kallsyms
Message-ID: <20140208180020.GB401@x4>
References: <1391845840-28514-1-git-send-email-ak@linux.intel.com>
 <1391845840-28514-5-git-send-email-ak@linux.intel.com>
 <20140208091920.GA400@x4>
 <20140208160143.GF12219@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208160143.GF12219@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.02.08 at 08:01 -0800, Andi Kleen wrote:
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index 4c5435f420a6..06469556c580 100644
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -213,7 +213,7 @@ if [ -n "${CONFIG_KALLSYMS}" ] ; then
> >  
> >  	info PATCHFILE vmlinux
> >  	OFF=$(${OBJDUMP} --section-headers vmlinux |
> > -	     gawk -f ./source/scripts/elf_file_offset \
> > +	     gawk -f ./scripts/elf_file_offset \
> 
> I think that would break with object dirs (which was what I used),
> because the scripts there only has some executables.
> 
> Really need ${srcdir}, but it would need to be exported first.
> 
> This should work:

Yes. The patch fixes the issue. 
Thanks.

-- 
Markus
