Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3BVIjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:39:52 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:49176 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3BVIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:39:50 -0500
Subject: Re: [PATCH] MODSIGN: Fix including certificate twice when the
 signing_key.x509 already exists
From: joeyli <jlee@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Marek <mmarek@suse.com>
In-Reply-To: <804.1361456165@warthog.procyon.org.uk>
References: <1361445829-23594-1-git-send-email-jlee@suse.com>
	 <804.1361456165@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Feb 2013 16:38:48 +0800
Message-ID: <1361522328.8705.73.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, 

Thanks for your review and point out!

於 四，2013-02-21 於 14:16 +0000，David Howells 提到：
> > +ifneq ($(shell pwd), $(srctree))
> 
> How reliable is this, I wonder?
> 
> David
> 

My current shell is bash, and I tried the '$(shell pwd)' in Makefile
works for grab the REAL path when the build path is a symbolic links to
kernel source directory. Looks the '$(shell pwd)' in Makefile was call
'/bin/pwd' but not 'the shell builtin pwd'.

But, in case the behavior is different between shells, I think used
'$(shell /bin/pwd)' will be better for make sure we call /bin/pwd from
coreutils.

I will send a second version of this patch, please consider for accept
if we need this change.


Thanks a lot!
Joey Lee

