Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3LDBlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:41:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab3LDBlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:41:35 -0500
Date: Wed, 4 Dec 2013 09:41:05 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 6/6] kexec: Support for Kexec on panic using new system
 call
Message-ID: <20131204014105.GB3298@localhost.localdomain>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-7-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384969851-7251-7-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 at 12:50pm, Vivek Goyal wrote:
> This patch adds support for loading a kexec on panic (kdump) kernel usning
> new system call.
> +int load_crashdump_segments(struct kimage *image)
> +{
> +	unsigned long src_start, src_sz;
> +	unsigned long elf_addr, elf_sz;
> +	int ret;
> +
> +	/*
> +	 * Determine and load a segment for backup area. First 640K RAM
> +	 * region is backup source
> +	 */
> +
> +	ret = walk_system_ram_res(KEXEC_BACKUP_SRC_START, KEXEC_BACKUP_SRC_END,
> +				image, determine_backup_region);
> +
> +	/* Zero of postive return values are ok */
                ^
Here I guess it is "or".

> +	if (ret < 0)
> +		return ret;
> +
> +	src_start = image->arch.backup_src_start;
> +	src_sz = image->arch.backup_src_sz;
> +
> +	/* Add backup segment. */
> +	if (src_sz) {
> +		ret = kexec_add_buffer(image, __va(src_start), src_sz, src_sz,
> +					PAGE_SIZE, 0, -1, 0,
> +					&image->arch.backup_load_addr);
> +		if (ret)
> +			return ret;
> +	}
> +

