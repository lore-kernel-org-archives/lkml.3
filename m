Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953Ab3DBCYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:24:39 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:61810 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab3DBCYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:24:37 -0400
Date: Mon, 1 Apr 2013 19:24:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 tj/for-3.10] workqueue: add wq->freezing and remove
 POOL_FREEZING
Message-ID: <20130402022431.GA6255@htj.dyndns.org>
References: <1364660955-5217-1-git-send-email-laijs@cn.fujitsu.com>
 <20130401184402.GA31435@htj.dyndns.org>
 <515A3FBD.3080509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515A3FBD.3080509@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Apr 02, 2013 at 10:17:33AM +0800, Lai Jiangshan wrote:
> ->flags is hot and almost read-only(except __WQ_DRAINING).
> __WQ_DRAINING bit is accessed for every queue_work(), so we add it to hot ->flags.
> 
> __WQ_ORDERED is read-only.
> 
> ->freezing is cold and non-read-only.
> I don't think we need to add __WQ_FREEZING to ->flags.

Hmm... I'm not following.  If you have multiple hot flags which may be
used from different CPUs, yeah, you may want to put them in separate
cachelines but cold flags don't really matter either way so why put it
in a separate field?  Can you please elaborate?

Thanks.

-- 
tejun
