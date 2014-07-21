Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaGUAet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 20:34:49 -0400
Received: from goedel.dlitz.net ([64.5.53.201]:46818 "EHLO goedel.dlitz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbaGUAer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 20:34:47 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2014 20:34:46 EDT
Date: Sun, 20 Jul 2014 17:25:40 -0700
From: Dwayne Litzenberger <dlitz@dlitz.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140721002540.GA20595@rivest.lan>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
 <20140717170115.GO1491@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140717170115.GO1491@thunk.org>
X-Homepage: https://www.dlitz.net/
X-OpenPGP: url=https://www.dlitz.net/go/gpgkey/;
 id=19E11FE8B3CFF273ED174A24928CEC1339C25CF7; preference=signencrypt
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 01:01:16PM -0400, Theodore Ts'o wrote:
>The getrandom(2) system call is a superset of getentropy(2).  When we
>add the support for this into glibc, it won't be terribly difficult
>nor annoying to drop the following in alongside the standard support
>needed for any new system call:
>
>int getentropy(void *buf, size_t buflen)
>{
>	int	ret;
>
>	ret = getentropy(buf, buflen, 0);
>	return (ret > 0) ? 0 : ret;
>}
>
>The reason for the additional flags is that I'm trying to solve more
>problems than just getentropy()'s raison d'etre.  The discussion of
>this is in the commit description; let me know if there bits that I
>could make clearer.

This could still return predictable bytes during early boot, though, 
right?

-- 
Dwayne C. Litzenberger <dlitz@dlitz.net>
 OpenPGP: 19E1 1FE8 B3CF F273 ED17  4A24 928C EC13 39C2 5CF7
