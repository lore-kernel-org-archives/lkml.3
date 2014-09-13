Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaIMEqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 00:46:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55160 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaIMEqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 00:46:37 -0400
Date: Sat, 13 Sep 2014 13:46:30 +0900
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20140913044630.GB30477@mtj.dyndns.org>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
 <20140911124248.GA18490@dhcp-27-160.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911124248.GA18490@dhcp-27-160.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 11, 2014 at 02:42:49PM +0200, Alexander Gordeev wrote:
> As conversion of libata to blk mq has long done I tried the change

Hmmm?  You mean scsi-mq?

> against the recent version and the results still appear worthwhile.
> 
> The numbers are taken by running 'dd if=/dev/sd{a,b} of=/dev/null'
> in parallel. All time values are in us.
> 
> Before this update host lock average holdtime was 2.45 and
> average waittime was 1.24. After the update average holdtime
> dropped to 0.29 (about eight times) while average waittime
> decreased to 0.58 (about two times).
> 
> Also, port events are handled with local interrupts enabled
> and compete on individual per-port locks with average holdtime
> 1.25 and average waittime 1.48. So combined average holdtime
> spent while holding host and port locks decreased from 2.45 to
> 0.29 + 1.25 = 1.54 (about 1.6 times).
> 
> The downside of this change is introduction of a kernel thread.

That shouldn't matter at all but can you please present the
information in a more digestable form?  e.g. CPU usage decreased from
A to B when transferring N MB/s on certain setup.

Thanks.

-- 
tejun
