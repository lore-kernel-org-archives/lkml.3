Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbbANVpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:45:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbbANVpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:45:08 -0500
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] audit: replace getname()/putname() hacks with reference counters
Date: Wed, 14 Jan 2015 16:45:06 -0500
Message-ID: <2531966.CgBBZnoLxq@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150114213717.GQ29998@madcap2.tricolour.ca>
References: <20150108164514.11316.85331.stgit@localhost> <20150108165056.11316.83417.stgit@localhost> <20150114213717.GQ29998@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 14, 2015 04:37:17 PM Richard Guy Briggs wrote:
> On 15/01/08, Paul Moore wrote:
> > In order to ensure that filenames are not released before the audit
> > subsystem is done with the strings there are a number of hacks built
> > into the fs and audit subsystems around getname() and putname().  To
> > say these hacks are "ugly" would be kind.
> > 
> > This patch removes the filename hackery in favor of a more
> > conventional reference count based approach.  The diffstat below tells
> > most of the story; lots of audit/fs specific code is replaced with a
> > traditional reference count based approach that is easily understood,
> > even by those not familiar with the audit and/or fs subsystems.
> > 
> > Signed-off-by: Paul Moore <pmoore@redhat.com>
> 
> The only nit I've got is "refcnt" enlarges "struct filename" where I
> would have used a bitfield with "separate".
> 
> Otherwise, this looks like an improvement.  Thanks.

I agree that it is unfortunate that struct filename increases, but it seemed 
liked a valid tradeoff considering that we got to remove the 
getname()/putname() hacks in favor of a more traditional approach.

As far the int versus bitfield, I suppose I favor the int in this particular 
case, but if the fs folks want a bitfield I can do that.

> Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

Thanks for taking the time to review the patchset.

-- 
paul moore
security @ redhat

