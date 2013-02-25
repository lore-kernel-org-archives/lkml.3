Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab3BYBet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 20:34:49 -0500
Received: from prdiron-2.llnl.gov ([128.15.143.172]:43901 "EHLO
	prdiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759514Ab3BYBes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 20:34:48 -0500
X-Attachments: 
Date: Sun, 24 Feb 2013 17:34:47 -0800
From: Ira Weiny <weiny2@llnl.gov>
To: "Husam Kahalah" <HKahalah@asaltech.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infiniband-diags/saquery.c: switchinfo support added
Message-Id: <20130224173447.08f0201f24e97ea4c62a5a60@llnl.gov>
In-Reply-To: <WC20130224082247.780048@asaltech.com>
References: <WC20130221094946.530170@asaltech.com>
	<20130221100900.87b509d834fc0adc21b6f68b@llnl.gov>
	<20130221103344.57aeda4abc1ac4915a6a0a06@llnl.gov>
	<WC20130224082247.780048@asaltech.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013 10:22:47 +0200
"Husam Kahalah" <HKahalah@asaltech.com> wrote:

> Thank you for your time, I have the following notes:
> I plan to add support for more records other than switchInfoRecord like 
> smInfo, multipath, nodeInfo

That would be great!

> I plan also to add component filter to those records attributes in the same 
> way that pathInfo and MCR were implemented, this is the reason why I started 
> adding attributes to query_params structure 
> I'am not talking about RID(record identifier) attributes only, but also 
> about other attributes that may differ between records.
> If it is available to add to query_params structure in that way let me know 
> , otherwise I will add just RID attributes in the suggested way.
> 

I am not against adding fields to query_params.  However, we have a standard way to specify the RID components like LID which should be followed.

If you need new components to be specified for new attributes it is fine to add them to query_params.  That said, any components which already have options should be overloaded; for example MultiPathRecord.SL should use the --sl option.

Does this make sense?

Thanks,
Ira

> 
> -----Original Message-----
> From: Ira Weiny <weiny2@llnl.gov>
> To: Ira Weiny <weiny2@llnl.gov>
> Cc: "Husam Kahalah" <HKahalah@asaltech.com>, linux-rdma@vger.kernel.org, 
> linux-kernel@vger.kernel.org
> Date: Thu, 21 Feb 2013 10:33:44 -0800
> Subject: Re: [PATCH] infiniband-diags/saquery.c: switchinfo support added
> 
> On Thu, 21 Feb 2013 10:09:00 -0800
> Ira Weiny <weiny2@llnl.gov> wrote:
> 
> [snip]
> 
> > > + ib_net16_t swir_lid;
> >
> > We don't need this field or lid option.  Other records simply have an 
> optional parameter to specify the lid.
> >
> > The usage should be:
> >
> > SwitchRecord [lid]
> >
> 
> Sorry I meant "SwitchInfoRecord" or SWIR.
> 
> Ira
> 
> [snip]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2@llnl.gov
