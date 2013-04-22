Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3DVXXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:23:03 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41024 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab3DVXXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:23:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wang YanQing <udknight@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH]drivers:acpi: Fix wrong parameter passed to memblock_reserve
Date: Tue, 23 Apr 2013 01:31:04 +0200
Message-ID: <97631249.RDz9BWEgHg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130419044046.GA9028@udknight>
References: <20130416014411.GA14671@udknight> <CAE9FiQUtvgB6zO9uqDQeC8K1kdH5uCwXkagAYUEEoF+Z+QHTdw@mail.gmail.com> <20130419044046.GA9028@udknight>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 19, 2013 12:40:46 PM Wang YanQing wrote:
> On Mon, Apr 15, 2013 at 07:47:38PM -0700, Yinghai Lu wrote:
> > On Mon, Apr 15, 2013 at 6:44 PM, Wang YanQing <udknight@gmail.com> wrote:
> > >
> > > The parameter of memblock_reserve is start address,
> > > and size, not address range.
> > >
> > > Signed-off-by: Wang YanQing <udknight@gmail.com>
> > > ---
> > >  drivers/acpi/osl.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > > index 586e7e9..bcb7a3b 100644
> > > --- a/drivers/acpi/osl.c
> > > +++ b/drivers/acpi/osl.c
> > > @@ -641,7 +641,7 @@ void __init acpi_initrd_override(void *data, size_t size)
> > >          * Both memblock_reserve and e820_add_region (via arch_reserve_mem_area)
> > >          * works fine.
> > >          */
> > > -       memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
> > > +       memblock_reserve(acpi_tables_addr, all_tables_size);
> > >         arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
> > 
> > Acked-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > And it should go to stable for v3.8
> 
> Hi all, I think this fix should be merged before 3.9 is out,
> it make no much sense to backport it for 3.9 later, but we don't have 
> much time before 3.9 is out, so...
> 
> Thanks.

Applied, but please send ACPI patches (and especially urgent fixes) to
linux-acpi@vger.kernel.org in the future.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
