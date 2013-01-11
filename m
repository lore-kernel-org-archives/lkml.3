Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3AKVIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:08:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab3AKVIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:08:17 -0500
Date: Fri, 11 Jan 2013 16:08:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
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
        David Howells <dhowells@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
Message-ID: <20130111210801.GC12019@redhat.com>
References: <50E6F81D02000078000B3245@nat28.tlf.novell.com>
 <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>
 <20130104191146.GC6721@phenom.dumpdata.com>
 <20130107123404.GA2927@host-192-168-1-59.local.net-space.pl>
 <20130107162018.GJ3219@phenom.dumpdata.com>
 <87ehhsqrpr.fsf@xmission.com>
 <20130111165506.GD25620@phenom.dumpdata.com>
 <87k3rjtqi7.fsf@xmission.com>
 <20130111205232.GC17126@redhat.com>
 <50F07E2D.6010602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F07E2D.6010602@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 01:03:41PM -0800, H. Peter Anvin wrote:
> On 01/11/2013 12:52 PM, Vivek Goyal wrote:
> > 
> > Eric,
> > 
> > In a private conversation, David Howells suggested why not pass kernel
> > signature in a segment to kernel and kernel can do the verification.
> > 
> > /sbin/kexec signature is verified by kernel at exec() time. Then
> > /sbin/kexec just passes one signature segment (after regular segment) for
> > each segment being loaded. The segments which don't have signature,
> > are passed with section size 0. And signature passing behavior can be
> > controlled by one new kexec flag.
> > 
> > That way /sbin/kexec does not have to worry about doing any verification
> > by itself. In fact, I am not sure how it can do the verification when
> > crypto libraries it will need are not signed (assuming they are not
> > statically linked in).
> > 
> > What do you think about this idea?
> > 
> 
> A signed /sbin/kexec would realistically have to be statically linked,
> at least in the short term; otherwise the libraries and ld.so would need
> verification as well.

Yes. That's the expectation. Sign only statically linked exeutables which
don't do any of dlopen() stuff either.

In fact in the patch, I fail the exec() if signed executable has
interpreter.

Thanks
Vivek
