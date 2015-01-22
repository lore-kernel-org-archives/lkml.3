Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbbAVQYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:24:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbbAVQYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:24:17 -0500
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com, sd@queasysnail.net,
        linux-kernel@vger.kernel.org, linux@roeck-us.net,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 5/5] audit: replace getname()/putname() hacks with reference counters
Date: Thu, 22 Jan 2015 11:24:10 -0500
Message-ID: <1904775.fjUp0pyajn@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150122160942.GK18752@madcap2.tricolour.ca>
References: <20150122045303.1347.98054.stgit@localhost> <20150122050023.1347.6866.stgit@localhost> <20150122160942.GK18752@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 22, 2015 11:09:42 AM Richard Guy Briggs wrote:
> On 15/01/22, Paul Moore wrote:
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
> > CC: viro@zeniv.linux.org.uk
> > CC: linux-fsdevel@vger.kernel.org
> > Signed-off-by: Paul Moore <pmoore@redhat.com>
> 
> Noted change of bumping refcnt before passing back pointer to struct
> filename.
> 
> Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

Thanks for taking another look at the patch set.

-- 
paul moore
security @ redhat

