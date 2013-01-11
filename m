Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3AKUnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:43:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab3AKUnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:43:43 -0500
Date: Fri, 11 Jan 2013 15:43:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
Message-ID: <20130111204317.GB17126@redhat.com>
References: <50E41973.9050705@citrix.com>
 <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
 <50E6F81D02000078000B3245@nat28.tlf.novell.com>
 <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>
 <20130104191146.GC6721@phenom.dumpdata.com>
 <20130107123404.GA2927@host-192-168-1-59.local.net-space.pl>
 <20130107162018.GJ3219@phenom.dumpdata.com>
 <87ehhsqrpr.fsf@xmission.com>
 <20130111165506.GD25620@phenom.dumpdata.com>
 <50F07588.90902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F07588.90902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 12:26:48PM -0800, H. Peter Anvin wrote:
> >
> >And there is nothing fancy to be done for EFI and SecureBoot? Or is
> >that something that the kernel has to handle on its own (so somehow
> >passing some certificates to somewhere).
> >
> 
> For EFI, no... other than passing the EFI parameters, which
> apparently is *not* currently done (David Woodhouse is working on
> it.)  Secure boot is still a work in progress.

For secureboot, as a first step in that direction, I just wrote some code
to sign elf executable and be able to verify it in kernel upon exec(). I
am soon planning to post RFC code (most likely next week).

Hopefully we will be able to sign statically signed /sbin/kexec, give
it extra capability (upon signature verification) to be able to call
sys_exec().

Thanks
Vivek
