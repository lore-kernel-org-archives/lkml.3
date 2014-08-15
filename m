Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaHOJaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:30:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52150 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaHOJ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:29:59 -0400
Date: Fri, 15 Aug 2014 10:29:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: clm@fb.com, jbacik@fb.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v3 0/2] vfs / btrfs: add support for ustat()
Message-ID: <20140815092950.GZ18016@ZenIV.linux.org.uk>
References: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 07:58:56PM -0700, Luis R. Rodriguez wrote:

> Christoph had noted that this seemed associated to the problem
> that the btrfs uses different assignments for st_dev than s_dev,
> but much as I'd like to see that changed based on discussions so
> far its unclear if this is going to be possible unless strong
> commitment is reached.

Explain, please.  Whose commitment and commitment to what, exactly?
Having different ->st_dev values for different files on the same
fs is a bloody bad idea; why does btrfs do that at all?  If nothing else,
it breaks the usual "are those two files on the same fs?" tests...
