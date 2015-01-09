Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbbAINaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:30:12 -0500
Received: from sainfoin-out.extra.cea.fr ([132.167.192.145]:36150 "EHLO
	sainfoin-out.extra.cea.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbbAINaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:30:11 -0500
Date: Fri, 9 Jan 2015 14:29:53 +0100
From: Dominique Martinet <dominique.martinet@cea.fr>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        <v9fs-developer@lists.sourceforge.net>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/9p: Initialize status in v9fs_file_do_lock.
Message-ID: <20150109132953.GA10543@u-isr-ctg-01>
References: <1420804567-15371-1-git-send-email-dominique.martinet@cea.fr>
 <20150109123353.GA24928@node.dhcp.inet.fi>
 <20150109130723.GA3183@u-isr-ctg-01>
 <20150109132051.GB24928@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20150109132051.GB24928@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote on Fri, Jan 09, 2015 at 03:20:51PM +0200:
> > Your patch will not BUG() if status is junk, BUT if status uninitialized
> > value is 0 and p9_client_lock_dotl then we'll return res=0 (success) and
> > not unlock before returning. My patch makes sure we'll return -ENOLCK.
> 
> No, if p9_client_lock_dotl() return 0 it must set status. If it's not,
> that's bug on p9_client_lock_dotl() side and must be fixed.

I had that bit right, but I only remembered your second patch -- sorry.

It should be fine with your patchES, please disregard this one.

-- 
Dominique Martinet,
CEA
