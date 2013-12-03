Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3LCPtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:49:12 -0500
Received: from smtp.citrix.com ([66.165.176.89]:28995 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab3LCPtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:49:08 -0500
X-IronPort-AV: E=Sophos;i="4.93,818,1378857600"; 
   d="scan'208";a="80142391"
Message-ID: <1386085745.13256.51.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/block: Correctly define structures in
 public headers on ARM32 and ARM64
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Julien Grall <julien.grall@linaro.org>
CC: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <patches@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 3 Dec 2013 15:49:05 +0000
In-Reply-To: <529DF897.1080303@linaro.org>
References: <1386083382-7306-1-git-send-email-julien.grall@linaro.org>
	 <529E039A02000078001097F5@nat28.tlf.novell.com>
	 <529DF897.1080303@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 15:28 +0000, Julien Grall wrote:
> On 12/03/2013 03:15 PM, Jan Beulich wrote:
> >>>> On 03.12.13 at 16:09, Julien Grall <julien.grall@linaro.org> wrote:
> >> --- a/include/xen/interface/io/blkif.h
> >> +++ b/include/xen/interface/io/blkif.h
> >> @@ -146,7 +146,7 @@ struct blkif_request_segment_aligned {
> >>  struct blkif_request_rw {
> >>  	uint8_t        nr_segments;  /* number of segments                   */
> >>  	blkif_vdev_t   handle;       /* only for read/write requests         */
> >> -#ifdef CONFIG_X86_64
> >> +#if defined(CONFIG_X86_64) || defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > 
> > Perhaps using
> > 
> > #ifndef CONFIG_X86_32
> > 
> > would be the better one, assuming that we won't add further
> > non-64-bit-clean ABI variants?
> 
> I'm fine with this solution. I will resend the patch.

Just a random thought but what about using the CONFIG_$ARCH to define a
more semantic name, like HAVE_4_BYTE_ALIGNED_QUAD_WORDS, or whichever
terminology for an 8-byte type is appropriate in the context.

Maybe Linux even already has such a #define?

Ian.


