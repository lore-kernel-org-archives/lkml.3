Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab3LKLnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:43:45 -0500
Received: from multi.imgtec.com ([194.200.65.239]:21868 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3LKLnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:43:42 -0500
From: Qais Yousef <Qais.Yousef@imgtec.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] crash_dump: fix compilation error (on MIPS at least)
Thread-Topic: [PATCH] crash_dump: fix compilation error (on MIPS at least)
Thread-Index: AQHO8QnExmvHISq+vkaNQVlz0RPH3ppFohqAgAlF3UA=
Date: Wed, 11 Dec 2013 11:43:32 +0000
Message-ID: <392C4BDEFF12D14FA57A3F30B283D7D13C7764@LEMAIL01.le.imgtec.org>
References: <1386172702-31266-1-git-send-email-qais.yousef@imgtec.com>
 <20131205135835.GA1600@redhat.com>
In-Reply-To: <20131205135835.GA1600@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.154.35]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-SEF-Processed: 7_3_0_01192__2013_12_11_11_43_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBBBhpUj024552

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@redhat.com]
> Sent: 05 December 2013 13:59
> To: Qais Yousef
> Cc: linux-kernel@vger.kernel.org; Andrew Morton; Michael Holzheu; linux-
> mips@linux-mips.org; stable@vger.kernel.org
> Subject: Re: [PATCH] crash_dump: fix compilation error (on MIPS at least)
> 
> On Wed, Dec 04, 2013 at 03:58:22PM +0000, Qais Yousef wrote:
> >   In file included from kernel/crash_dump.c:2:0:
> >   include/linux/crash_dump.h:22:27: error: unknown type name â€˜pgprot_tâ€™
> >
> > when CONFIG_CRASH_DUMP=y
> >
> > The error was traced back to this commit:
> >
> >   9cb218131de1 vmcore: introduce remap_oldmem_pfn_range()
> >
> > include <asm/pgtable.h> to get the missing definition
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > Cc: Vivek Goyal <vgoyal@redhat.com>
> > Cc: <linux-mips@linux-mips.org>
> > Cc: <stable@vger.kernel.org> # 3.12
> > Reviewed-by: James Hogan <james.hogan@imgtec.com>
> > Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> > ---
> 
> Looks good to me.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Vivek

Hi,

I failed to see this picked up by anyone. I'm not sure which tree it should go to to be honest. Do I need to add more people to the Cc? Or am I just being impatient? :)

Thanks,
Qais

> 
> > I haven't tried any other architecture except mips.
> > If OK this should be considered for stable 3.12 (CCed).
> >
> >  include/linux/crash_dump.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
> > index fe68a5a..7032518 100644
> > --- a/include/linux/crash_dump.h
> > +++ b/include/linux/crash_dump.h
> > @@ -6,6 +6,8 @@
> >  #include <linux/proc_fs.h>
> >  #include <linux/elf.h>
> >
> > +#include <asm/pgtable.h> /* for pgprot_t */
> > +
> >  #define ELFCORE_ADDR_MAX	(-1ULL)
> >  #define ELFCORE_ADDR_ERR	(-2ULL)
> >
> > --
> > 1.7.1
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
