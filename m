Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3C1UPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:15:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:2789 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3C1UPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:15:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,367,1363158000"; 
   d="scan'208";a="308834278"
Date: Thu, 28 Mar 2013 13:15:05 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xhci: Rename SEGMENT_SIZE and SEGMENT_SHIFT as the
 former is used in a.out.h
Message-ID: <20130328201505.GC5995@xanatos>
References: <20130328184827.29679.62426.stgit@warthog.procyon.org.uk>
 <20130328184835.29679.62285.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328184835.29679.62285.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I'm a little bit confused about your description for the second one.
Did you need to change the #defines names because they could conflict
with other drivers when the xHCI driver is built in?  Or is there some
other point I'm missing?

Are these feature patches for 3.10, or bug fixes for 3.9?  If they're
for 3.9, should they go into stable?  My inclination is the first patch
shouldn't but I'm not sure about this one.

On Thu, Mar 28, 2013 at 06:48:35PM +0000, David Howells wrote:
> Rename SEGMENT_SIZE and SEGMENT_SHIFT as the former is used in a.out.h.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: linux-usb@vger.kernel.org
...
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1234,8 +1234,8 @@ union xhci_trb {
>  #define TRBS_PER_SEGMENT	64
>  /* Allow two commands + a link TRB, along with any reserved command TRBs */
>  #define MAX_RSVD_CMD_TRBS	(TRBS_PER_SEGMENT - 3)
> -#define SEGMENT_SIZE		(TRBS_PER_SEGMENT*16)
> -#define SEGMENT_SHIFT		(ilog2(SEGMENT_SIZE))
> +#define TRB_SEGMENT_SIZE	(TRBS_PER_SEGMENT*16)
> +#define TRB_SEGMENT_SHIFT	(ilog2(TRB_SEGMENT_SIZE))

I would prefer an XHCI_ prefix instead of a TRB_ prefix.  Segments are
comprised of TRBs, so my brain doesn't parse this well. :)

Thanks,
Sarah Sharp
