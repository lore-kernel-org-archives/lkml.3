Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbaFIPbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:31:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaFIPbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:31:20 -0400
Date: Mon, 9 Jun 2014 11:30:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>, mjg59@srcf.ucam.org, bhe@redhat.com,
        jkosina@suse.cz, greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, ebiederm@xmission.com,
        hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140609153033.GC22049@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609021122.GB1924@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 10:11:22AM +0800, Dave Young wrote:

[..]
> > > > +	image->cmdline_buf = vzalloc(cmdline_len);
> > > 
> > > You should validate the upper/lower boundary of cmdline_len before
> > > calling vzalloc. When cmdline_len is 0 or too large, vmalloc failure
> > > message would be fired.
> > 
> > What's the upper length of vzalloc(). I think if it is too big to alloc,
> > then vzalloc() should return me an error?
> 
> function __vmalloc_node_range:
>         if (!size || (size >> PAGE_SHIFT) > totalram_pages)
>                 goto fail;
> 
> So I think only checking cmdline_len == 0 is enough.
> 
> For the upper length shouldn't it be stripped to COMMAND_LINE_SIZE?

We might be booting a newer kernel supporting bigger command line size
as compared to running kernel. So we query bzImage header to figure out
what's the maximum command line length supported.

Just that currently that check happens later during image load time.

Thanks
Vivek
