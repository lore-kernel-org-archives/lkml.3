Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaIEXV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:21:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:60882 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaIEXVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:21:54 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] bluetooth: LLVMLinux: Remove VLAIS from bluetooth/amp.c
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1409958214-5651-1-git-send-email-behanw@converseincode.com>
Date: Fri, 5 Sep 2014 16:22:16 -0700
Cc: "David S. Miller" <davem@davemloft.net>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Charlebois <charlebm@gmail.com>,
        =?iso-8859-1?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <DBC61EBD-5FDE-48FE-8FD1-CA4F606C22F6@holtmann.org>
References: <1409958214-5651-1-git-send-email-behanw@converseincode.com>
To: behanw@converseincode.com
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Behan,

> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This patch allocates the appropriate amount of memory
> using an char array.
> 
> The new code can be compiled with both gcc and clang.
> 
> struct shash_desc contains a flexible array member member ctx declared with
> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
> of the array declared after struct shash_desc with long long.
> 
> No trailing padding is required because it is not a struct type that can
> be used in an array.
> 
> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
> as would be the case for a struct containing a member with
> CRYPTO_MINALIGN_ATTR.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> ---
> net/bluetooth/amp.c | 13 ++++++-------
> 1 file changed, 6 insertions(+), 7 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

