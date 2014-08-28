Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaH1NCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:02:18 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:54534 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaH1NCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:02:17 -0400
Date: Thu, 28 Aug 2014 09:02:13 -0400
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
Message-ID: <20140828130213.GD29737@htj.dyndns.org>
References: <20140821222212.GA7996@mtj.dyndns.org>
 <alpine.DEB.2.11.1408212001100.19762@gentwo.org>
 <20140822164051.GB15713@mtj.dyndns.org>
 <alpine.DEB.2.11.1408221241340.23099@gentwo.org>
 <20140823171416.GG13540@mtj.dyndns.org>
 <alpine.DEB.2.11.1408231500430.31459@gentwo.org>
 <alpine.DEB.2.11.1408261631350.8819@gentwo.org>
 <20140826213735.GS31659@mtj.dyndns.org>
 <alpine.DEB.2.11.1408261803500.15698@gentwo.org>
 <alpine.DEB.2.11.1408261911290.22692@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408261911290.22692@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 26, 2014 at 07:12:21PM -0500, Christoph Lameter wrote:
> 
> New patch:
> 
> From: Christoph Lameter <cl@linux.com>
> Subject: __get_cpu_var/cpumask_var_t: Resolve ambiguities v2
> 
> __get_cpu_var can paper over differences in the definitions
> of cpumask_var_t and either use the address of the cpumask
> variable directly or perform a fetch of the address of the
> struct cpumask allocated elsewhere. This is important
> particularly when using per cpu cpumask_var_t declarations
> because in one case we have an offset into a per cpu area
> to handle and in the other case we need to fetch a pointer
> from the offset.
> 
> This patch introduces a new macro
> 
> this_cpu_cpumask_var_t_ptr()
> 
> that is defined where cpumask_var_t is defined and performs
> the proper actions. All use cases where __get_cpu_var
> is used with cpumask_var_t are converted to the use
> of this_cpu_cpumask_var_t_ptr().
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Rusty, if this looks okay to you, I'll route this through
percpu/for-3.18-consistent-ops branch.

Thanks.

-- 
tejun
