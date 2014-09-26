Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaIZDWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:22:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60642 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaIZDWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:22:38 -0400
X-AuditID: cbfee68e-f79b46d000002b74-65-5424dbfc8f39
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, naushad@samsung.com
References: <1411556154-14464-1-git-send-email-pankaj.dubey@samsung.com>
 <20140925104512.GC28590@kroah.com>
In-reply-to: <20140925104512.GC28590@kroah.com>
Subject: RE: [PATCH] kobject: fix NULL pointer derefernce in kobj_child_ns_ops
Date: Fri, 26 Sep 2014 08:52:12 +0530
Message-id: <000c01cfd939$17523320$45f69960$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF6ubeRnppJZthvJzve+D1q3pylSgJUWP/qnKpWyMA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkRvfPbZUQgwX3xC2aF69ns7i8aw6b
	xaej/1kdmD32z13D7tG3ZRWjx+dNcgHMUVw2Kak5mWWpRfp2CVwZy99cYCxo4KpYtHoWawPj
	D/YuRg4OCQETid/3bboYOYFMMYkL99azdTFycQgJLGWU+Pz6ABtEwkTizOLPjBCJ6YwSh7/P
	BksICfxllHh4xxfEZhPQlXjyfi4ziC0ioCXx7NgOMJtZwFTizpkDrBD1uRKNL/6CxTkF9CVe
	rnvBDmILC/hJ/P37EayGRUBV4sDuaWDzeQUsJZq3nmaBsAUlfky+xwIxU0ti/c7jTBC2vMTm
	NW+ZIQ5VkNhx9jUjxA1WEs07JrBC1IhLTHrwkB3kAQmBbewSr7buZoZYJiDxbfIhFkhIyEps
	OgA1R1Li4IobLBMYJWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CIjveLE3OLSvHS95Pzc
	TYzACDz971nfDsabB6wPMQpwMCrx8N5YpxIixJpYVlyZe4jRFOiiicxSosn5wDjPK4k3NDYz
	sjA1MTU2Mrc0UxLnTZD6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0fsp44szDcYL0x4c
	2i1QG7Jt+q+fKyfVey08cupIXNQ6z1Unb1s7eMW/SnZTnpw375ZAbr7/4sP7QkxniehGaXUF
	h4e/PeGn42b7i7sj4U56W+1BXpGuOM1ol7S2nqUTNFLSXHO2Os6az1+73KnAvXJrplzpu8TF
	ckG9SncETLrv1vaaCsQosRRnJBpqMRcVJwIAA6CTiLsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd0/t1VCDHZcELRoXryezeLyrjls
	Fp+O/md1YPbYP3cNu0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYwZix/c4GxoIGrYtHqWawNjD/Yuxg5OSQETCTOLP7MCGGLSVy4t56ti5GLQ0hgOqPE
	4e+z2UASQgJ/GSUe3vEFsdkEdCWevJ/LDGKLCGhJPDu2A8xmFjCVuHPmACtEfa5E44u/YHFO
	AX2Jl+tegC0TFvCT+Pv3I1gNi4CqxIHd08Dm8wpYSjRvPc0CYQtK/Jh8jwVippbE+p3HmSBs
	eYnNa94yQxyqILHj7GtGiBusJJp3TGCFqBGXmPTgIfsERqFZSEbNQjJqFpJRs5C0LGBkWcUo
	mlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHOHPpHYwrmywOMQowMGoxMN7Y51KiBBrYllxZe4h
	RgkOZiURXoULQCHelMTKqtSi/Pii0pzU4kOMpkCfTmSWEk3OByafvJJ4Q2MTc1NjU0sTCxMz
	SyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFINjFENTmWbt7NXHVLtXrg8+kDuwzVV0vGqxo77
	+XJntkZMux7WYR26zE9+80/lvnmZxoZWXZXqGhtfKxTynctd9dkl8EjQgggj6WWGt5eu+uaW
	J7vS5LW0i//na2Huu5VCZQ6clJwt2rBb0Uz5RXItH6PJzhWNxackK1Wvrsj+/3T9kmpeVi09
	JZbijERDLeai4kQA5uEopQYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thursday, September 25, 2014 4:15 PM, Greg KH wrote,
> To: Pankaj Dubey
> Cc: linux-kernel@vger.kernel.org; naushad@samsung.com
> Subject: Re: [PATCH] kobject: fix NULL pointer derefernce in
kobj_child_ns_ops
> 
> On Wed, Sep 24, 2014 at 04:25:54PM +0530, Pankaj Dubey wrote:
> > We will hit NULL pointer dereference if we call
> > platform_device_register_simple or platform_device_add at very early
> > stage. I have observed following crash when called platform_device_add
> > from "init_irq" hook of machine_desc. This patch fixes this issue and
> > let system handle this case gracefully instead of kernel panic.
> 
> Is there any in-tree code that needs this "fix"?  Or can it wait for 3.18?
> 

Even though I am not completely sure, at least I could not see any in-tree
code
which may need this fix.
I posted this fix, because while working on one of syscon patch [1] I wanted
to call
"platform_device_add" in one of APIs which may get called during very early
stage
of system boot, and during that time it will lead to kernel panic.

But mine syscon related patch is still under review, so I think this patch
can wait
for 3.18.

[1]: https://lkml.org/lkml/2014/9/22/12

Thanks,
Pankaj Dubey


> thanks,
> 
> greg k-h

