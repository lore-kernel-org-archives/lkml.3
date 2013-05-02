Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3EBC7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 22:59:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:46858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab3EBC7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 22:59:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,593,1363158000"; 
   d="scan'208";a="306560724"
Subject: Re: [PATCH v2 1/4] Wrap crc_t10dif function all to use crypto
 transform framework
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Erdinc Ozturk <erdinc.ozturk@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20130430032733.GB20471@gondor.apana.org.au>
References: <cover.1366214842.git.tim.c.chen@linux.intel.com>
	 <ea4271721b5ca130849b03da4f172f12f66e5628.1366214842.git.tim.c.chen@linux.intel.com>
	 <20130425132203.GA29501@gondor.apana.org.au>
	 <1366910910.27102.126.camel@schen9-DESK>
	 <20130426125224.GA4855@gondor.apana.org.au>
	 <1366994657.27102.129.camel@schen9-DESK>
	 <20130428001122.GA6973@gondor.apana.org.au>
	 <1367268030.27102.172.camel@schen9-DESK>
	 <20130430032733.GB20471@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 May 2013 19:59:34 -0700
Message-ID: <1367463574.27102.207.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 11:27 +0800, Herbert Xu wrote:
> On Mon, Apr 29, 2013 at 01:40:30PM -0700, Tim Chen wrote:
> >
> > If I allocate the transform under the mod init instead, how can I make
> > sure that the fast version is already registered if I have it compiled
> > in?  It is not clear to me how that's done looking at the libcrc32c
> > code.  
> 
> This is only an issue when everything is built-in to the kernel.
> 
> In that case we could make the crc implementations register at a
> point earlier than device_initcall, but no earlier than subsys_initcall
> since that's where cryptomgr sits.

I've spun version 3 of this patch series to address the concerns about
version 2.  The patches are sent separately.

Thanks.

Tim


