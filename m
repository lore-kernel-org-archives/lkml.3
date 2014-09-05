Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaIELWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:22:51 -0400
Received: from hgpmta01.sony.com.cn ([114.141.162.246]:41333 "EHLO
	hgpmta01.sony.com.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaIELWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:22:50 -0400
From: "Su, Friendy" <Friendy.Su@sony.com.cn>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Sep 2014 19:17:18 +0800
Subject: RE: [PATCH v1 1/1] iommu/amd: set iommu for early mapped ioapic/hpet
Thread-Topic: [PATCH v1 1/1] iommu/amd: set iommu for early mapped
 ioapic/hpet
Thread-Index: Ac/HiJONGrpZ4afmSve5IDr1nQgYWwBcgj7A
Message-ID: <053191AD6E9023439BF3970DE870051856D1F164AF@APSHAXMS02.ap.sony.com>
References: <053191AD6E9023439BF3970DE870051856D1EF3AC4@APSHAXMS02.ap.sony.com>
 <20140903150538.GJ28786@8bytes.org>
In-Reply-To: <20140903150538.GJ28786@8bytes.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Joerg,

> -----Original Message-----
> From: joro@8bytes.org [mailto:joro@8bytes.org]
> Sent: Wednesday, September 03, 2014 11:06 PM
> To: Su, Friendy
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v1 1/1] iommu/amd: set iommu for early mapped
> ioapic/hpet
> 
> On Mon, Sep 01, 2014 at 02:17:44PM +0800, Su, Friendy wrote:
> > diff --git a/drivers/iommu/amd_iommu_init.c
> b/drivers/iommu/amd_iommu_init.c
> > index 3783e0b..148ab61 100644
> > --- a/drivers/iommu/amd_iommu_init.c
> > +++ b/drivers/iommu/amd_iommu_init.c
> > @@ -747,7 +747,7 @@ static int __init add_special_device(u8 type, u8 id,
> u16 devid, bool cmd_line)
> >  	return 0;
> >  }
> >
> > -static int __init add_early_maps(void)
> > +static int __init add_early_maps(struct amd_iommu *iommu)
> >  {
> >  	int i, ret;
> >
> > @@ -758,6 +758,11 @@ static int __init add_early_maps(void)
> >  					 early_ioapic_map[i].cmd_line);
> >  		if (ret)
> >  			return ret;
> > +		/*
> > +		 * early mapped ioapci overrides ACPI IVRS,
> > +		 * they should be always controlled by iommu.
> > +		 */
> > +		set_iommu_for_device(iommu, early_ioapic_map[i].devid);
> >  	}
> >
> >  	for (i = 0; i < early_hpet_map_size; ++i) {
> > @@ -767,6 +772,11 @@ static int __init add_early_maps(void)
> >  					 early_hpet_map[i].cmd_line);
> >  		if (ret)
> >  			return ret;
> > +		/*
> > +		 * early mapped hpet overrides ACPI IVRS,
> > +		 * they should be always controlled by iommu.
> > +		 */
> > +		set_iommu_for_device(iommu, early_hpet_map[i].devid);
> 
> This doesn't work on machines with multiple IOMMUs in it. Also the
> problem only exists if there is no IVHD entry in the IVRS table for the
> device containing IOAPIC and HPET.
> 
> But if this IVHD entry is not present we can't reliably know which IOMMU
> is responsible for a given IOAPIC/HPET.
> 
> 
> 	Joerg
> 
Thanks. You are correct, we should handle early mapped inside IOMMU whose IVHD reports the same ID. I will update.

Friendy
