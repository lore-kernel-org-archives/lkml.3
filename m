Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaFICQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 22:16:21 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:58746 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753849AbaFICQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 22:16:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2693:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:8603:10004:10400:10848:11026:11232:11473:11658:11914:12114:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: self43_1918f6e09f91b
X-Filterd-Recvd-Size: 1607
Message-ID: <1402280170.9150.1.camel@joe-AO725>
Subject: Re: [PATCH v2] drivers/base: Fix length checks in
 create_syslog_header()/dev_vprintk_emit()
From: Joe Perches <joe@perches.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>
Date: Sun, 08 Jun 2014 19:16:10 -0700
In-Reply-To: <1402267903.23860.45.camel@deadeye.wl.decadent.org.uk>
References: <1402267903.23860.45.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-08 at 23:51 +0100, Ben Hutchings wrote:
> snprintf() returns the number of bytes that could have been written
> (excluding the null), not the actual number of bytes written.  Given a
> long enough subsystem or device name, these functions will advance
> beyond the end of the on-stack buffer in dev_vprintk_exit(), resulting
> in an information leak or stack corruption.  I don't know whether such
> a long name is currently possible.
> In case snprintf() returns a value >= the buffer size, do not add
> structured logging information.

I believe this is guaranteed to be < 128, but
I also suppose it'd be better to emit whatever
buffer is < 128 and add a WARN_ON_ONCE instead.


