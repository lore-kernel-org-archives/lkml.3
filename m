Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbaGPAGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:06:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32818 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbaGPAGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:06:05 -0400
Message-ID: <53C5C1C9.6070100@zytor.com>
Date: Tue, 15 Jul 2014 17:05:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>, Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH 3/11] x86, mm, pat: Change reserve_memtype() to handle
 WT type
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>	 <1405452884-25688-4-git-send-email-toshi.kani@hp.com>	 <CALCETrUPpP1Lo1gB_eTm6V3pJ3Fam-1gPZGKfksOXXGgtNGsEQ@mail.gmail.com>	 <1405465801.28702.34.camel@misato.fc.hp.com>	 <CALCETrUx+HkzBmTZo-BtOcOz7rs=oNcavJ9Go536Fcn2ugdobg@mail.gmail.com> <1405468387.28702.53.camel@misato.fc.hp.com>
In-Reply-To: <1405468387.28702.53.camel@misato.fc.hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 04:53 PM, Toshi Kani wrote:
> 
> Right.
> 
> I think using struct page table for the RAM ranges is a good way for
> saving memory, but I wonder how often the RAM ranges are mapped other
> than WB...  If not often, reserve_memtype() could simply call
> rbt_memtype_check_insert() for all ranges, including RAM.
> 
> In this patch, I left using reserve_ram_pages_type() since I do not see
> much reason to use WT for RAM, either.
> 

They get flipped to WC or WT or even UC for some I/O devices, but
ultimately the number of ranges is pretty small.

	-hpa


