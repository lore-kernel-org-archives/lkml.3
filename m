Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbbAFW7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:59:43 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:34105 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbbAFW7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:59:41 -0500
Date: Wed, 7 Jan 2015 09:59:32 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giel van Schijndel <me@mortis.eu>
Cc: linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
        "open list:COMMON INTERNET F..." <linux-cifs@vger.kernel.org>,
        "moderated list:COMMON INTERNET F..." 
	<samba-technical@lists.samba.org>
Subject: Re: [PATCH RESEND] cifs: use memzero_explicit to clear stack buffer
Message-ID: <20150106225931.GA23281@gondor.apana.org.au>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
 <1420580220-6276-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420580220-6276-1-git-send-email-me@mortis.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:37:00PM +0100, Giel van Schijndel wrote:
> When leaving a function use memzero_explicit instead of memset(0) to
> clear stack allocated buffers. memset(0) may be optimized away.
> 
> This particular buffer is highly likely to contain sensitive data which
> we shouldn't leak (it's named 'passwd' after all).
> 
> Signed-off-by: Giel van Schijndel <me@mortis.eu>
> Reported-at: http://www.viva64.com/en/b/0299/
> Reported-by: Andrey Karpov
> Reported-by: Svyatoslav Razmyslov

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
