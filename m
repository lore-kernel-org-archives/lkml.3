Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3A3IJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:09:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:44642 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab3A3IJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:09:41 -0500
Date: Tue, 29 Jan 2013 23:58:30 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: rjw@sisk.pl, lenb@kernel.org, akpm@linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [RFC PATCH v2 01/12] Add sys_hotplug.h for system device hotplug
 framework
Message-ID: <20130130045830.GH30002@kroah.com>
References: <1357861230-29549-1-git-send-email-toshi.kani@hp.com>
 <1357861230-29549-2-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357861230-29549-2-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 04:40:19PM -0700, Toshi Kani wrote:
> +/*
> + * Hot-plug device information
> + */

Again, stop it with the "generic" hotplug term here, and everywhere
else.  You are doing a very _specific_ type of hotplug devices, so spell
it out.  We've worked hard to hotplug _everything_ in Linux, you are
going to confuse a lot of people with this type of terms.

> +union shp_dev_info {
> +	struct shp_cpu {
> +		u32		cpu_id;
> +	} cpu;

What is this?  Why not point to the system device for the cpu?

> +	struct shp_memory {
> +		int		node;
> +		u64		start_addr;
> +		u64		length;
> +	} mem;

Same here, why not point to the system device?

> +	struct shp_hostbridge {
> +	} hb;
> +
> +	struct shp_node {
> +	} node;

What happened here with these?  Empty structures?  Huh?

> +};
> +
> +struct shp_device {
> +	struct list_head	list;
> +	struct device		*device;

No, make it a "real" device, embed the device into it.

But, again, I'm going to ask why you aren't using the existing cpu /
memory / bridge / node devices that we have in the kernel.  Please use
them, or give me a _really_ good reason why they will not work.

> +	enum shp_class		class;
> +	union shp_dev_info	info;
> +};
> +
> +/*
> + * Hot-plug request
> + */
> +struct shp_request {
> +	/* common info */
> +	enum shp_operation	operation;	/* operation */
> +
> +	/* hot-plug event info: only valid for hot-plug operations */
> +	void			*handle;	/* FW handle */
> +	u32			event;		/* FW event */

What is this?

greg k-h
