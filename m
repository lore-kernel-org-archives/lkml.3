Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab3BYCWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:22:22 -0500
Received: from ozlabs.org ([203.10.76.45]:45749 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759567Ab3BYCWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:22:20 -0500
Date: Mon, 25 Feb 2013 13:21:46 +1100
From: Paul Mackerras <paulus@samba.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 1/2] vfio powerpc: enabled on powernv platform
Message-ID: <20130225022146.GC12404@drongo>
References: <1360583672-21924-1-git-send-email-aik@ozlabs.ru>
 <1360583672-21924-2-git-send-email-aik@ozlabs.ru>
 <1360621003.12392.117.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360621003.12392.117.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 03:16:43PM -0700, Alex Williamson wrote:
> 
> Why do these all return long (vs int)?  Is this a POWER-ism?

On ppc64 the compiler tends to generate slightly shorter code with
longs than with ints.  The reason is that with ints the compiler has
to put in "extend sign word" instructions to convert 64-bit values
from arithmetic instructions to values in the 32-bit range.

Paul.
