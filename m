Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966406AbaFSXoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:44:10 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60946 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965771AbaFSXoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:44:09 -0400
Message-ID: <1403221447.1962.24.camel@jarvis.lan>
Subject: Re: Cannot partition 32GB disk on a 32bit machine (correct version
 of the patch this time)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@linux.intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "aeb@cwi.nl" <aeb@cwi.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Jun 2014 16:44:07 -0700
In-Reply-To: <1403219058.10778.72.camel@acox1-desk.ger.corp.intel.com>
References: <1403170201.10778.36.camel@acox1-desk.ger.corp.intel.com>
	 <1403170400.10778.38.camel@acox1-desk.ger.corp.intel.com>
	 <1403203437.17294.25.camel@dabdike.int.hansenpartnership.com>
	 <1403219058.10778.72.camel@acox1-desk.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-20 at 00:04 +0100, Alan Cox wrote:
> > Wow that's junk issued by an Exchange server ... Alan, really ...
> 
> Blame evolution. It apparently thinks that if you follow up to your own
> email from one address it should randomly switch to another.

so you @linux.intel.com is sane and you @intel.com is exchange ...

> > Do you have CONFIG_LBD turned on?  That's supposed to let us go up to
> > about 16TB before we run out of page index bits.  If you do, we might
> > have a variable that's int but should be sector_t somewhere.
> 
> LBDAF is set

OK, so as Andrew said, it looks like Viro's conversion from aio to
iterators has a length and offset problem on 32 bits.

my suspicion is that iov_offset and count in struct iov_iter have to
become loff_t quantities ... plus a lot of other size_t to loff_t
conversions.  Hopefully Viro will fix it as a matter of urgency.

James


