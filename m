Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaFKVOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:14:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaFKVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:14:50 -0400
Message-ID: <5398C6C3.90405@canonical.com>
Date: Wed, 11 Jun 2014 16:14:43 -0500
From: Dave Chiluk <chiluk@canonical.com>
Reply-To: chiluk@canonical.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: paulmck@linux.vnet.ibm.com, Rafael Tinoco <rafael.tinoco@canonical.com>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>	<20140611133919.GZ4581@linux.vnet.ibm.com>	<CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>	<539879B8.4010204@canonical.com>	<20140611161857.GC4581@linux.vnet.ibm.com>	<53989F7B.6000004@canonical.com> <874mzr41kf.fsf@x220.int.ebiederm.org>
In-Reply-To: <874mzr41kf.fsf@x220.int.ebiederm.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 03:46 PM, Eric W. Biederman wrote:
> ip netns add also performs a bind mount so we get into all of the vfs
> level locking as well.

It's actually quite a bit worse than that as ip netns exec creates a new
mount namespace as well.  That being said, the vfs issues have been
healthily mitigated by a number of recent patches by Al Viro to
fs/namespace.c.

