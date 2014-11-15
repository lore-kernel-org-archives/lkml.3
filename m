Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaKOHvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 02:51:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35639 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaKOHvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 02:51:45 -0500
Date: Sat, 15 Nov 2014 10:51:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Martyn Welch <martyn.welch@ge.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Igor Alekseev <igor.alekseev@itep.ru>
Subject: Re: [PATCH 2/3] staging: vme: mmap() support for vme_user
Message-ID: <20141115075133.GP6749@mwanda>
References: <1416008178-9393-1-git-send-email-dmitry.kalinkin@gmail.com>
 <1416008178-9393-3-git-send-email-dmitry.kalinkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416008178-9393-3-git-send-email-dmitry.kalinkin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 02:36:17AM +0300, Dmitry Kalinkin wrote:
> +int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma)
> +{
> +	struct vme_master_resource *image;
> +	phys_addr_t phys_addr;
> +	unsigned long vma_size;
> +
> +	if (resource->type != VME_MASTER) {
> +		printk(KERN_ERR "Not a master resource\n");

Run your patch through scripts/checkpatch.pl

Also warning messages let people flood /var/log/messages so they can be
a DoS vector.

regards,
dan carpenter

