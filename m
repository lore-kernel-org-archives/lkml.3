Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaAMRxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:53:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbaAMRxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:53:33 -0500
Message-ID: <1389635581.26822.2.camel@deneb.redhat.com>
Subject: Re: [PATCH 1/6] efi: create memory map iteration helper
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org,
        patches@linaro.org, Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 13 Jan 2014 12:53:01 -0500
In-Reply-To: <20140113151759.GG3256@console-pimps.org>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
	 <1389392950-22457-2-git-send-email-msalter@redhat.com>
	 <20140113151759.GG3256@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 15:17 +0000, Matt Fleming wrote:
> On Fri, 10 Jan, at 05:29:05PM, Mark Salter wrote:
> > There are a lot of places in the kernel which iterate through an
> > EFI memory map. Most of these places use essentially the same
> > for-loop code. This patch adds a for_each_efi_memory_desc()
> > helper to clean up all of the existing duplicate code and avoid
> > more in the future.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > ---
> >  include/linux/efi.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index 11ce678..9dc5b05 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -618,6 +618,12 @@ extern int efi_set_rtc_mmss(const struct timespec *now);
> >  extern void efi_reserve_boot_services(void);
> >  extern struct efi_memory_map memmap;
> >  
> > +/* Iterate through an efi_memory_map */
> > +#define for_each_efi_memory_desc(m, md)					   \
> > +	for ((md) = (m)->map;						   \
> > +	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
> > +	     (md) = (void *)(md) + (m)->desc_size)
> > +
> 
> Err, what? I just picked up your previous patch ("x86/efi: Create memory
> map iteration helper") which adds this chunk, and I didn't see a follow
> up email telling me not to pick it up.
> 
> What's the plan?
> 
Sorry, I meant to drop this one from this series. The one you picked
up is the one I wanted picked up.

--Mark


