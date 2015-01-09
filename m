Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbbAINHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:07:44 -0500
Received: from cirse-out.extra.cea.fr ([132.167.192.142]:50263 "EHLO
	cirse-out.extra.cea.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019AbbAINHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:07:41 -0500
Date: Fri, 9 Jan 2015 14:07:23 +0100
From: Dominique Martinet <dominique.martinet@cea.fr>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        <v9fs-developer@lists.sourceforge.net>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/9p: Initialize status in v9fs_file_do_lock.
Message-ID: <20150109130723.GA3183@u-isr-ctg-01>
References: <1420804567-15371-1-git-send-email-dominique.martinet@cea.fr>
 <20150109123353.GA24928@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20150109123353.GA24928@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote on Fri, Jan 09, 2015 at 02:33:53PM +0200:
> On Fri, Jan 09, 2015 at 12:56:07PM +0100, Dominique Martinet wrote:
> > If p9_client_lock_dotl returns an error, status is possibly never filled
> > but will be used in the following switch.
> > Initializing it to P9_LOCK_ERROR makes sur we will return an error and
> > cleanup (and not hit the default case).
> 
> That's what my patch[1] fixes.
> 
> http://marc.info/?i=1419858019-116944-1-git-send-email-kirill.shutemov%40linux.intel.com

Actually, it's slightly different and still worth adding (mine if we
apply your's first and your's if we apply mine first - don't think
they'll conflict. I even reworded the (too old!) commit message to fit
with your patch :))

Your patch will not BUG() if status is junk, BUT if status uninitialized
value is 0 and p9_client_lock_dotl then we'll return res=0 (success) and
not unlock before returning. My patch makes sure we'll return -ENOLCK.

Likewise, if we only apply my patch then a rogue server could BUG() a
client, so we want your's anyway.

-- 
Dominique Martinet,
CEA

