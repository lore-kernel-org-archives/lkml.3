Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3KGDEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:04:24 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:65186 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3KGDEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:04:22 -0500
Date: Wed, 6 Nov 2013 19:06:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
Message-ID: <20131107030640.GD8482@kroah.com>
References: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>
 <20131106015645.GA28769@kroah.com>
 <527AD802.6020902@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527AD802.6020902@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 04:00:02PM -0800, Olav Haugan wrote:
> On 11/5/2013 5:56 PM, Greg KH wrote:
> > On Tue, Nov 05, 2013 at 04:54:12PM -0800, Olav Haugan wrote:
> >> zsmalloc encodes a handle using the page pfn and an object
> >> index. On some hardware platforms the pfn could be 0 and this
> >> causes the encoded handle to be 0 which is interpreted as an
> >> allocation failure.
> > 
> > What platforms specifically have this issue?
> 
> Currently some of Qualcomm SoC's have physical memory that starts at
> address 0x0 which causes this problem.

Then say this, and list the exact SoC's that can have this problem so
people know how to evaluate the bugfix and see if it is relevant for
their systems.

> I believe this could be a problem
> on any platforms if memory is configured to be starting at physical
> address 0x0 for these platforms.

Have you seen this be a problem?  So it's just a theoretical issue at
this point in time?

> >> To prevent this false error we ensure that the encoded handle
> >> will not be 0 when allocation succeeds.
> >>
> >> Change-Id: Ifff930dcf254915b497aec5cb36f152a5e5365d6
> > 
> > What is this?  What can anyone do with it?
> 
> This is an identifier used by "Gerrit Code Review" to track changes to
> the same patch. I will remove it.

Please do so, it has no place in kernel patches submitted for
acceptance.

Please fix up the changelog, and the rest based on the other comments
and resend.

thanks,

greg k-h
