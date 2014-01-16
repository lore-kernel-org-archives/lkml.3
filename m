Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaAPGqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:46:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbaAPGq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:46:28 -0500
Date: Thu, 16 Jan 2014 14:46:28 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Message-ID: <20140116064627.GC6356@dhcp-16-126.nay.redhat.com>
References: <20140113122320.GA1900@darkstar.nay.redhat.com>
 <52D3FCAA.7070004@linux.intel.com>
 <20140114014003.GB4327@dhcp-16-126.nay.redhat.com>
 <52D57F75.7060308@zytor.com>
 <20140115011609.GD23767@dhcp-16-126.nay.redhat.com>
 <52D6970D.3050701@zytor.com>
 <20140116014457.GA3807@dhcp-16-126.nay.redhat.com>
 <52D746D9.7030206@linux.intel.com>
 <20140116030343.GF3807@dhcp-16-126.nay.redhat.com>
 <52D75A55.2080503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D75A55.2080503@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/14 at 08:04pm, H. Peter Anvin wrote:
> On 01/15/2014 07:03 PM, Dave Young wrote:
> >>
> >> making something harder to grep and less standardized is hardly cleaner
> >> and these things compile to nothing for non-modules.
> > 
> > It's not nothing, just very small increasement:
> >    text	   data	    bss	    dec	    hex	filename
> > 7636121	1391824	9355264	18383209	1188169	vmlinux
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 7636113	1391824	9355264	18383201	1188161	vmlinux
> > 
> > I do not want to insist on this minor problem, if you want please keep it.
> > 
> 
> Now *that* we can fix by making these macros expand to nothing if you
> are compiling for a nonmodule, right?  That will benefit code that
> legitimately can compile as a module but is configured "y", too.

I'm not sure expanding to nothing is a good fix.

For built-in module we still can retrieve the module info in userspace via
/usr/sbin/modinfo, if we expand the Macros to nothing then userspace will
not see thus infomation anymore.

Another advantage of built-in module is it has module specific parameters which
should not necessary a generic kernel parameter.

If the *module* is really a nonmodule, IMHO it should add the information to
or add other macros macros instead of reuse the MODULE_*.

BTW, for macros in this file, for a nonmodule "license GPL" is unnecessary at all.

Thanks
Dave
