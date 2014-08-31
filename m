Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaHaKOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 06:14:10 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:52730 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaHaKOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 06:14:02 -0400
Date: Sun, 31 Aug 2014 06:13:58 -0400
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, falcon@meizu.com,
        tiwai@suse.de, arjan@linux.intel.com, linux-kernel@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831101358.GB19853@htj.dyndns.org>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Luis.

I haven't followed the previous discussions so please let me know if
this has been discussed before.  It looks like you're trying to extend
the async mechanism and applying them to init functions themselves.
That sounds kinda weird to me.  Isn't the root cause of the problem
doing device probings along with driver initilaization on module load?

Wouldn't it be more logical to simply make bus_add_driver() ->
driver_attach() invocation asynchronous?  There's no reason to make
them parallel either.  We can use an ordered queue for it so that we
don't lose the probing order we used to have.  Making things go
parallel is the responsibility of each probing function after all and
there isn't much to gain by making attach calls go parallel.

Thanks.

-- 
tejun
