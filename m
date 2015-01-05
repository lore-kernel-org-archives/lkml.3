Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbbAEQVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:21:50 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:46075 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAEQVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:21:49 -0500
Date: Mon, 5 Jan 2015 11:21:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v1] libata: export ata_get_cmd_descript()
Message-ID: <20150105162145.GO15833@htj.dyndns.org>
References: <1418397391-13668-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <548B2524.9050806@cogentembedded.com>
 <1418405747.17201.64.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418405747.17201.64.camel@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 07:35:47PM +0200, Andy Shevchenko wrote:
> On Fri, 2014-12-12 at 20:25 +0300, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 12/12/2014 06:16 PM, Andy Shevchenko wrote:
> > 
> > > The driver sata_dwc_460ex is using this symbol. To build it as a module we have
> > > to have the symbol exported. This patch adds EXPORT_SYMBOL() macro for that.
> > 
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > ---
> > >   drivers/ata/libata-eh.c | 1 +
> > >   1 file changed, 1 insertion(+)
> > 
> > > diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> > > index 3dbec89..74fef87 100644
> > > --- a/drivers/ata/libata-eh.c
> > > +++ b/drivers/ata/libata-eh.c
> > > @@ -2389,6 +2389,7 @@ const char *ata_get_cmd_descript(u8 command)
> > >
> > >   	return NULL;
> > >   }
> > > +EXPORT_SYMBOL(ata_get_cmd_descript);
> > 
> >     Why not EXPORT_SYMBOL_GPL()?
> 
> Some of the symbols are exported in that way. I think better to wait the
> maintainer to tell which is preferred there.

I don't really care.  As the sole user is an in-kernel module, I'm
gonna append _GPL for now.

Thanks.

-- 
tejun
