Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3FGKXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:23:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33901 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3FGKXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:23:34 -0400
Date: Fri, 7 Jun 2013 11:23:27 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: James King <james.king@linaro.org>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH] arm/dt: Don't add disabled CPUs to system topology
Message-ID: <20130607102326.GA3111@e102568-lin.cambridge.arm.com>
References: <1370538685-22386-1-git-send-email-james.king@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1370538685-22386-1-git-send-email-james.king@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 Jun 2013 10:23:30.0730 (UTC) FILETIME=[0E8F20A0:01CE6369]
X-MC-Unique: 113060711233201801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Thu, Jun 06, 2013 at 06:11:25PM +0100, James King wrote:
> If CPUs are marked as disabled in the devicetree, make sure they do
> not exist in the system CPU information and CPU topology information.
> In this case these CPUs will not be able to be added to the system later
> using hot-plug. This allows a single chip with many CPUs to be easily
> used in a variety of hardware devices where they may have different
> actual processing requirements (eg for thermal/cost reasons).
> 
> - Change devicetree.c to ignore any cpu nodes marked as disabled,
>   this effectively limits the number of active cpu cores so no need
>   for the max_cpus=x in the chosen node.
> - Change topology.c to ignore any cpu nodes marked as disabled, this
>   is where the scheduler would learn about big/LITTLE cores so this
>   effectively keeps the scheduler in sync.
> 

I have two questions:

1) Since with this approach the DT should change anyway if on different
   hardware devices based on the same chip you want to allow booting a
   different number of CPUs, why do not we remove the cpu nodes instead of
   disabling them ? Put it another way: cpu nodes define a cpu as
   possible (currently), we can simply remove the node if we do not want
   that cpu to be seen by the kernel.
2) If we go for the "status" property, why do not we use it to set present
   mask ? That way the cpu is possible but not present, you cannot
   hotplug it in. It is a bit of a stretch, granted, the cpu _is_ present,
   we just want to disable it, do not know how this is handled in x86
   and other archs though.

I am just asking, since it is something I thought about while writing
code that parses the DT cpu map, basically we do not have a way to
"disable" a cpu in the DT and that's what you are doing, I just would like
to understand the best way to put it into DT bindings.

Thanks,
Lorenzo

