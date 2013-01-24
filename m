Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3AXKeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:34:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab3AXKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:34:35 -0500
Message-ID: <1359023666.5833.105.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Thu, 24 Jan 2013 11:34:26 +0100
In-Reply-To: <5100FE61.1030004@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
	 <1358841795.5782.255.camel@marge.simpson.net>
	 <50FE5433.1070801@linux.vnet.ibm.com>
	 <1358865692.5782.420.camel@marge.simpson.net>
	 <50FF4EA0.1070000@linux.vnet.ibm.com>
	 <1358915494.5752.46.camel@marge.simpson.net>
	 <50FF7086.4020509@linux.vnet.ibm.com>
	 <1358922520.5752.91.camel@marge.simpson.net>
	 <50FF8CD8.4060105@linux.vnet.ibm.com>
	 <1358929257.5752.109.camel@marge.simp! son.net>
	 <50FF9F92.60202@linux.vnet.ibm.com>
	 <1358930968.5752.123.camel@marge.simpson.net>
	 <50FFA695.6010407@linux.vnet.ibm.com>
	 <1358932694.5752.126.camel@marge.simpson.net>
	 <1358933555.5752.132.camel@marge.simpson.net>
	 <5100CE1F.7080704@linux.vnet.ibm.com>
	 <1359010272.5833.39.camel@marge.simpson.net>
	 <5100DF95.3020909@linux.vnet.ibm.com>
	 <1359013623.5833.52.camel@marge.simpson.net>
	 <5100ED7A.303@linux.vnet.ibm.com>
	 <1359018455.5833.64.camel@marge.simpson.net>
	 <5100FE61.1030004@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:CnRECuitLYno6xXlo1cwJjm4VVkg3fEpTsZYq4wyoPT
 v7Kmh66KE7qYa60B0EshIjj5WvVofNnGaKLs/jh38pS9iKPTRx
 hUlEP2pcGS6vVyJ20qFRu514l0CCongfzamCfbMkPV4WeUmwL7
 qQxRRrfWYHiEornJMn3/e2XzUaPmfHaRroxiW5qzyys88x8lxR
 OHFW2cdbdhRXHU+NofmpRTWqJhjDX05DwrtX6Ms+49qREmKPTv
 MdVrIL1ENKvsSYXGfjW8GTxh7oAA6np+8dcQ+UYjXnWJN1IRz8
 m8VO74K6DxuQyXPMFrXmw8iKempXhTPflTRpz0nx426jKlScrh
 CvvqxMOMny15Fd3/rfHKWt9OqUcSBMWcPZHdkgJx/bZUFw7ulA
 Ab0cRzYaU+zSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 17:26 +0800, Michael Wang wrote: 
> On 01/24/2013 05:07 PM, Mike Galbraith wrote:
> > On Thu, 2013-01-24 at 16:14 +0800, Michael Wang wrote:
> > 
> >> Now it's time to work on v3 I think, let's see what we could get this time.
> > 
> > Maybe v3 can try to not waste so much ram on affine map?
> 
> Yeah, that has been a question in my mind at very beginning, but how...

Allocate at domain build time the max we can acquire via hotplug?
> > Even better would be if it could just go away, along with relic of the
> > bad old days wake_affine(), and we make the balance path so damn light
> > but clever that select_idle_sibling() can go away too... and a pony ;-)
> 
> Hmm...may be, I need some consideration here, a totally balance path,
> interesting...

Unification is the right target, hitting it might not be so easy though.

> But I think we still need the clean code which sbm bring to us, do we?

Sure, if it makes things perform better.

-Mike

