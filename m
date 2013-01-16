Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3APU0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 15:26:17 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33898 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab3APU0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 15:26:15 -0500
Message-ID: <1358367957.4593.198.camel@falcor1>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org,
        Ryan Ware <ryan.r.ware@intel.com>
Date: Wed, 16 Jan 2013 15:25:57 -0500
In-Reply-To: <20130116194759.GA4502@redhat.com>
References: <87wqvdli1o.fsf@xmission.com> <1358344859.4593.66.camel@falcor1>
	 <20130116144836.GB29845@redhat.com> <1358350391.4593.112.camel@falcor1>
	 <20130116155406.GC29845@redhat.com> <1358357079.4593.135.camel@falcor1>
	 <20130116182146.GE29845@redhat.com> <1358361912.4593.162.camel@falcor1>
	 <20130116185741.GA3038@redhat.com> <1358365044.4593.186.camel@falcor1>
	 <20130116194759.GA4502@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011620-9360-0000-0000-00000F4AF1D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 14:47 -0500, Vivek Goyal wrote:
> On Wed, Jan 16, 2013 at 02:37:24PM -0500, Mimi Zohar wrote:
> > On Wed, 2013-01-16 at 13:57 -0500, Vivek Goyal wrote:
> > > On Wed, Jan 16, 2013 at 01:45:12PM -0500, Mimi Zohar wrote:
> > > 
> > > [..]
> > > > > Given the fact that signatures are stored in extended attributes, to me
> > > > > the only way to sign executables in current IMA framework would to be
> > > > > prepare file system image at build server and ship that image. And
> > > > > then installer simply mounts that image (after making sure that proper
> > > > > verification keys have been loaded in kernel).
> > > > 
> > > > That is one scenario.  Another scenario is to update packages to include
> > > > extended attributes and to write those extended attributes on
> > > > installation.
> > > 
> > > Ok, that's the point I am missing. So I can sign a file and signatures
> > > are in a separate file. And these signatures are installed in extended
> > > attributes at file installation time (IOW rpm installation time) on
> > > target.
> > > 
> > > If all this works, this sounds reasonable so far. Except the point of
> > > disabling ptrace and locking down memory. 
> > > 
> > > So what's the state of above work. Is there something I can play with.
> > 
> > Sorry, I'm not sure of the RPM implementation details of where/how the
> > signatures are stored in the package, nor of the status of these
> > changes.  Perhaps someone else on the mailing list knows.
> 
> So irrespective of fact how RPM does it. What are basic commands/steps to
> generate signature of a file and how to store it later in an extended
> attribute?

evmctl calculates and writes out the 'security.evm' and 'security.ima'
extended attribute.  The ima-evm-utils package README contains some
directions for getting started.  We should probably move this thread to
the linux-ima-user mailing list.

thanks,

Mimi


