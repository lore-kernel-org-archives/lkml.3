Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935564Ab3DISxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:53:06 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41603 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab3DISxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:53:03 -0400
MIME-Version: 1.0
In-Reply-To: <51646302.2030608@zytor.com>
References: <20130408224328.GA17641@www.outflux.net>
	<51634935.9010905@zytor.com>
	<alpine.LFD.2.02.1304091122490.21884@ionos>
	<CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com>
	<51645D6F.7070705@zytor.com>
	<CAGXu5jKkHKw8efdPOmt-Zi99m+uMKVGKpc_DC72_ztwxnRbRRQ@mail.gmail.com>
	<51646054.3090509@zytor.com>
	<CAGXu5jJNG4o+_-kk=A2AfSRwyQE0pgaQh7YpSjnD_fB-s7U+wA@mail.gmail.com>
	<51646302.2030608@zytor.com>
Date: Tue, 9 Apr 2013 11:53:02 -0700
X-Google-Sender-Auth: WRaRLk-kMvJXhf082CuJ2li06cM
Message-ID: <CAGXu5j+_sSVsB-D+zYyzBkj0HKzyVfJOBRAxMRmge2t=sSrTAg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Eric Northup <digitaleric@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 11:50 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/09/2013 11:46 AM, Kees Cook wrote:
>>
>> Ah-ha! Yes, I see now when comparing the debug/kernel_page_tables
>> reports. It's just the High Kernel Mapping that we care about.
>> Addresses outside that range are less of a leak. Excellent, then GDT
>> may not be a problem. Whew.
>>
>
> It does beg the question if we need to randomize kmalloc... which could
> have issues by itself.

Agreed, but this should be a separate issue. As is the fact that GDT
is writable and a discoverable target.

-Kees

--
Kees Cook
Chrome OS Security
