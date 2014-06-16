Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaFPWLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:11:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46582 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbaFPWLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:11:10 -0400
Date: Tue, 17 Jun 2014 00:10:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Dave Young <dyoung@redhat.com>, mjg59@srcf.ucam.org, bhe@redhat.com,
        jkosina@suse.cz, greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140616221059.GM8170@pd.tnic>
References: <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
 <20140613124609.GC5871@redhat.com>
 <20140613153620.GG4751@pd.tnic>
 <20140616173823.GC4515@redhat.com>
 <20140616200526.GF8170@pd.tnic>
 <20140616205331.GA13257@redhat.com>
 <20140616210927.GJ8170@pd.tnic>
 <539F60B3.1040509@zytor.com>
 <20140616214313.GB1870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140616214313.GB1870@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 05:43:13PM -0400, Vivek Goyal wrote:
> Actually currently I am using vzalloc() for command line buffer
> allocation.
> 
> 	image->cmdline_buf = vzalloc(cmdline_len);
> 	if (!image->cmdline_buf)
> 		goto out;
> 
> Should I switch to using kzalloc() instead?

Well, vzalloc could trigger the OOM killer, can't it, for the right
size? If so, then we will have a serious problem.

And this snippet above is down the syscall path.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
