Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3DSElD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 00:41:03 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61219 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3DSElA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 00:41:00 -0400
Date: Fri, 19 Apr 2013 12:40:46 +0800
From: Wang YanQing <udknight@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH]drivers:acpi: Fix wrong parameter passed to
 memblock_reserve
Message-ID: <20130419044046.GA9028@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Yinghai Lu <yinghai@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Thomas Renninger <trenn@suse.de>
References: <20130416014411.GA14671@udknight>
 <CAE9FiQUtvgB6zO9uqDQeC8K1kdH5uCwXkagAYUEEoF+Z+QHTdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUtvgB6zO9uqDQeC8K1kdH5uCwXkagAYUEEoF+Z+QHTdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 07:47:38PM -0700, Yinghai Lu wrote:
> On Mon, Apr 15, 2013 at 6:44 PM, Wang YanQing <udknight@gmail.com> wrote:
> >
> > The parameter of memblock_reserve is start address,
> > and size, not address range.
> >
> > Signed-off-by: Wang YanQing <udknight@gmail.com>
> > ---
> >  drivers/acpi/osl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index 586e7e9..bcb7a3b 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -641,7 +641,7 @@ void __init acpi_initrd_override(void *data, size_t size)
> >          * Both memblock_reserve and e820_add_region (via arch_reserve_mem_area)
> >          * works fine.
> >          */
> > -       memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
> > +       memblock_reserve(acpi_tables_addr, all_tables_size);
> >         arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> 
> And it should go to stable for v3.8

Hi all, I think this fix should be merged before 3.9 is out,
it make no much sense to backport it for 3.9 later, but we don't have 
much time before 3.9 is out, so...

Thanks.
