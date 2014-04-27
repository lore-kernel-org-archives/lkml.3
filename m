Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaD0Tqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:46:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39218 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaD0Tqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:46:33 -0400
Message-ID: <1398627981.9518.19.camel@fourier>
Subject: Re: [PATCH 3.8 068/133] [SCSI] fix our current target reap
 infrastructure
From: Kamal Mostafa <kamal@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        James Bottomley <JBottomley@Parallels.com>
Date: Sun, 27 Apr 2014 12:46:21 -0700
In-Reply-To: <1398391392.7767.181.camel@deadeye.wl.decadent.org.uk>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
	 <1398197671-12786-69-git-send-email-kamal@canonical.com>
	 <1398391392.7767.181.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 03:03 +0100, Ben Hutchings wrote:
> On Tue, 2014-04-22 at 13:13 -0700, Kamal Mostafa wrote:
> > 3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: James Bottomley <JBottomley@Parallels.com>
> > 
> > commit e63ed0d7a98014fdfc2cfeb3f6dada313dcabb59 upstream.
> > 
> > This patch eliminates the reap_ref and replaces it with a proper kref.
> > On last put of this kref, the target is removed from visibility in
> > sysfs.  The final call to scsi_target_reap() for the device is done from
> > __scsi_remove_device() and only if the device was made visible.  This
> > ensures that the target disappears as soon as the last device is gone
> > rather than waiting until final release of the device (which is often
> > too long).
> > 
> > Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> > Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> > Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> [...]
> 
> This and the next patch had the comment "delay backport by 2 months for
> field testing".
> 


Yup, thanks very much for catching this Ben.  I'll drop these two from
the 3.8-stable queue:

        e63ed0d [SCSI] fix our current target reap infrastructure
        f2495e2 [SCSI] dual scan thread bug fix

Luis, heads-up, looks like you have them queued for 3.11-stable too.

I note that our standard (and automated) procedure of stripping the "Cc:
stable" lines when applying to stable isn't helping us here.  Useful
hints like this advisory from those patches often just go unnoticed:

    Cc: stable@vger.kernel.org # delay backport for 2 months for field testing

I'll start thinking about how we can improve our scripts and procedures
so that we don't throw this info away.

 -Kamal


