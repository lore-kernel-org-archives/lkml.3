Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbbAERoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:44:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:14023 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbbAERow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:44:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,701,1413270000"; 
   d="scan'208";a="664699080"
Message-ID: <1420479885.12456.21.camel@linux.intel.com>
Subject: Re: [PATCH v1] libata: export ata_get_cmd_descript()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Mon, 05 Jan 2015 19:44:45 +0200
In-Reply-To: <20150105162145.GO15833@htj.dyndns.org>
References: <1418397391-13668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <548B2524.9050806@cogentembedded.com>
	 <1418405747.17201.64.camel@linux.intel.com>
	 <20150105162145.GO15833@htj.dyndns.org>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 11:21 -0500, Tejun Heo wrote:
> On Fri, Dec 12, 2014 at 07:35:47PM +0200, Andy Shevchenko wrote:
> > On Fri, 2014-12-12 at 20:25 +0300, Sergei Shtylyov wrote:
> > > Hello.
> > > 
> > > On 12/12/2014 06:16 PM, Andy Shevchenko wrote:
> > > 
> > > > The driver sata_dwc_460ex is using this symbol. To build it as a module we have
> > > > to have the symbol exported. This patch adds EXPORT_SYMBOL() macro for that.
> > > 
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > ---
> > > >   drivers/ata/libata-eh.c | 1 +
> > > >   1 file changed, 1 insertion(+)
> > > 
> > > > diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> > > > index 3dbec89..74fef87 100644
> > > > --- a/drivers/ata/libata-eh.c
> > > > +++ b/drivers/ata/libata-eh.c
> > > > @@ -2389,6 +2389,7 @@ const char *ata_get_cmd_descript(u8 command)
> > > >
> > > >   	return NULL;
> > > >   }
> > > > +EXPORT_SYMBOL(ata_get_cmd_descript);
> > > 
> > >     Why not EXPORT_SYMBOL_GPL()?
> > 
> > Some of the symbols are exported in that way. I think better to wait the
> > maintainer to tell which is preferred there.
> 
> I don't really care.  As the sole user is an in-kernel module, I'm
> gonna append _GPL for now.
> 

I'm okay with GPL. Thanks!


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

