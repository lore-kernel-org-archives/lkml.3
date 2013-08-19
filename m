Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab3HSUo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:44:29 -0400
Received: from a10-13.smtp-out.amazonses.com ([54.240.10.13]:50454 "EHLO
	a10-13.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121Ab3HSUo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:44:28 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Aug 2013 16:44:28 EDT
Date: Mon, 19 Aug 2013 20:29:18 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Simon Kirby <sim@hostway.ca>
cc: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
In-Reply-To: <20130819201717.GA23608@hostway.ca>
Message-ID: <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
References: <20130706000949.GD16853@hostway.ca> <CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com> <20130819201717.GA23608@hostway.ca>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.19-54.240.10.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013, Simon Kirby wrote:

> Object ffff880090f19e78: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk

This looks like an increment after free in the second 32 bit value of the
structure. First 32 bit value's poison is unchanged.

> CONFIG_EFENCE? :)

I think the developers should have enough information now to fix the
issue. Find the struct definition. Look for the second 32 bit value and
find out where that value is incremented.

