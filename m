Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3HPLR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 07:17:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9812 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab3HPLRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 07:17:50 -0400
X-AuditID: cbfee68f-b7f436d000000f81-ab-520e0a5d6867
Date: Fri, 16 Aug 2013 20:17:49 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Joerg Roedel'" <joro@8bytes.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 04/16] iommu/exynos: allocate lv2 page table from own
 slab
Message-id: <20130816201749.a4bbaa8e85fc5a2d4e0b02ad@samsung.com>
In-reply-to: <20130814105615.GG4491@8bytes.org>
References: <002801ce941a$fb6369e0$f22a3da0$@samsung.com>
 <2544843.sndV7usHTj@amdc1227>
 <20130809145849.790a9800f4f9893b30e54a1c@samsung.com>
 <2101296.S6JDU5igl3@flatron> <20130814105615.GG4491@8bytes.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+ZkW4sF1+QwYRVMhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls/h46ji7xabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4uSf
	XkaLluu9TBbrZ7xmsVi16w+jg4DHk4PzmDxmN1xk8dg56y67x51re9g8zm9aw+yxeUm9x+Qb
	yxk9+rasYvT4vEnO48rRM0wBXFFcNimpOZllqUX6dglcGZfbt7IXXGOp2NDTwtjAeIS5i5GT
	Q0LARGLbrT8sELaYxIV769m6GLk4hASWMUr8nniPEabozsavjBCJRYwSC55/ZYJwJjFJ9M/+
	D9bOIqAq0XTjDjuIzSagJbF67nGwbhEBFYmWcz+YQRqYBeazSuy68IMVJCEsECyx6dlPsCJe
	AUeJmWuvA8U5ODgF9CUWX5OGWHCZUeLP6gYmiDMsJC40dbBD1AtK/Jh8D2wxM9CyzduaWCFs
	eYnNa96CLZMQ2MIhsXbPJzaI6wQkvk0+xAKyQEJAVmLTAaj/JSUOrrjBMoFRbBaSsbOQjJ2F
	ZOwCRuZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCEpoH8H490D1ocYk4FWTmSWEk3OB6aQ
	vJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwzthm
	oSmxa8HOpRsl4rMYl2osYvT2XCPBelViYcxix3VC+n/Wmvyw6Li2L5ElZkfz8it7a4SmxFXr
	c+k3ZUfGlggt5tQ9Z9f1iX/hIm2RyStfuFjec2lmnp9z8eKtKetKDGeGcUyR2rao6uQyBuXG
	sJ6Lrpcc8z6o2h3eZaL5ZNsBlTUtCcEcSizFGYmGWsxFxYkAl4nw8xcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd1YLr4gg69nxCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mSzWz3jNYrFq1x9GBwGPJwfnMXnMbrjI4rFz1l12jzvX9rB5nN+0htlj85J6j8k3
	ljN69G1ZxejxeZOcx5WjZ5gCuKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MWZcbt/KXnCNpWJDTwtjA+MR5i5GTg4JAROJOxu/MkLYYhIX7q1n62Lk4hASWMQoseD5VyYI
	ZxKTRP/s/ywgVSwCqhJNN+6wg9hsAloSq+ceB+sWEVCRaDn3gxmkgVlgPqvErgs/WEESwgLB
	Epue/QQr4hVwlJi59jpQnIODU0BfYvE1aYgFlxkl/qxuYII4w0LiQlMHO0S9oMSPyffAFjMD
	Ldu8rYkVwpaX2LzmLfMERoFZSMpmISmbhaRsASPzKkbR1ILkguKk9FwjveLE3OLSvHS95Pzc
	TYzgBPNMegfjqgaLQ4wCHIxKPLwME3mDhFgTy4orcw8xSnAwK4nwTnkIFOJNSaysSi3Kjy8q
	zUktPsSYDAyOicxSosn5wOSXVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2M819+W3vHUMN61ydh0d3H3bdXKWq5+s75m3xT/e05g1LtEGYOz2iNno4Ts6Je
	l8p1e0/SXX3MJeTv9Umhob1f4pgq17a8c2077XqDwS+FszxrTVPM5VMWUU+Mri+cOP3ViU5x
	7a4Hk4895I+zdLrzzeN4+War2J9rdunzdK6J+JGz5rf7ymQPJZbijERDLeai4kQAzebQvHQD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 12:56:16 +0200, 'Joerg Roedel' wrote:
> On Fri, Aug 09, 2013 at 09:55:30AM +0200, Tomasz Figa wrote:
> > Oh, this is a valid point, but it was more a nitpick about the coding 
> > style. Single path error handling (with goto) is widely used in the kernel 
> > in cases when more than one thing has to be undone and so I suggested this 
> > method of error handling here as well.
> 
> I agree with that review from Tomasz, the error-handling should look
> similar to all the other places in the kernel and use goto.
> 
Ok.

Thanks.

KyongHo.
> 
> 	Joerg
> 
> 
