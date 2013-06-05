Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3FEHYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:24:45 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36795 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab3FEHYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:24:44 -0400
Date: Wed, 5 Jun 2013 00:24:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: remove the unused helper in .h
Message-ID: <20130605072441.GD7303@mtj.dyndns.org>
References: <51AEE452.8080605@linux.vnet.ibm.com>
 <51AEE48C.7010400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AEE48C.7010400@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:11:08PM +0800, Michael Wang wrote:
> __cancel_delayed_work(), flush_work_sync() and flush_delayed_work_sync()
> are no longer used by anyone, just remove them.

These are deprecated interfaces which used to be necessary because
they functioned differently.  Keeping them around is mostly a courtesy
to out-of-tree developers as workqueue tends to be used by a lot of
them too.  The patch description is rather misleading, system_nrt_*wq
should be removed together, and I kinda wanna keep them for one more
cycle, so no cookie for this one either.

Thanks.

-- 
tejun
