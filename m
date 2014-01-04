Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbaADSzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:55:45 -0500
Received: from blu0-omc1-s14.blu0.hotmail.com ([65.55.116.25]:39354 "EHLO
	blu0-omc1-s14.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbaADSzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:55:44 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jan 2014 13:55:44 EST
X-TMN: [BHOs/NStrqFxQhdATYolOw6YYfW5kxu1]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP390C5C965F9A4FB18F1EBE97B50@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: Mikulas Patocka <mpatocka@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com>
Subject: Re: [PATCH] fix crash when using XFS on loopback
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sat, 4 Jan 2014 13:48:19 -0500
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@iki.fi>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 04 Jan 2014 18:48:35.0790 (UTC) FILETIME=[92F18EE0:01CF097D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4-Jan-14, at 12:45 PM, Mikulas Patocka wrote:

> * flush_dcache_page asks for the list of userspace mappings, however  
> that
>  page->mapping field is reused by the slab subsystem for a different
>  purpose. This causes the crash.

I'd noticed the other day that the parisc implementation of  
flush_dcache_page()
should return if "!mapping || mapping != page->mapping" is true.  This  
would
have avoided crash.

Dave
--
John David Anglin	dave.anglin@bell.net



