Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaLaUXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 15:23:30 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45563 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbaLaUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 15:23:28 -0500
Message-ID: <1420057406.2085.7.camel@HansenPartnership.com>
Subject: Re: [PATCH repost 12/16] parisc/uaccess: fix sparse errors
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Date: Wed, 31 Dec 2014 12:23:26 -0800
In-Reply-To: <20141231183824.GA32430@redhat.com>
References: <1419499661-8566-1-git-send-email-mst@redhat.com>
	 <1419499661-8566-13-git-send-email-mst@redhat.com>
	 <549C91B9.8080009@gmx.de> <20141227161414.GA2571@redhat.com>
	 <1420046240.2085.3.camel@HansenPartnership.com>
	 <20141231183824.GA32430@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-31 at 20:38 +0200, Michael S. Tsirkin wrote:
> On Wed, Dec 31, 2014 at 09:17:20AM -0800, James Bottomley wrote:
[...]
> > OK, parisc developers still being dense, but this does look like an
> > abuse of the bitwise type.
> 
> To give you another example:
> 
> 	__le16 __user *p;
> 	__le16 foo;
> 	int rc = get_user(v, p);
> 
> really should be fine, ATM this gives a warning.

OK, I think I've figured it out.  You're saying that casting __gu_val to
a bitwise annotated type is an automatic sparse failure because it has
to be a long in our assembly code to receive the load/store as a
register.  However, this is required for sparse to do the correct lvalue
type = rvalue type check in the assignment to x.  We were all thinking
the __force just killed these sparse type checks.

In that case, I think parisc is fine with this.

James


