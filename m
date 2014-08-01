Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaHAN64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:58:56 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:48058 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbaHAN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:58:55 -0400
Date: Fri, 1 Aug 2014 08:58:52 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Fengguang Wu <fengguang.wu@intel.com>, Tejun Heo <tj@kernel.org>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [scheduler] BUG: unable to handle kernel paging request at
 000000000000ce50
In-Reply-To: <53D9F692.2090103@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.11.1408010855380.19843@gentwo.org>
References: <20140730135616.GK16537@localhost> <53D9F692.2090103@cn.fujitsu.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Lai Jiangshan wrote:

> >     this_cpu_ptr instead.
>
>
> -	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
> +	struct cpumask *cpus = this_cpu_ptr(load_balance_mask);
>
>
> I think the conversion is wrong. it should be
> 			*this_cpu_ptr(&load_balance_mask);

Hmmm.... that is going to cause some pretty strange looking code. Would
the compiler/sparse not complain if the wrong type of pointer is assigned
to?


If we are retrieving a pointer then the right way to do things would be:

cpus = this_cpu_read(load_balance_mask);



