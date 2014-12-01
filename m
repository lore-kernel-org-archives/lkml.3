Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaLAK2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:28:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22049 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaLAK21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:28:27 -0500
Date: Mon, 1 Dec 2014 13:27:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: tytso@mit.edu, zatimend@hotmail.co.uk, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Kees Cook <keescook@chromium.org>, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] random: add and use memzero_explicit() for clearing data
Message-ID: <20141201102529.GA9666@mwanda>
References: <1408996899-4892-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408996899-4892-1-git-send-email-dborkman@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:01:39PM +0200, Daniel Borkmann wrote:
> zatimend has reported that in his environment (3.16/gcc4.8.3/corei7)
> memset() calls which clear out sensitive data in extract_{buf,entropy,
> entropy_user}() in random driver are being optimized away by gcc.
> 
> Add a helper memzero_explicit() (similarly as explicit_bzero() variants)
> that can be used in such cases where a variable with sensitive data is
> being cleared out in the end. Other use cases might also be in crypto
> code. [ I have put this into lib/string.c though, as it's always built-in
> and doesn't need any dependencies then. ]
> 
> Fixes kernel bugzilla: 82041
> 

What???

That's not ok.  We totally rely on memset to work.  Every single memset
that I have added was absolutely necessary.  This should be fixed
so that memset works instead of adding a work around for specific
drivers.

regards,
dan carpnter

