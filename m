Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaDGScl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:32:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:26218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbaDGScj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:32:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,811,1389772800"; 
   d="scan'208";a="488703384"
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kara <jack@suse.cz>
Cc: Daniel J Blueman <daniel@numascale.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: ext4 performance falloff
References: <533EE547.3030504@numascale.com>
	<20140404205604.GC10275@thunk.org> <533F7851.30803@numascale.com>
	<20140407141935.GA22171@quack.suse.cz>
Date: Mon, 07 Apr 2014 09:40:28 -0700
In-Reply-To: <20140407141935.GA22171@quack.suse.cz> (Jan Kara's message of
	"Mon, 7 Apr 2014 16:19:35 +0200")
Message-ID: <87bnwdjdoj.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:
>
> What we really need is a counter where we can better estimate counts
> accumulated in the percpu part of it. As the counter approaches zero, it's
> CPU overhead will have to become that of a single locked variable but when
> the value of counter is relatively high, we want it to be fast as the
> percpu one. Possibly, each CPU could "reserve" part of the value in the
> counter (by just decrementing the total value; how large that part should
> be really needs to depend to the total value of the counter and number of
> CPUs - in this regard we really differ from classical percpu couters) and
> allocate/free using that part. If CPU cannot reserve what it is asked for
> anymore, it would go and steal from parts other CPUs have accumulated,
> returning them to global pool until it can satisfy the allocation.

That's a percpu_counter() isn't it? (or cookie jar)

The MM uses similar techniques.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
