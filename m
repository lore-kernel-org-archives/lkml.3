Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937031Ab3DKBHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:07:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40406 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934952Ab3DKBHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:07:18 -0400
Message-ID: <1365642437.2036.5.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Date: Wed, 10 Apr 2013 18:07:17 -0700
In-Reply-To: <20130410155751.7ecc6738d616fb8771991ce1@linux-foundation.org>
References: <1365563834.27174.12.camel@joe-AO722>
	 <20130410155751.7ecc6738d616fb8771991ce1@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 15:57 -0700, Andrew Morton wrote:
> On Tue, 09 Apr 2013 20:17:14 -0700 Joe Perches <joe@perches.com> wrote:
> > Comparisons of A to true and false are better written
> > as A and !A.
> > Bleat a message on use.
> hm.  I'm counting around 1,100 instances of "== true" and "== false".

And about all of them in are staging, where I think they
really should be fixed.

$ find . -maxdepth 2 -type d \
   while read file ; do \
      echo "$(git grep -E '(==|\!=)\s*(true|false)' $file | wc -l)  $file"; \
  done | sort -rn | head -10
1375 .
1298 ./drivers
1055 ./drivers/staging
63 ./drivers/net
59 ./drivers/gpu
24 ./net
20 ./drivers/media
17 ./net/nfc
13 ./fs
11 ./drivers/usb

> That's a lot of people to shout at.

Not really.

>  Is it really worthwhile? 

I think so.


