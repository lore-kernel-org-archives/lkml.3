Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaIJTPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:15:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56913 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaIJTPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:15:23 -0400
Message-ID: <5410A316.8090700@zytor.com>
Date: Wed, 10 Sep 2014 12:14:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Toshi Kani <toshi.kani@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 2/6] x86, mm, pat: Change reserve_memtype() to handle
 WT
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com> <1410367910-6026-3-git-send-email-toshi.kani@hp.com> <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com>
In-Reply-To: <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 11:26 AM, Andy Lutomirski wrote:
> On Wed, Sep 10, 2014 at 9:51 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>> This patch changes reserve_memtype() to handle the WT cache mode.
>> When PAT is not enabled, it continues to set UC- to *new_type for
>> any non-WB request.
>>
>> When a target range is RAM, reserve_ram_pages_type() fails for WT
>> for now.  This function may not reserve a RAM range for WT since
>> reserve_ram_pages_type() uses the page flags limited to three memory
>> types, WB, WC and UC.
> 
> Should it fail if WT is unavailable due to errata?  More generally,
> how are all of the do_something_wc / do_something_wt /
> do_something_nocache helpers supposed to handle unsupported types?
> 

Errata, or because it is pre-PAT hardware.  Keep in mind that even
pre-PAT hardware supports using page tables for cache types, it is only
that the only types supposed are WB, WT, UC.

	-hpa


