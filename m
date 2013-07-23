Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3GWNAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:00:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65491 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3GWNAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:00:20 -0400
X-AuditID: cbfee691-b7fef6d000002d62-27-51ee7e4dc095
From: Inki Dae <inki.dae@samsung.com>
To: "'Antonios Motakis'" <a.motakis@virtualopensystems.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'kvm-arm'" <kvmarm@lists.cs.columbia.edu>,
        "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Jiri Kosina'" <jkosina@suse.cz>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Alex Williamson'" <alex.williamson@redhat.com>
References: <1374573694-30595-1-git-send-email-a.motakis@virtualopensystems.com>
 <00d701ce878f$da099fe0$8e1cdfa0$%dae@samsung.com>
 <CAG8rG2wNG9wVjKxtaDzLRybvh3wPVR08j9G9OPcK=a2Gwbtg-g@mail.gmail.com>
 <00e601ce8796$bdca50c0$395ef240$%dae@samsung.com>
 <CAG8rG2xJ4z9cwrMtLhOrPKnw+fdL_H4doDPARNfvLj+JHTjByQ@mail.gmail.com>
In-reply-to: <CAG8rG2xJ4z9cwrMtLhOrPKnw+fdL_H4doDPARNfvLj+JHTjByQ@mail.gmail.com>
Subject: RE: [PATCH] iommu/exynos: add devices attached to the System MMU to an
 IOMMU group
Date: Tue, 23 Jul 2013 21:59:54 +0900
Message-id: <00ef01ce87a4$870d86c0$95289440$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6HnNnbwz+bkpqRRsOqDnx82cDG2AABdaMA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsWyRsSkSNe37l2gwbkpRhZ37p5jtfj2v4fN
	YsF+a4vdcxazWHTO3sBu8fHUcXaLTY+vsVpc3jWHzWLG+X1MFv96DzJanPzTy2ixc10nuwOP
	x5OD85g87lzbw+ZxftMaZo/NS+o9Jt9Yzujxft9VNo++LasYPc4sOMLusfTeUUaPz5vkPK4c
	PcMUwB3FZZOSmpNZllqkb5fAldF0ZBlrQbttxfKVu5gbGFv0uxg5OSQETCTunbvCCmGLSVy4
	t56ti5GLQ0hgKaPElM7XTDBF/7oeskAkpjNKfL3ZDdYhJPCbUWJftzaIzSagKjFxxX02EFtE
	wFJi46IfYA3MAk0sErtubmSG6D7BJPH950J2kCpOgWCJYz/fgHUIC8RKdC2+BGazAE2atHoN
	YxcjBwevgK3EzJeBIGFeAUGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxSLiGgLvHory7EDUYS
	R7cvhCoRkdj34h0jyAkSAgc4JNadWsYEsUpA4tvkQywQvbISmw4wQzwsKXFwxQ2WCYwSs5Bs
	noVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRmCiOP3v2cQdjPcPWB9i
	TAZaP5FZSjQ5H5ho8kriDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXAGNSy/8HeiY3buS2+7nZSmieX52h28cOG0s3/33+WWmKmWHHbvVPT5VVoJ/uU
	aQ/2Hzp45IOZT7uhicrxH2K5zCpvuDw1XhRUPD73dvY2vgOMO6UjarJXsz16pmLu+tCohEUn
	9JrY/Mz9yq1terPvJAX5cjpo/FHo86m0CMpSLkyuuxxwdoG8EktxRqKhFnNRcSIAM67dYyoD	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsVy+t9jQV3funeBBv9/qFncuXuO1eLb/x42
	iwX7rS12z1nMYtE5ewO7xcdTx9ktNj2+xmpxedccNosZ5/cxWfzrPchocfJPL6PFznWd7A48
	Hk8OzmPyuHNtD5vH+U1rmD02L6n3mHxjOaPH+31X2Tz6tqxi9Diz4Ai7x9J7Rxk9Pm+S87hy
	9AxTAHdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMpiPLWAvabSuWr9zF
	3MDYot/FyMkhIWAi8a/rIQuELSZx4d56ti5GLg4hgemMEl9vdrOCJIQEfjNK7OvWBrHZBFQl
	Jq64zwZiiwhYSmxc9IMFpIFZoIlFYtfNjcwQ3SeYJL7/XMgOUsUpECxx7OcbsA5hgViJrsWX
	wGwWoEmTVq9h7GLk4OAVsJWY+TIQJMwrICjxY/I9sIuYBbQk1u88zgRhy0tsXvOWGaRcQkBd
	4tFfXYgbjCSObl8IVSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84
	Mbe4NC9dLzk/dxMjOA09k97BuKrB4hCjAAejEg+vh/fbQCHWxLLiytxDjBIczEoivEul3gUK
	8aYkVlalFuXHF5XmpBYfYkwG+nMis5Rocj4wReaVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQ
	SCA9sSQ1OzW1ILUIZgsTB6dUA+OUyM40oYKra3Q5JkS4+yn6/O/u5+JWFWutl76emWRkcOXj
	WfN12mfqX142K/WeMHM9a/fHn01T2IQfhVtFHFaW/nEub7H2L9a7m5NKHmw0TbdWf8C02vXq
	p7TaRWVNM9ilNz9YJLEq6Y3L+0gBo6urmu7GlLpP0VwwNclhrb4ih1VkqlFgjxJLcUaioRZz
	UXEiAFsv3ZeHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Antonios Motakis [mailto:a.motakis@virtualopensystems.com]
> Sent: Tuesday, July 23, 2013 9:05 PM
> To: Inki Dae
> Cc: Linux ARM Kernel; Linux IOMMU; Linux Samsung SOC; kvm-arm; Cho
KyongHo;
> Joerg Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list; Alex
> Williamson
> Subject: Re: [PATCH] iommu/exynos: add devices attached to the System MMU
> to an IOMMU group
> 
> On Tue, Jul 23, 2013 at 1:21 PM, Inki Dae <inki.dae@samsung.com> wrote:
> >
> >
> >> -----Original Message-----
> >> From: Antonios Motakis [mailto:a.motakis@virtualopensystems.com]
> >> Sent: Tuesday, July 23, 2013 8:00 PM
> >> To: Inki Dae
> >> Cc: Linux ARM Kernel; Linux IOMMU; Linux Samsung SOC; kvm-arm; Cho
> > KyongHo;
> >> Joerg Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list
> >> Subject: Re: [PATCH] iommu/exynos: add devices attached to the System
> MMU
> >> to an IOMMU group
> >>
> >> On Tue, Jul 23, 2013 at 12:31 PM, Inki Dae <inki.dae@samsung.com>
wrote:
> >> >
> >> >
> >> >
> >> > > -----Original Message-----
> >> > > From: linux-samsung-soc-owner@vger.kernel.org [mailto:linux-
> samsung-
> >> soc-
> >> > > owner@vger.kernel.org] On Behalf Of Antonios Motakis
> >> > > Sent: Tuesday, July 23, 2013 7:02 PM
> >> > > To: linux-arm-kernel@lists.infradead.org;
> >> > iommu@lists.linux-foundation.org;
> >> > > linux-samsung-soc@vger.kernel.org
> >> > > Cc: kvmarm@lists.cs.columbia.edu; Antonios Motakis; Cho KyongHo;
> Joerg
> >> > > Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list
> >> > > Subject: [PATCH] iommu/exynos: add devices attached to the System
> MMU
> >> to
> >> > > an IOMMU group
> >> > >
> >> > > IOMMU groups are expected by certain users of the IOMMU API,
> >> > > e.g. VFIO. Since each device is behind its own System MMU, we
> >> > > can allocate a new IOMMU group for each device.
> >> > >
> >> > > This patch depends on Cho KyongHo's patch series titled "[PATCH v7
> >> 00/12]
> >> > > iommu/exynos: Fixes and Enhancements of System MMU driver with DT",
> >> > > applied on a Linux 3.10.1 kernel. It has been tested on the Arndale
> >> board.
> >> > >
> >> > > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> >> > > ---
> >> > >  drivers/iommu/exynos-iommu.c | 24 ++++++++++++++++++++++++
> >> > >  1 file changed, 24 insertions(+)
> >> > >
> >> > > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-
> >> iommu.c
> >> > > index 51d43bb..9f39eaa 100644
> >> > > --- a/drivers/iommu/exynos-iommu.c
> >> > > +++ b/drivers/iommu/exynos-iommu.c
> >> > > @@ -1134,6 +1134,28 @@ static phys_addr_t
> >> exynos_iommu_iova_to_phys(struct
> >> > > iommu_domain *domain,
> >> > >       return phys;
> >> > >  }
> >> > >
> >> > > +static int exynos_iommu_add_device(struct device *dev)
> >> > > +{
> >> > > +     struct iommu_group *group;
> >> > > +     int ret;
> >> > > +
> >> > > +     group = iommu_group_alloc();
> >> >
> >> > Is that correct? I don't see why you allocate a group object every
> time
> >> > add_device callback is called. That doesn't have any meaning we have
> to
> >> use
> >> > iommu group feature. I think the implementation should be one more
> >> devices
> >> > per a group. So I guess a given device object should be wrapped by
> >> higher
> >> > device object than the given device object. For a good example, you
> can
> >> > refer to intel-iommu.c file.
> >>
> >> With an Intel IOMMU it can be the case that 2 devices have to share
> >> the same IOMMU mappings (i.e. you can't program them separately). With
> >> the Exynos System MMU, there is always one System MMU per device, so
> >> there is nothing stopping you from programming any 2 devices' mappings
> >> differently. So yes, the right thing to do here is to have a one to
> >> one relationship between devices and IOMMU groups.
> >
> > In case of Exynos drm driver, a unified iommu mapping table is used for
> all
> > devices (fimd, g2d, hdmi, fimc, gsc, rotator) based on drm so they use
> the
> > same iommu mapping table even though they have each iommu hardware unit.
> And
> > the iommu mapping table is just logical data structure for hardware
> > translation process by each DMA. Actually, I am considering using iommu
> > group feature for more generic implementation.
> 
> But is this grouping imposed by the hardware in some way, or is it
> just the way you handle them in software? In the latter case, then
> what you are looking for are IOMMU domains (which can contain multiple
> groups). IOMMU groups describe something that is imposed by the
> hardware.
> 

That's true. That seems like out of my intention that we try to use the
iommu group feature.

> >
> > And one question. Why do you allocate a iommu group object if we should
> have
> > one to one relationship between devices and iommu groups? In this case,
> is
> > there any reason you have to use the iommu group object?
> 
> Generic IOMMU code (such as VFIO) will check for IOMMU groups to
> determine how the devices behind an IOMMU relate to each other.
> Returning a unique IOMMU group object per device provides this
> information - that each device can also be programmed separately. VFIO
> relies on this behavior - if it doesn't find any IOMMU group objects
> it will refuse to use the device.
> 
> Additionally, this information can be seen by userspace. Being able to
> programmatically determine that there is a one to one relationship is
> certainly useful.
> 

I have read VFIO document file just now. The VFIO framework is similar to
UIO that is used to write user space device driver. But the VFIO is more
secure, and provides more featureful userspace driver environment than UIO.
And the VFIO requires iommu group object. I didn't check this. Sorry about
that.

Thanks,
Inki Dae

> I don't think the lack of IOMMU groups implies no grouping - I think
> it implies unknown grouping or an incomplete driver, so in my opinion
> VFIO is correct in refusing to work without IOMMU groups. So any
> future ARM support for VFIO, will also rely on IOMMU groups.
> 
> >
> > Thanks,
> > Inki Dae
> >
> >>
> >> (resending because of html mail)
> >>
> >> Cheers,
> >> Antonios
> >>
> >> >
> >> >
> >> > Thanks,
> >> > Inki Dae
> >> >
> >> > > +     if (IS_ERR(group)) {
> >> > > +             dev_err(dev, "Failed to allocate IOMMU group\n");
> >> > > +             return PTR_ERR(group);
> >> > > +     }
> >> > > +
> >> > > +     ret = iommu_group_add_device(group, dev);
> >> > > +     iommu_group_put(group);
> >> > > +
> >> > > +     return ret;
> >> > > +}
> >> > > +
> >> > > +static void exynos_iommu_remove_device(struct device *dev)
> >> > > +{
> >> > > +     iommu_group_remove_device(dev);
> >> > > +}
> >> > > +
> >> > >  static struct iommu_ops exynos_iommu_ops = {
> >> > >       .domain_init = &exynos_iommu_domain_init,
> >> > >       .domain_destroy = &exynos_iommu_domain_destroy,
> >> > > @@ -1142,6 +1164,8 @@ static struct iommu_ops exynos_iommu_ops = {
> >> > >       .map = &exynos_iommu_map,
> >> > >       .unmap = &exynos_iommu_unmap,
> >> > >       .iova_to_phys = &exynos_iommu_iova_to_phys,
> >> > > +     .add_device     = exynos_iommu_add_device,
> >> > > +     .remove_device  = exynos_iommu_remove_device,
> >> > >       .pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
> >> > >  };
> >> > >
> >> > > --
> >> > > 1.8.1.2
> >> > >
> >> > > --
> >> > > To unsubscribe from this list: send the line "unsubscribe linux-
> >> samsung-
> >> > > soc" in
> >> > > the body of a message to majordomo@vger.kernel.org
> >> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >
> >

