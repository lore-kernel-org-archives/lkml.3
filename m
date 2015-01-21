Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbbAUQbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:31:21 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37397 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbbAUQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:31:13 -0500
Date: Wed, 21 Jan 2015 08:31:07 -0800
From: josh@joshtriplett.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Iulia Manda <iulia.manda21@gmail.com>, serge.hallyn@canonical.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, mhocko@suse.cz
Subject: Re: [PATCH] kernel: Conditionally support non-root users, groups
 and capabilities
Message-ID: <20150121163107.GA19618@cloud>
References: <20150120233308.GA6256@winterfell>
 <20150121145219.446d360c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121145219.446d360c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 02:52:19PM +0000, One Thousand Gnomes wrote:
> The proposed patch generates a whole mass of ifdefs all over the place.
> If it's going to be done move all the functions in question together
> somewhere logical and give them a single ifdef or a file of their own.

I assume the header-file ifdefs are not problematic.  The functions in
kernel/sys.c are already grouped together in a single block and needed
only one ifdef.  So I'd assume the main problem is the multiple ifdefs
in capability.c and groups.c?  Might be possible to consolidate those,
sure.

> It also doesn't appear to be dropping all it should - why can't you
> simply not compile in groups.c for example ? If you can't then it says
> the patch is far from complete at this point.

Making groups.c entirely optional has been on the todo list for a while;
it's rather harder than just dropping the syscalls, as some of its
other functions are exported to the rest of the kernel as well, but it's
doable.

- Josh Triplett
