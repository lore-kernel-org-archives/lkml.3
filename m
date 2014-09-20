Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbaITF0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 01:26:43 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:35439 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbaITF0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 01:26:42 -0400
Date: Sat, 20 Sep 2014 01:26:38 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] percpu-refcount: implement percpu_ref_set_killed()
Message-ID: <20140920052638.GA7926@mtj.dyndns.org>
References: <1410142342-8185-1-git-send-email-tj@kernel.org>
 <1410142342-8185-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410142342-8185-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:12:21AM +0900, Tejun Heo wrote:
> With the recent addition of percpu_ref_reinit(), percpu_ref now can be
> used as a persistent switch which can be turned on and off repeatedly
> where turning off maps to killing the ref and waiting for it to drain;
> however, there currently isn't a way to initialize a percpu_ref in its
> off (killed and drained) state, which can be inconvenient for certain
> persistent switch use cases.
> 
> This patch adds percpu_ref_set_killed() which forces the percpu_ref
> into its killed and drained state.  The caller is responsible for
> ensuring that no one else is using the ref.  This can be used to force
> the percpu_ref into its off state after initialization.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>

This turned out to be too limited.  Dropping this one.

Thanks.

-- 
tejun
