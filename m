Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaBUB7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:59:42 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49500 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaBUB7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:59:40 -0500
Date: Thu, 20 Feb 2014 20:59:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Message-ID: <20140221015935.GF6897@htj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-5-git-send-email-tj@kernel.org>
 <5306AF8E.3080006@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5306AF8E.3080006@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 20, 2014 at 08:44:46PM -0500, Peter Hurley wrote:
> >+static void fw_device_workfn(struct work_struct *work)
> >+{
> >+	struct fw_device *device = container_of(to_delayed_work(work),
> >+						struct fw_device, work);
> 
> I think this needs an smp_rmb() here.

The patch is equivalent transformation and the whole thing is
guaranteed to have gone through pool->lock.  No explicit rmb
necessary.

> IOW, the beginning of the work function should act like a barrier in
> the same way that queue_work_on() (et. al.) already does.

workqueue already has enough barriers; otherwise, the whole kernel
would have crumbled long time ago.

Thanks.

-- 
tejun
