Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3KLIzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:55:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3KLIzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:55:41 -0500
Message-ID: <5281ED01.5020204@redhat.com>
Date: Tue, 12 Nov 2013 09:55:29 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the random tree with the net-next
 tree
References: <20131112155549.c160273993147244ed6bc81d@canb.auug.org.au>
In-Reply-To: <20131112155549.c160273993147244ed6bc81d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 11/12/2013 05:55 AM, Stephen Rothwell wrote:
> Hi Ted,
>
> Today's linux-next merge of the random tree got a conflict in
> drivers/char/random.c between commit 0244ad004a54 ("random32: add
> prandom_reseed_late() and call when nonblocking pool becomes
> initialized") from the net-next tree and commit 301f0595c0e7 ("random:
> printk notifications for urandom pool initialization") from the random
> tree.
>
> I fixed it up (probably not properly - see below) and can carry the fix
> as necessary (no action is required).

As per Hannes' suggestion, the result should look like (see cover
letter in [1]):

if (r->entropy_total > 128) {
	r->initialized = 1;
	r->entropy_total = 0;
	if (r == &nonblocking_pool) {
		prandom_reseed_late();
		pr_notice("random: %s pool is initialized\n",
			  r->name);
	}
}

Cheers,

Daniel

  [1] http://thread.gmane.org/gmane.linux.network/290303
