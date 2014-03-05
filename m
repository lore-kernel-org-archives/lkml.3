Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbaCEEll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:41:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48229 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbaCEEli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:41:38 -0500
X-AuditID: cbfee68f-b7f156d00000276c-9e-5316aaff344b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Yijing Wang'" <wangyijing@huawei.com>,
        "'Liviu Dudau'" <Liviu.Dudau@arm.com>
Cc: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
 <1393948204-11555-4-git-send-email-Liviu.Dudau@arm.com>
 <53169E86.1090609@huawei.com>
In-reply-to: <53169E86.1090609@huawei.com>
Subject: Re: [PATCH v5 3/7] pci: Create pci_host_bridge before its associated
 bus in pci_create_root_bus.
Date: Wed, 05 Mar 2014 13:41:35 +0900
Message-id: <002401cf382d$3062aa50$9127fef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac84JfalSvFRGuklTA+LZp5zyovFbAABwrFA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t8zY93/q8SCDT4u0bT4O+kYu8WHplZm
	iyVNGRbvl/UwWsw/co7V4vLCS6wW7w89Y7bY9PgakLtrDpvF2XnH2SwOLG1nsXj+6ROLxZ1r
	05gsXn48weLA5/Fx/SdGjzXz1jB6/P41idFjwaZSj5Yjb1k9et60sHpsXlLvcfvfY2aPvi2r
	GD0+b5IL4IrisklJzcksSy3St0vgyvjy9w1LwQnJipVzH7E3ML4X7mLk5JAQMJHoe3yMDcIW
	k7hwbz2QzcUhJLCMUeJq20xmmKKpdyczQiSmM0q0f1nBCuH8ZpS4u+4AK0gVm4CaxJcvh9lB
	bBEBP4me20+ZQYqYBX4xS3Qc3MIE0TGXUWL/lV6wKk4BLYkts9+DLRcWyJaYcPM5UBEHB4uA
	qsTft04gYV4BW4mD7x4zQtiCEj8m32MBsZkF1CUmzVvEDGHLS2xe85YZpFUCKP7ory7EDUYS
	Kzt/MUKUiEjse/EO7AMJgSMcEp8ObgCbwyIgIPFt8iEWiF5ZiU0HoD6WlDi44gbLBEaJWUg2
	z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyRl9O9gvHvA+hBjMtD6
	icxSosn5wJSTVxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYN7Fpzvu9w3Ft1YxH/Des9GuX1G+wuqqm80UrrWrH5pNM11Yu7v8tpFy42euRzV6m
	UL7UGs3QwEdWgQkRqy9f/CNy+oNjp+2iVe7Rrz15TrCsTuX9cKfyulAKy4ZiLi3rMHOuhukP
	5TL9FrzZGDdn/q2+R1HPm/b/Y9irz3NlxeYN/73KLU4FKrEUZyQaajEXFScCAI308d4vAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsVy+t9jQd3/q8SCDW4fVrb4O+kYu8WHplZm
	iyVNGRbvl/UwWsw/co7V4vLCS6wW7w89Y7bY9PgakLtrDpvF2XnH2SwOLG1nsXj+6ROLxZ1r
	05gsXn48weLA5/Fx/SdGjzXz1jB6/P41idFjwaZSj5Yjb1k9et60sHpsXlLvcfvfY2aPvi2r
	GD0+b5IL4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMAXpASaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5jx5e8bloITkhUr
	5z5ib2B8L9zFyMkhIWAiMfXuZEYIW0ziwr31bF2MXBxCAtMZJdq/rGCFcH4zStxdd4AVpIpN
	QE3iy5fD7CC2iICfRM/tp8wgRcwCv5glOg5uYYLomMsosf9KL1gVp4CWxJbZ79lAbGGBbIkJ
	N58DFXFwsAioSvx96wQS5hWwlTj47jEjhC0o8WPyPRYQm1lAXWLSvEXMELa8xOY1b5lBWiWA
	4o/+6kLcYCSxsvMXI0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO9
	4sTc4tK8dL3k/NxNjOCE9ExqB+PKBotDjAIcjEo8vC84xIKFWBPLiitzDzFKcDArifDGaAOF
	eFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+YLPNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0o
	JJCeWJKanZpakFoEs4WJg1OqgXHOJPt7kwI38f26ZJB4Kfy3eFLHw4+nuKIkTx/8XrotVMPE
	aq63XP6n5ZeZehUiDG2/z39Uu3TnbsWwGTvbQ6aIKzOIKFU25c/lsP15weDQpWVK5yLu/2ub
	NUlhMd/pAs1b/zYa9lZcM7D3uKI7PXRR/QKZtXdvT/Dr5JgcsOOnrnLIj/AXZseUWIozEg21
	mIuKEwF3F4bHjAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 12:48 PM, Yijing Wang wrote:
> On 2014/3/4 23:50, Liviu Dudau wrote:
> > Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
> > As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
> > the creation order has been changed for no good reason. Revert the order of
> > creation as we are going to depend on the pci_host_bridge structure to retrieve the
> > domain number of the root bus.
> >
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index 6e34498..78ccba0 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -505,7 +505,7 @@ static void pci_release_host_bridge_dev(struct device *dev)
> >  	kfree(bridge);
> >  }
> >
> > -static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
> > +static struct pci_host_bridge *pci_alloc_host_bridge(void)
> >  {
> >  	struct pci_host_bridge *bridge;
> >
> > @@ -514,7 +514,6 @@ static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
> >  		return NULL;
> >
> >  	INIT_LIST_HEAD(&bridge->windows);
> > -	bridge->bus = b;
> >  	return bridge;
> >  }
> >
> > @@ -1727,9 +1726,21 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> >  	char bus_addr[64];
> >  	char *fmt;
> >
> > +	bridge = pci_alloc_host_bridge();
> > +	if (!bridge)
> > +		return NULL;
> > +
> > +	bridge->dev.parent = parent;
> > +	bridge->dev.release = pci_release_host_bridge_dev;
> > +	error = pcibios_root_bridge_prepare(bridge);
> > +	if (error) {
> > +		kfree(bridge);
> > +		return NULL;
> 
> What about use goto err_out?

+1

I agree with your opinion.
It makes the code simpler.

Best regards,
Jingoo Han

> 
> > +	}
> > +
> >  	b = pci_alloc_bus();
> >  	if (!b)
> > -		return NULL;
> > +		goto err_out;
> >
> >  	b->sysdata = sysdata;
> >  	b->ops = ops;
> > @@ -1738,26 +1749,15 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> >  	if (b2) {
> >  		/* If we already got to this bus through a different bridge, ignore it */
> >  		dev_dbg(&b2->dev, "bus already known\n");
> > -		goto err_out;
> > +		goto err_bus_out;
> >  	}
> >
> > -	bridge = pci_alloc_host_bridge(b);
> > -	if (!bridge)
> > -		goto err_out;
> > -
> > -	bridge->dev.parent = parent;
> > -	bridge->dev.release = pci_release_host_bridge_dev;
> > +	bridge->bus = b;
> >  	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
> > -	error = pcibios_root_bridge_prepare(bridge);
> > -	if (error) {
> > -		kfree(bridge);
> > -		goto err_out;
> > -	}
> > -
> >  	error = device_register(&bridge->dev);
> >  	if (error) {
> >  		put_device(&bridge->dev);
> > -		goto err_out;
> > +		goto err_bus_out;
> >  	}
> >  	b->bridge = get_device(&bridge->dev);
> >  	device_enable_async_suspend(b->bridge);
> > @@ -1814,8 +1814,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> >  class_dev_reg_err:
> >  	put_device(&bridge->dev);
> >  	device_unregister(&bridge->dev);
> > -err_out:
> > +err_bus_out:
> >  	kfree(b);
> > +err_out:
> > +	kfree(bridge);
> >  	return NULL;
> >  }
> >
> >

