Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaKQV7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:59:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaKQV7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:59:46 -0500
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, sgrubb@redhat.com,
        eparis@parisplace.org
Subject: Re: [PATCH] audit: convert status version to a feature bitmap
Date: Mon, 17 Nov 2014 16:59:38 -0500
Message-ID: <22486502.DVxKTqPvb6@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.16.7-gentoo; KDE/4.14.2; x86_64; ; )
In-Reply-To: <31e5843487fb1596bbae61e5b8be9efb540c471f.1416257393.git.rgb@redhat.com>
References: <12539378.gxbYIULgU3@sifl> <31e5843487fb1596bbae61e5b8be9efb540c471f.1416257393.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 17, 2014 03:51:01 PM Richard Guy Briggs wrote:
> The version field defined in the audit status structure was found to have
> limitations in terms of its expressibility of features supported.  This is
> distict from the get/set features call to be able to command those features
> that are present.
> 
> Converting this field from a version number to a feature bitmap will allow
> distributions to selectively backport and support certain features and will
> allow upstream to be able to deprecate features in the future.  It will
> allow userspace clients to first query the kernel for which features are
> actually present and supported.  Currently, EINVAL is returned rather than
> EOPNOTSUP, which isn't helpful in determining if there was an error in the
> command, or if it simply isn't supported yet.  Past features are not
> represented by this bitmap, but their use may be converted to EOPNOTSUP if
> needed in the future.
> 
> Since "version" is too generic to convert with a #define, use a union in the
> struct status, introducing the member "feature_bitmap" unionized with
> "version".
> 
> Convert existing AUDIT_VERSION_* macros over to AUDIT_FEATURE_BITMAP*
> counterparts, leaving the former for backwards compatibility.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/uapi/linux/audit.h |   17 +++++++++++++----
>  kernel/audit.c             |    2 +-
>  2 files changed, 14 insertions(+), 5 deletions(-)

Applied to the audit next branch, thanks Richard.

 * git://git.infradead.org/users/pcmoore/audit next

-- 
paul moore
security and virtualization @ redhat

