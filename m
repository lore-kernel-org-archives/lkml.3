Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaCSRbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:31:39 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:53217 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750757AbaCSRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:31:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2692:2828:3138:3139:3140:3141:3142:3865:3866:3867:3871:3872:3874:5007:7652:7903:8603:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:13069:13160:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bone24_2ad6795606f51
X-Filterd-Recvd-Size: 1763
Message-ID: <1395250293.8649.51.camel@joe-AO722>
Subject: Re: [PATCH] virtio-blk: make the queue depth configurable
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 19 Mar 2014 10:31:33 -0700
In-Reply-To: <CAErSpo7rhDGX2DB1kRb4iZDLGNRGrm+sEwt6LuRsd19X5coG8Q@mail.gmail.com>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu>
	 <1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org>
	 <87y509scl3.fsf@rustcorp.com.au> <1395032434.2556.10.camel@joe-AO722>
	 <1395041214.2556.17.camel@joe-AO722> <87zjkmr8w1.fsf@rustcorp.com.au>
	 <CAErSpo7rhDGX2DB1kRb4iZDLGNRGrm+sEwt6LuRsd19X5coG8Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple more bikesheddy things:

Is there ever a reason to use a non __builtin_const_p(perms)?

Maybe that should be a BUILD_BUG_ON too
	BUILD_BUG_ON(!builtin_const_p_perms)

My brain of little size gets confused by the
	BUILD_BUG_ON_ZERO(foo) +
vs
	BUILD_BUG_ON(foo);
as it just seems like more text for the same content.

Is there any value on the "_ZERO(foo) +" I don't understand?


