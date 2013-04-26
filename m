Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3DZRKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:10:36 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46478 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3DZRKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:10:34 -0400
Date: Fri, 26 Apr 2013 10:10:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND^2] sd: fix infinite kernel/udev loop on
 non-removable Medium Not Present
Message-ID: <20130426171031.GA29600@kroah.com>
References: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:39:33AM -0500, Steven J. Magnani wrote:
> Commit eface65c336eff420d70beb0fb6787a732e05ffb (2.6.38) altered
> set_media_not_present() in a way that prevents the sd driver from
> remembering that a non-removable device has reported "Medium Not Present".
> This condition can occur on hotplug of a (i.e.) USB Mass Storage device
> whose medium is offline due to an unrecoverable controller error,
> but which is otherwise capable of SCSI communication (to download new 
> microcode, etc.).
> 
> Under these conditions, the changed code results in an infinite loop
> between the kernel and udevd. When udevd attempts to open the device
> in response to a change notification, a SCSI "Medium Not Present" error
> occurs which causes the kernel to signal another change. The cycle
> repeats until the device is unplugged, resulting in udevd consuming ever-
> increasing amounts of CPU and virtual memory.
> 
> Resolve this by remembering "media not present" whether the device has
> declared itself "removable" or not.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
