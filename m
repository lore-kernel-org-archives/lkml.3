Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab3BLRrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:47:55 -0500
Received: from mail.avalus.com ([89.16.176.221]:40979 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab3BLRry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:47:54 -0500
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2013 12:47:54 EST
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Alex Bligh <alex@alex.org.uk>
In-Reply-To: <1360685171-3792-2-git-send-email-pbonzini@redhat.com>
Date: Tue, 12 Feb 2013 17:37:04 +0000
Cc: Alex Bligh <alex@alex.org.uk>, linux-kernel@vger.kernel.org,
        <nbd-general@lists.sf.net>, Paul Clements <Paul.Clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
Message-Id: <115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com> <1360685171-3792-2-git-send-email-pbonzini@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo,

> Add support for a new flag that the server can pass.  If the flag is
> enabled, we translate REQ_FLUSH requests into the NBD_CMD_FLUSH
> command.
> 
> Cc: <nbd-general@lists.sf.net>
> Cc: Paul Clements <Paul.Clements@steeleye.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Alex Bligh <alex@alex.org.uk>
> [ Removed FUA support for reasons similar to those outlined in
>  https://lkml.org/lkml/2010/8/17/234 for virtio - Paolo ]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>


For my education, why remove the FUA stuff? The link you posted
was for virtio drivers, and says:

> > Hmmm... the underlying storage could be md/dm RAIDs in which case FUA
> > should be cheaper than FLUSH.
> 
> If someone ever wrote a virtio-blk backend that sits directly ontop
> of the Linux block layer that would be true.

In this case we don't know what the backend is sitting on top of
a-priori. It might be the current nbd server code, but it might
not be.

-- 
Alex Bligh




