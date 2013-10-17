Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3JQK1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:27:46 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:59198 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3JQK1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:27:44 -0400
X-AuditID: cbfec373-b7f6d6d00000330d-44-525fbb9f378d
Date: Thu, 17 Oct 2013 07:27:38 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        joe@perches.com, naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/9] ACPI, APEI,
 CPER: Cleanup CPER memory error output format
Message-id: <20131017072738.24ea5c05@samsung.com>
In-reply-to: <20131016172410.GM13608@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-9-git-send-email-gong.chen@linux.intel.com>
 <20131016172410.GM13608@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/hYN35u+ODDBbuNbZoO/GbzeLzhn9s
	Frfe2VrMvv+YxWL5vn5Gi8u75rBZ3G95ym7x5sI9FgcOj++tfSwei/e8ZPKYdzLQ48GhzSwe
	X1ZdY/Z4v+8qm8fnTXIB7FFcNimpOZllqUX6dglcGX0/d7EWLOKuePyri6mB8RVHFyMnh4SA
	icTmOf2sELaYxIV769m6GLk4hASWMEr8XDCfGcLpYZL4sPkJWBWLgKrE8+ZNYDabgJHEq8YW
	MFtEQEni66K5TCANzALHGCUedB4A6ubgEBYIl3iwrRjE5BUwlOhrEgAxOQV0JR6/jIcYv4ZR
	Yt7idkaQuISAk8TWqb4gE3kFBCV+TL7HAmIzC2hJbN7WxAphy0tsXvOWeQKjwCwkZbOQlM1C
	UraAkXkVo2hpcXJBcVJ6rpFecWJucWleul5yfu4mRkjwF+9gfLHB6hCjAAejEg/vjOVxQUKs
	iWXFlbmHGCU4mJVEeLdsjw8S4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLj8vNLUha/LnEXbmG4d
	b7yaNVNgq2zsT5EDZwx0F5dV/SlzOuD00cDss9cp+Ycm97bEX6xX37ZL0fjC3dkXtVW+nL+Q
	8kGYW0ep6NVn/l5l80+PK5aJVt5tu5f3aG02V+OuT/Ntjl4zXXz417+2DctsDh8SeC4z79XV
	8Jw/Dy9ohk9pfrZC/pSiEktxRqKhFnNRcSIAYWOxS1wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Oct 2013 19:24:10 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Wed, Oct 16, 2013 at 10:56:05AM -0400, Chen, Gong wrote:
> > Keep up only the most important fields for memory error
> > reporting. The detail information will be moved to perf/trace
> > interface.
> > 
> > Suggested-by: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>

Considering the suggested fixes below:

Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> > ---
> >  drivers/acpi/apei/cper.c | 69 +++++++++++++++++++++++-------------------------
> >  1 file changed, 33 insertions(+), 36 deletions(-)
> > 
> > diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> > index b1a8a55..f5bc227 100644
> > --- a/drivers/acpi/apei/cper.c
> > +++ b/drivers/acpi/apei/cper.c
> > @@ -33,6 +33,9 @@
> >  #include <linux/pci.h>
> >  #include <linux/aer.h>
> >  
> > +#define INDENT_SP	" "
> > +#define HW_CE_INFO \
> > +	"Above error has been corrected by h/w and no further action required"
> 
> Leftover?
> 
> 
> > +	if (severity != CPER_SEV_FATAL)
> > +		printk("%s%s\n", pfx,
> > +		       "Above error has been corrected by h/w "
> > +		       "and require no further action");
> 
> Let's write it out and correct grammar:
> 
> "Above error has been corrected by the hardware and requires no further action."
> 
> Thanks.
> 


-- 

Cheers,
Mauro
