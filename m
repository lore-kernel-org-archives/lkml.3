Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799AbaKMWAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:00:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933512AbaKMWAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:00:12 -0500
From: Paul Moore <pmoore@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, sgrubb@redhat.com, eparis@parisplace.org
Subject: Re: [PATCH] audit: convert status version to a feature bitmap
Date: Thu, 13 Nov 2014 17:00:07 -0500
Message-ID: <2576097.lHYG4OpOLo@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.16.7-gentoo; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1415911097.4223.13.camel@perches.com>
References: <a98e3f45dbffd086c872f249b650b405f5cb8d2c.1415909269.git.rgb@redhat.com> <1415911097.4223.13.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 13, 2014 12:38:17 PM Joe Perches wrote:
> On Thu, 2014-11-13 at 15:29 -0500, Richard Guy Briggs wrote:
> > The version field defined in the audit status structure was found to have
> > limitations in terms of its expressibility of features supported.  This is
> > distict from the get/set features call to be able to command those
> > features
> > that are present.
> > 
> > Converting this field from a version number to a feature bitmap will allow
> > distributions to selectively backport and support certain features and
> > will
> > allow upstream to be able to deprecate features in the future.  It will
> > allow userspace clients to first query the kernel for which features are
> > actually present and supported.  Currently, EINVAL is returned rather
> > than EOPNOTSUP, which isn't helpful in determining if there was an error
> > in the command, or if it simply isn't supported yet.  Past features are
> > not represented by this bitmap, but their use may be converted to
> > EOPNOTSUP if needed in the future.
>
> Maybe use DECLARE_BITMAP instead of u32 and test_bit/set_bit

The audit_status struct is user visible and the version field is currently a 
u32 where DECLARE_BITMAP is an unsigned long.

-- 
paul moore
security and virtualization @ redhat

