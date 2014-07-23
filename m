Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaGWNBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:01:24 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:45423 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaGWNBX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Wed, 23 Jul 2014 09:01:23 -0400
Message-Id: <53CFCE3D02000078000251C0@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 23 Jul 2014 14:01:17 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <weiyj_lk@163.com>, "David Vrabel" <david.vrabel@citrix.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xenproject.org>,
        "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/pciback: Fix error return code in
 xen_pcibk_attach()
References: <1405835161-8546-1-git-send-email-weiyj_lk@163.com>
In-Reply-To: <1405835161-8546-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.07.14 at 07:46, <weiyj_lk@163.com> wrote:
> --- a/drivers/xen/xen-pciback/xenbus.c
> +++ b/drivers/xen/xen-pciback/xenbus.c
> @@ -174,6 +174,7 @@ static int xen_pcibk_attach(struct xen_pcibk_device *pdev)
>  				 "version mismatch (%s/%s) with pcifront - "
>  				 "halting " DRV_NAME,
>  				 magic, XEN_PCI_MAGIC);
> +		err = -EFAULT;
>  		goto out;
>  	}
>  

While -EFAULT is kind of odd here, I realize this is because the same
also gets passed to xenbus_dev_fatal(); -EILSEQ, -ENODATA, or
-EPROTO (despite it normally being network specific) would seem
better to me.

In any event
Reviewed-by Jan Beulich <jbeulich@suse.com>

