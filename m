Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaDYHd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:33:28 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:38795 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaDYHd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:33:27 -0400
Date: Fri, 25 Apr 2014 09:33:25 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>,
        "naresh.kamboju@linaro.org Kamboju" <naresh.kamboju@linaro.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: deadlock in ipv6?
Message-ID: <20140425073325.GA7050@order.stressinduktion.org>
Mail-Followup-To: Alex Shi <alex.shi@linaro.org>,
	John Stultz <john.stultz@linaro.org>,
	"naresh.kamboju@linaro.org Kamboju" <naresh.kamboju@linaro.org>,
	davem@davemloft.net, netdev@vger.kernel.org,
	Mark Brown <broonie@linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>
References: <535A0950.9090302@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <535A0950.9090302@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 03:05:52PM +0800, Alex Shi wrote:
> [   18.624755]        CPU0
> 
> [   18.627349]        ----
> 
> [   18.629943]   lock(&addrconf_stats->syncp.seq);
> 
> [   18.634735]   <Interrupt>
> 
> [   18.637512]     lock(&addrconf_stats->syncp.seq);
> 

Stable kernel should already carry a fix for this, 43a43b6040165f7
("ipv6: some ipv6 statistic counters failed to disable bh"). Could you give it
a try?

Bye,

  Hannes

