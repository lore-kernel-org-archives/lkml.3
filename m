Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaBXSec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:34:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:51902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaBXSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:34:30 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 13:34:30 EST
Message-ID: <1393266333.5560.15.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
From: Mike Galbraith <bitbucket@online.de>
To: Kevin Hilman <khilman@linaro.org>
Cc: paulmck@linux.vnet.ibm.com, Tejun Heo <tj@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Date: Mon, 24 Feb 2014 19:25:33 +0100
In-Reply-To: <7hppmc2y63.fsf@paris.lan>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
	 <52F8A51F.4090909@cn.fujitsu.com>
	 <20140210184729.GL4250@linux.vnet.ibm.com>
	 <20140212182336.GD5496@localhost.localdomain>
	 <20140212190241.GD4250@linux.vnet.ibm.com>
	 <20140212192354.GC26809@htj.dyndns.org> <7hk3cx46rw.fsf@paris.lan>
	 <1392449804.5517.45.camel@marge.simpson.net>
	 <20140216164106.GD4250@linux.vnet.ibm.com>
	 <1392612613.5565.78.camel@marge.simpson.net> <7hppmc2y63.fsf@paris.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:IFtAA3nTySg2LmFDsiez8hB+BpVpyl0IqyjWSfoSez7
 ttUZmxu6aNiQx8nfV/2CxxTOkH7fCtHj9Qd5PiwnbH0tC2AdMU
 NYZ0B1k4+xVU/xqS7gLr4H0Zo1eA196V1lBxVS5EmjSd4Q3mJ6
 tZR5T173sW0GUG+nm4Q8AIab3RPynj3AdiIPVKpsbHq76PfDG9
 JOD0ZyzJBMnWpAoijUXy6aViEeQN0eP/66JD8LS9ZdOmwdGDUv
 vbx+FkybhdELeIQf8dkTWe9V/4wiDSGSp4Vsol88QbsR6lHIGc
 89B1/fgyO838vpn4zrR0Q+d+lCM+84pBRhTK4STOWqN+FveC/P
 JuqPTgPpPgk8p9kNSD+EcTZkNxcGglXjAIGrYOTuQCxZzV2Tr8
 NAnMJqtpPaKUg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 09:55 -0800, Kevin Hilman wrote:

> Yeah, my patch only addresses the nohz_full case, but since there
> doesn't seem to be any general agreemenet about the generic case, it
> seems that exposing all unbound workqueues via WQ_SYSFS is the way to
> go.  
> 
> Mike, looks like you may have started on that.  Did it get any further?

No, work gets in the way of tinker time.  Not sure which way I want to
explore anyway.  On the one hand, auto-quiesce thingy tied to domain
construction/destruction sounds good, but on the other, just handing
control to the user is highly attractive.. likely lots simpler too.

-Mike

