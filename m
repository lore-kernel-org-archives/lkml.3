Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936127Ab3DHWvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:51:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42127 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762821Ab3DHWvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:51:06 -0400
Message-ID: <51634935.9010905@zytor.com>
Date: Mon, 08 Apr 2013 15:48:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        kernel-hardening@lists.openwall.com,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Eric Northup <digitaleric@google.com>
Subject: Re: [PATCH] x86: make IDT read-only
References: <20130408224328.GA17641@www.outflux.net>
In-Reply-To: <20130408224328.GA17641@www.outflux.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 03:43 PM, Kees Cook wrote:
> This makes the IDT unconditionally read-only. This primarily removes
> the IDT from being a target for arbitrary memory write attacks. It has
> an added benefit of also not leaking (via the "sidt" instruction) the
> kernel base offset, if it has been relocated.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Eric Northup <digitaleric@google.com>

Also, tglx: does this interfere with your per-cpu IDT efforts?

	-hpa


