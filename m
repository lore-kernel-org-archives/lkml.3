Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3GVEGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 00:06:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60733 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3GVEGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 00:06:05 -0400
Date: Mon, 22 Jul 2013 05:06:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Message-ID: <20130722040601.GK4165@ZenIV.linux.org.uk>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
 <20130722012517.GD11674@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722012517.GD11674@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 11:25:17AM +1000, Dave Chinner wrote:

> I'll just point out that it can make the whole thing worse, too.
> For example, for ext3/4, the tmpfile being created has to be added
> to the orphan inode list which is protected by a filesystem global
> mutex. Hence scalability of O_TMPFILE is massively limited on
> ext3/ext4 due to architectural issues within ext3/4. Other
> filesystems will be more efficient, but because they have more
> scalable/complex orphan inode handling it's going to take longer to
> implement O_TMPFILE support for them....

Um...  You do realize that the same architectural issues there will
create exactly the same serialization when you are unlinking the
sucker?  I.e. with the "pick the name, create and open, unlink" sequence
ext[34] will insert that inode into the same orphan list, creating
the same contention...
