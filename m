Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3LSPly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:41:54 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:56166 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab3LSPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:41:52 -0500
Date: Thu, 19 Dec 2013 09:41:50 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: bad page state in 3.13-rc4
In-Reply-To: <CA+55aFwweoGs3eGWXFULcqnbRbpDhpj2qrefXB5OpQOiWW8wYA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1312190930190.4238@nuc>
References: <20131219040738.GA10316@redhat.com> <CA+55aFwweoGs3eGWXFULcqnbRbpDhpj2qrefXB5OpQOiWW8wYA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Linus Torvalds wrote:

> Somebody who knows the migration code needs to look at this. ChristophL?

Its been awhile sorry and there has been a huge amount of work done on top
of my earlier work. Cannot debug that anymore and I am finding myself in
the role of the old guy who just complains a lot. Some of that
functionality seems bizarre to me like the on the fly conversion between
huge pages and regular pages, weird and complex page count handling etc
etc.

The last time I looked at the code I was horrified to find that the new
huge page migration does not use migration ptes to create a cooldown phase
but directly swaps the pmd. That used to cause huge problems with regular
pages in the past. But I was told that was all safe. Mel?
