Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbaGRORy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:17:54 -0400
Received: from verein.lst.de ([213.95.11.211]:49624 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964864AbaGRORw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:17:52 -0400
Date: Fri, 18 Jul 2014 16:17:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: poma <pomidorabelisima@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Message-ID: <20140718141747.GA23272@lst.de>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com> <20140718132104.GK27940@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718132104.GK27940@esperanza>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 05:21:04PM +0400, Vladimir Davydov wrote:
> Slab warns, because the name of the cache being created contains spaces.
> The "bad" cache is created by scsi_get_host_cmd_pool. Its name
> (pool->cmd_name) is initialized by scsi_alloc_host_cmd_pool as follows:
> 
> 	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);
> 
> So, if hostt->name contains spaces, the cache name will also contain
> spaces and we'll get the warning. And hostt->name can contain spaces,
> e.g. virtscsi_host_template_single.name="Virtio SCSI HBA".

Or might not even be present.  I'll send a patch to replace it with
->proc_name, which must not contain spaces and is generally shorter
as well.

