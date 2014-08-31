Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaHaLFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:05:32 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64325 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaHaLF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:05:29 -0400
Date: Sun, 31 Aug 2014 07:05:26 -0400
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, falcon@meizu.com,
        tiwai@suse.de, arjan@linux.intel.com, linux-kernel@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831110526.GE19853@htj.dyndns.org>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <20140831101358.GB19853@htj.dyndns.org>
 <20140831110200.GC19853@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831110200.GC19853@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 07:02:00AM -0400, Tejun Heo wrote:
> So, something like the following.  A couple things to note
> 
> * driver_attach() can never fail but is marked with __must_check.  We
>   prolly should change it to void.
> 
> * Old/weird userspace which depends on insmod to wait for device
>   probing might choke and the new behavior might need to be switched
>   somehow (sysctl, insmod param or whatever).

One more thing.

* Use of ordered workqueue probably isn't necessary and using
  system_unbound_wq should be fine.

Thanks.

-- 
tejun
