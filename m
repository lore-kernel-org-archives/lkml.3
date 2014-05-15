Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaEOHLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:11:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64957 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaEOHLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:11:21 -0400
Message-ID: <1400137877.5175.147.camel@marge.simpson.net>
Subject: Re: [cgroup] a0f9ec1f181: -4.3% will-it-scale.per_thread_ops
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Date: Thu, 15 May 2014 09:11:17 +0200
In-Reply-To: <20140515061422.GC5539@mtj.dyndns.org>
References: <5374479F.3050507@intel.com>
	 <20140515045517.GC3825@htj.dyndns.org> <20140515060026.GA12710@localhost>
	 <20140515061422.GC5539@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 02:14 -0400, Tejun Heo wrote:

> Hmmm... I'm completely stumped.  The commit in question has nothing to
> do with tmpfs.  It only affects three cgroup files - "tasks",
> "cgroup.procs" and "release_agent".  It can't possibly have any effect
> on tmpfs operation.  Maybe random effect through code alignment?  Even
> that is highly unlikely.

Unlikely, but it happens.  I bisected a tbench regression down to a
completely unrelated driver change, and watched it repeatably drop
throughput 5% despite skeptical "No way, show me that trick again".

-Mike

