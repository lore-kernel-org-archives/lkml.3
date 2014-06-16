Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaFPVn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:43:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaFPVnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:43:55 -0400
Date: Mon, 16 Jun 2014 17:43:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, WANG Chao <chaowang@redhat.com>,
        Dave Young <dyoung@redhat.com>, mjg59@srcf.ucam.org, bhe@redhat.com,
        jkosina@suse.cz, greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140616214313.GB1870@redhat.com>
References: <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
 <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
 <20140613124609.GC5871@redhat.com>
 <20140613153620.GG4751@pd.tnic>
 <20140616173823.GC4515@redhat.com>
 <20140616200526.GF8170@pd.tnic>
 <20140616205331.GA13257@redhat.com>
 <20140616210927.GJ8170@pd.tnic>
 <539F60B3.1040509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539F60B3.1040509@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 02:25:07PM -0700, H. Peter Anvin wrote:
> On 06/16/2014 02:09 PM, Borislav Petkov wrote:
> > 
> > Nah, I don't feel strongly about it - I just don't trust userspace and
> > think that every value we get from it should be "sanitized".
> > 
> 
> Borislav and I talked about this briefly over IRC.  A key part of that
> is that if userspace could manipulate this system call to consume an
> unreasonable amount of memory, we would have a problem, for example if
> this code used vzalloc() instead of kzalloc().  However, since
> kmalloc/kzalloc implies a relatively restrictive limit on the memory
> allocation size anyway, well short of anything that could cause OOM
> problems, that pretty much solves the problem.

Actually currently I am using vzalloc() for command line buffer
allocation.

	image->cmdline_buf = vzalloc(cmdline_len);
	if (!image->cmdline_buf)
		goto out;

Should I switch to using kzalloc() instead?

Thanks
Vivek
