Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaFMFDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:03:47 -0400
Received: from ja.ssi.bg ([178.16.129.10]:33016 "EHLO ja.home.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751167AbaFMFDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:03:45 -0400
Date: Fri, 13 Jun 2014 08:02:48 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@ja.home.ssi.bg
To: Jet Chen <jet.chen@intel.com>
cc: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [net/ipvs] BUG: unable to handle kernel NULL pointer dereference
 at 00000004
In-Reply-To: <5398148B.603@intel.com>
Message-ID: <alpine.LFD.2.11.1406130801090.1518@ja.home.ssi.bg>
References: <5397DE0E.2070501@intel.com> <alpine.LFD.2.11.1406110828460.2070@ja.home.ssi.bg> <5398148B.603@intel.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 11 Jun 2014, Jet Chen wrote:

> On 06/11/2014 01:59 PM, Julian Anastasov wrote:
> > 
> > 	At first look, it is strange but I think the reason
> > is the missing CONFIG_SYSCTL. ip_vs_control_net_cleanup
> > fails at ip_vs_stop_estimator(net, &ipvs->tot_stats)
> > because it is called not depending on CONFIG_SYSCTL but
> > without CONFIG_SYSCTL ip_vs_start_estimator was never
> > called.
> > 
> > 	Can you test such patch?
> 
> Julian, your patch works. Thanks.
> 
> Tested-by: Jet Chen <jet.chen@intel.com>

	Thanks for the confirmation!

Regards

--
Julian Anastasov <ja@ssi.bg>
