Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaCRLJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:09:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51510 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbaCRLJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:09:17 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-a4-5328295c08b9
Date: Tue, 18 Mar 2014 20:09:15 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
Message-id: <20140318200915.7dd833ce0fddbbd6ecd8dac9@samsung.com>
In-reply-to: <CAK9yfHw7zYaX9EYFE+m3Mh-u8Uiyubx-cS0EwPmfW+0weLiBKw@mail.gmail.com>
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
 <CAK9yfHw7zYaX9EYFE+m3Mh-u8Uiyubx-cS0EwPmfW+0weLiBKw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zQ90YTY1gg3sL5S3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MrouxpXsIezYtqvD0wNjKfZuhg5OSQETCReT9vJDGGL
	SVy4tx4ozsUhJLCMUeLy7tusMEXHpjQzQSSmM0ps/7adBcKZzCTRNXUhWDuLgKrE8SVbGEFs
	NgEtidVzj4PZIkD2y+7lYN3MAj9ZJN78PccCkhAWCJB4cbIBzOYVcJS4tnUGO4jNKRAssX3y
	IVaIDR2MEgd/LmWBuMNC4kJTBztEg6DEj8n3wOLMQBs2b2tihbDlJTavecsM0iwhMJdD4kPn
	LFaI8wQkvk0+BNTAAZSQldh0AOppSYmDK26wTGAUm4Vk7CwkY2chGbuAkXkVo2hqQXJBcVJ6
	kalecWJucWleul5yfu4mRki8T9zBeP+A9SHGZKCVE5mlRJPzgekiryTe0NjMyMLUxNTYyNzS
	jDRhJXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYuSTk9h6Yr7qf/8THr5/X2ZX/
	6tvQepBlfsfiiaveeffbZp076X353EaBJXu+KPryXtCvTLtR3l20VOyZFM8HsUsHJJu9DydY
	m4janC9gfHpRR2L754T8aHeXxXNvv9j52HqLGFO21tvrImL+c3ImSUfmstk3qzG//rxirr52
	7vfqN1O4+0u6lViKMxINtZiLihMBEJdW/A0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jQd0YTY1gg4UTpSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0Xc1rmAPZ8W0
	Xx+YGhhPs3UxcnJICJhIHJvSzARhi0lcuLceKM7FISQwnVFi+7ftLBDOZCaJrqkLmUGqWARU
	JY4v2cIIYrMJaEmsnnsczBYBsl92L2cCaWAW+Mki8ebvORaQhLBAgMSLkw1gNq+Ao8S1rTPY
	QWxOgWCJ7ZMPsUJs6GCUOPhzKQvEHRYSF5o62CEaBCV+TL4HFmcG2rB5WxMrhC0vsXnNW+YJ
	jAKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjByeSZ9A7GVQ0WhxgF
	OBiVeHhfsKkHC7EmlhVX5h5ilOBgVhLhXaqmESzEm5JYWZValB9fVJqTWnyIMRkYHhOZpUST
	84GJLq8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGJUWdXPO
	ULsur5izf8ti9gsvRR8W3OmRF+3ieDzjK+tK6+kX5b4rnXRjYti2L00mw8QzMuy4ryV7oKe3
	uUrQW1aBvtd/t3yMf/Os51H43DO32k6Z503Q2LOn723DN2Yr5o2RcxgF5Fq4/ix4xnm9jb27
	kcPRfbde29kZYjP2Oq0wbVuUGrVEX4mlOCPRUIu5qDgRAL27HkNqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 20:52:43 +0530, Sachin Kamat wrote:
> Hi KyongHo,
> 
> On 14 March 2014 10:35, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > This patch uses managed device helper functions in the probe().
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> [snip]
> 
> > +       data->clk = devm_clk_get(dev, "sysmmu");
> > +       if (IS_ERR(data->clk)) {
> > +               dev_info(dev, "No gate clock found!\n");
> > +               data->clk = NULL;
> > +       }
> 
> Why aren't you returning from here upon error?

It is for the case of a System MMU which does not need clock gating.

> > +
> > +       ret = clk_prepare(data->clk);
> > +       if (ret) {
> > +               dev_err(dev, "Failed to prepare clk\n");
> > +               return ret;
> >         }
> >
> >         data->sysmmu = dev;
> > @@ -556,17 +553,8 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
> >
> >         pm_runtime_enable(dev);
> >
> > -       dev_dbg(dev, "Initialized\n");
> > +       dev_dbg(dev, "Probed and initialized\n");
> 
> This message looks redundant.

Ok.

Do you mean that checking sysfs does the same?

Thank you.

KyongHo.
