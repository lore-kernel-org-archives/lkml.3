Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaEAS7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:59:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39214 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbaEAS7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:59:49 -0400
Message-ID: <5362998D.3030102@zytor.com>
Date: Thu, 01 May 2014 11:59:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Florian Weimer <fweimer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <kees@outflux.net>, kvm list <kvm@vger.kernel.org>
Subject: random: Providing a seed value to VM guests
References: <20140428195913.E0A0143994596@oldenburg.str.redhat.com> <20140428214112.GC7857@thunk.org> <535FE68C.8060002@redhat.com> <20140429182610.GA19325@thunk.org> <53616293.3080308@mit.edu> <20140501020627.GA25248@thunk.org> <1be5350d-89f9-44b9-8d1b-e3e591741940@email.android.com> <20140501150549.GA24388@thunk.org> <CALCETrUQRqKEbWps5Nxqk57vCYmuvcA6pYAL7OiqJy8sE8yh=g@mail.gmail.com> <CALCETrWwcuq_-Q+i1g9hspsddGUmx8_yf3EaOLjgPcF5+yBnYA@mail.gmail.com>
In-Reply-To: <CALCETrWwcuq_-Q+i1g9hspsddGUmx8_yf3EaOLjgPcF5+yBnYA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 11:53 AM, Andy Lutomirski wrote:
> 
> A CPUID leaf or an MSR advertised by a CPUID leaf has another
> advantage: it's easy to use in the ASLR code -- I don't think there's
> a real IDT, so there's nothing like rdmsr_safe available.  It also
> avoids doing anything complicated with the boot process to allow the
> same seed to be used for ASLR and random.c; it can just be invoked
> twice on boot.
> 

At that point we are talking an x86-specific interface, and so we might
as well simply emulate RDRAND (urandom) and RDSEED (random) if the CPU
doesn't support them.  I believe KVM already has a way to report CPUID
features that are "emulated but supported anyway", i.e. they work but
are slow.

> What's the right forum for this?  This thread is probably not it.

Change the subject line?

	-hpa


