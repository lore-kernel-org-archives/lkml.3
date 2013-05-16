Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3EPEB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:01:26 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:37272 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3EPEBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:01:23 -0400
Date: Thu, 16 May 2013 00:01:30 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/6] Drivers: hv: vmbus: Implement multi-channel support
Message-ID: <20130516040130.GB16728@kroah.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368655354-27651-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 03:02:29PM -0700, K. Y. Srinivasan wrote:
> +/*
> + * Retrieve the (sub) channel on which to send an outgoing request.
> + * When a primary channel has multiple sub-channels, we choose a
> + * channel whose VCPU binding is closest to the VCPU on which
> + * this call is being made.
> + */
> +struct vmbus_channel *get_outgoing_channel(struct vmbus_channel *primary)

That's a _very_ vague global symbol name you are adding to the kernel.
Same goes for the other functions you are adding here, please fix that,
and make them have the vmbus_ prefix, like everything else in this
patch.

So, sorry, no ack here.

greg k-h
