Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab3GaK15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:27:57 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:61694 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3GaK14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:27:56 -0400
Date: Wed, 31 Jul 2013 06:27:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch]workqueue: copy attr with all fields.
Message-ID: <20130731102752.GD2810@htj.dyndns.org>
References: <20130729062412.GA6448@kernel.org>
 <20130729111401.GA20951@mtj.dyndns.org>
 <20130729125259.GA9306@kernel.org>
 <20130729153523.GA22605@mtj.dyndns.org>
 <20130730054955.GA5225@kernel.org>
 <20130730141419.GG12016@htj.dyndns.org>
 <20130731013929.GB1504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731013929.GB1504@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 31, 2013 at 09:39:29AM +0800, Shaohua Li wrote:
> Hmm, I didn't agree it's more confusing to change copy_workqueue_attrs(), the

We're talking past each other.  I'm not saying copy_workqueue_attrs()
shouldn't copy no_numa.  I'm saying get_unbound_pool() should clear
no_numa so that pools don't have random no_numa settings.

> name of the function suggests it is a 'copy'. And clearing no_numa in
> apply_workqueue_attrs() after copy_workqueue_attrs() looks like a hack to me.

Why would apply_workqueue_attrs() modify no_numa when it *is* dealing
with an actual workqueue attr.  I've been talking about
get_unbound_pool() not apply_workqueue_attrs() the whole time.

> But it depends on you, feel free to fix it by yourself.

Please update the patch to add no_numa clearing to get_unbound_pool()
and explain what's going on.

Thanks.

-- 
tejun
