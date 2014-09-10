Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaIJUWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:22:51 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:19967 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaIJUWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:22:47 -0400
Message-ID: <1410379933.28990.287.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 6/6] x86, pat: Update documentation for WT changes
From: Toshi Kani <toshi.kani@hp.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 10 Sep 2014 14:12:13 -0600
In-Reply-To: <CALCETrVnHg0X=R23qyiPtxYs3knHaXq65L0Jw_1oY4=gX5kpXQ@mail.gmail.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
	 <1410367910-6026-7-git-send-email-toshi.kani@hp.com>
	 <CALCETrVnHg0X=R23qyiPtxYs3knHaXq65L0Jw_1oY4=gX5kpXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 11:30 -0700, Andy Lutomirski wrote:
> On Wed, Sep 10, 2014 at 9:51 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > +Drivers may map the entire NV-DIMM range with ioremap_cache and then change
> > +a specific range to wt with set_memory_wt.
> 
> That's mighty specific :)

How about below?

Drivers may use set_memory_wt to set WT type for cached reserve ranges.

> It's also not all that informative.  Are you supposed to set the
> memory back before iounmapping?  

Setting back to WB before iounmap is not required, but set_memory_wb is
used when it wants to put it back to WB before unmapping.

> Can you do this with set_memory_wc on
> an uncached mapping?

The table lists interfaces and their intended usage.  Using
set_memory_wc on an uncached mapping probably works, but is not an
intended use.

Thanks,
-Toshi

