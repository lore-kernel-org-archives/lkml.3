Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3E1TFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:05:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24614 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3E1TFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:05:39 -0400
Date: Tue, 28 May 2013 15:05:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: John Stultz <john.stultz@linaro.org>
Cc: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/xen: sync the CMOS RTC as well as the Xen
 wallclock
Message-ID: <20130528190530.GA24303@phenom.dumpdata.com>
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
 <1369765368-10823-2-git-send-email-david.vrabel@citrix.com>
 <51A4FF25.8040908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A4FF25.8040908@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:01:57PM -0700, John Stultz wrote:
> On 05/28/2013 11:22 AM, David Vrabel wrote:
> >From: David Vrabel <david.vrabel@citrix.com>
> >
> >Adjustments to Xen's persistent_clock via update_persistent_clock()
> >don't actually persist, as the xen_set_walltime() just notifies other
> >domN guests that it has been updated, and does not modify the
> >underlying CMOS clock.
> >
> >Thus, this patch modifies xen_set_wallclock() so it will set the
> >underlying CMOS clock when called from dom0, ensuring the
> >persistent_clock will be correct on the next hardware boot.
> >
> >Dom0 does not support accessing EFI runtime services and Xen does not
> >run on Moorsetown platforms so the CMOS RTC is the only supported
> >hardware clock.
> >
> >Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> >Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Ok, I've queued this for 3.11.

Thanks.
> 
> thanks
> -john
> 
