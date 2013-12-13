Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3LMSwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:52:44 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:64420 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3LMSwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:52:43 -0500
Date: Fri, 13 Dec 2013 13:52:37 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: tomaz.solc@tablix.org, aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131213185237.GD27070@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213174932.GA27070@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:49:32PM -0500, Tejun Heo wrote:
> I'm not completely sure what to do.  We can make an exception for
> bdi_wq and thaw it early but that breaks the guarantee that bdi is
> frozen between device suspend and resume invocations and we might as
> well just remove WQ_FREEZABLE from it.  I don't know.

Ugh, so I removed WQ_FREEZABLE on bdi and the same deadlock now
happens through jbd2 which is a freezable kthread.  This whole kthread
freezer thing is rotten and fundamentally broken. :(

-- 
tejun
