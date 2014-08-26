Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbaHZVhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:37:42 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:41695 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbaHZVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:37:39 -0400
Date: Tue, 26 Aug 2014 17:37:35 -0400
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
Message-ID: <20140826213735.GS31659@mtj.dyndns.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org>
 <20140821222212.GA7996@mtj.dyndns.org>
 <alpine.DEB.2.11.1408212001100.19762@gentwo.org>
 <20140822164051.GB15713@mtj.dyndns.org>
 <alpine.DEB.2.11.1408221241340.23099@gentwo.org>
 <20140823171416.GG13540@mtj.dyndns.org>
 <alpine.DEB.2.11.1408231500430.31459@gentwo.org>
 <alpine.DEB.2.11.1408261631350.8819@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408261631350.8819@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 26, 2014 at 04:33:28PM -0500, Christoph Lameter wrote:
> Ok I tried to change it to an inline function. The problem is the
> cpumask.h is included very early. this_cpu ops require functionality
> that is not available at that point. I think it cannot be more than a
> macro unless we define it elsewhere.

Ugh.... include hell. :( Does putting the accessors in percpu.h make
any difference?  Given the tricky nature of cpumask_var_t, I think
type checking can be pretty useful.

> Regarding naming:
> 
> this_cpu_ptr_cpumask_var()
> 
> is ok?

Wouldn't this_cpu_cpumask_var_ptr() be a bit more natural?

Thanks.

-- 
tejun
