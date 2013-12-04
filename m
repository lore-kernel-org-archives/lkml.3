Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab3LDRUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:20:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab3LDRUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:20:01 -0500
Date: Wed, 4 Dec 2013 12:19:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 6/6] kexec: Support for Kexec on panic using new system
 call
Message-ID: <20131204171934.GB19087@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-7-git-send-email-vgoyal@redhat.com>
 <20131204014105.GB3298@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204014105.GB3298@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 09:41:05AM +0800, Baoquan He wrote:
> On 11/20/13 at 12:50pm, Vivek Goyal wrote:
> > This patch adds support for loading a kexec on panic (kdump) kernel usning
> > new system call.
> > +int load_crashdump_segments(struct kimage *image)
> > +{
> > +	unsigned long src_start, src_sz;
> > +	unsigned long elf_addr, elf_sz;
> > +	int ret;
> > +
> > +	/*
> > +	 * Determine and load a segment for backup area. First 640K RAM
> > +	 * region is backup source
> > +	 */
> > +
> > +	ret = walk_system_ram_res(KEXEC_BACKUP_SRC_START, KEXEC_BACKUP_SRC_END,
> > +				image, determine_backup_region);
> > +
> > +	/* Zero of postive return values are ok */
>                 ^
> Here I guess it is "or".

Yep. Will fix it.

Thanks
Vivek
