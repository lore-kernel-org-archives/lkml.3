Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3HGEAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 00:00:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56174 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750772Ab3HGEAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 00:00:16 -0400
Message-ID: <1375848013.2424.71.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Better --fix of SPACING errors.
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phil Carmody <phil.carmody@partner.samsung.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        devel <devel@linuxdriverproject.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Date: Tue, 06 Aug 2013 21:00:13 -0700
In-Reply-To: <55837ac7d8f48eb8dc9060f1b705c9c8b01bea59.1375843905.git.joe@perches.com>
References: <55837ac7d8f48eb8dc9060f1b705c9c8b01bea59.1375843905.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 19:55 -0700, Joe Perches wrote:
> Previous attempt at fixing SPACING errors could
> make a hash of several defects.

I have run this against drivers/staging/...

It works rather better than the older version.

It does have an issue with c99 style comments
when it needs to rewrite spacing as well.

If you use this with -f, please convert the
c99 // comments to /* ... */ first using the
--types c99_comments option,

Maybe use:

$ ./scripts/checkpatch.pl -f --fix --types=c99_comments <file>
$ mv <file>.EXPERIMENTAL-checkpatch-fixes <file>
$ ./scripts/checkpatch.pl -f --fix --types=spacing <file>
$ mv <file>.EXPERIMENTAL-checkpatch-fixes <file>
$ git diff <file>


