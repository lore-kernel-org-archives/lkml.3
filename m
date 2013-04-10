Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3DJSdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:33:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33681 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab3DJSdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:33:09 -0400
Message-ID: <5165AF30.909@zytor.com>
Date: Wed, 10 Apr 2013 11:28:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Alexander Duyck <alexander.h.duyck@intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Alex Shi <alex.shi@intel.com>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Julien Tinnes <jln@google.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Readonly GDT
References: <20130408224328.GA17641@www.outflux.net> <51634935.9010905@zytor.com> <alpine.LFD.2.02.1304091122490.21884@ionos> <CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com> <51645D6F.7070705@zytor.com> <CAGXu5jKkHKw8efdPOmt-Zi99m+uMKVGKpc_DC72_ztwxnRbRRQ@mail.gmail.com> <51646054.3090509@zytor.com> <CAGXu5jJNG4o+_-kk=A2AfSRwyQE0pgaQh7YpSjnD_fB-s7U+wA@mail.gmail.com> <CAG7+5M3==rndLLak9cZBKKdgQMmJMpSP_jpQd8HOVGp6LhUAgw@mail.gmail.com> <5164B5BD.5050702@zytor.com> <5165502902000078000CC022@nat28.tlf.novell.com>
In-Reply-To: <5165502902000078000CC022@nat28.tlf.novell.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 02:42 AM, Jan Beulich wrote:
> 
>> However, the packing solution has the advantage of reducing address
>> space consumption which matters on 32 bits: even on i386 we can easily
>> burn a megabyte of address space for 4096 processors, but burning 16
>> megabytes starts to hurt.
> 
> Packing would have the additional benefit of Xen not needing to
> become a special case in yet another area (because pages
> containing live descriptor table entries need to be read-only for
> PV guests, and need to consist of only descriptor table entries).
> 

OK, so on 64 bits this sounds like a win all around, whereas it is not
feasible on 32 bits (which means we don't really need to worry about
burning address space.)

So, anyone interested in implementing this for 64 bits?

	-hpa


