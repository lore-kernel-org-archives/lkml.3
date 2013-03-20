Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3CTPGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:06:03 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62957 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3CTPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:06:00 -0400
X-Greylist: delayed 1015 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 11:06:00 EDT
Date: Wed, 20 Mar 2013 08:05:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 09/10] workqueue: implement NUMA affinity for unbound
 workqueues
Message-ID: <20130320150554.GX3042@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
 <1363737629-16745-10-git-send-email-tj@kernel.org>
 <CACvQF51hz_H72zVTt4R=P84RDxat+WTe-Ehw8Zbj0cjifNt4ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF51hz_H72zVTt4R=P84RDxat+WTe-Ehw8Zbj0cjifNt4ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:03:53PM +0800, Lai Jiangshan wrote:
> > +enomem:
> > +       free_workqueue_attrs(tmp_attrs);
> > +       if (pwq_tbl) {
> > +               for_each_node(node)
> > +                       kfree(pwq_tbl[node]);
> 
> It will free the dfl_pwq multi times.

Oops, you're right.  We need to do


	for_eahc_node(node)
		if (pwq_tbl[node] != dfl_pwq)
			kfree(pwq_tbl[node]);
	kfree(dfl_pwq);

Thanks!

-- 
tejun
