Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaDAQI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:08:27 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:52330 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaDAQIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:08:25 -0400
Date: Tue, 1 Apr 2014 19:07:38 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Yury Gribov <y.gribov@samsung.com>,
        Alexandr Andreev <aandreev@parallels.com>,
        Vassili Karpov <av1474@comtv.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH RFC] drivers/char/mem: byte generating devices and
 poisoned mappings
Message-ID: <20140401160738.GA15175@node.dhcp.inet.fi>
References: <20140331211607.26784.43976.stgit@zurg>
 <20140401103617.GA10882@node.dhcp.inet.fi>
 <CALYGNiPvZSg7_b47+TbjhTzt0vBSRiXN8edVH=9A3YJOMQMqjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiPvZSg7_b47+TbjhTzt0vBSRiXN8edVH=9A3YJOMQMqjA@mail.gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 07:15:31PM +0400, Konstantin Khlebnikov wrote:
> On Tue, Apr 1, 2014 at 2:36 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> > On Tue, Apr 01, 2014 at 01:16:07AM +0400, Konstantin Khlebnikov wrote:
> >> This patch adds 256 virtual character devices: /dev/byte0, ..., /dev/byte255.
> >> Each works like /dev/zero but generates memory filled with particular byte.
> >
> > Shouldn't /dev/byte0 be an alias for /dev/zero?
> > I see you reuse ZERO_PAGE(0) for that, but what about all these special
> > cases /dev/zero has?
> 
> What special cases? I found rss-accounting part, you've mentioned coredump.

I'm not sure what else is there. It's probably good idea to check all
users of vm_normal_page().

One thing is zero page coloring which some archs have.

-- 
 Kirill A. Shutemov
