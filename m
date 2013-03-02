Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3CBAV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 19:21:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3CBAVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 19:21:54 -0500
Date: Fri, 1 Mar 2013 21:07:25 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v12 rebased 2/8] start vm after resetting it
Message-ID: <20130302000725.GB25309@amt.cnet>
References: <cover.1358920534.git.hutao@cn.fujitsu.com>
 <19fae3171e31ae90c208895d90ad912291936794.1358920534.git.hutao@cn.fujitsu.com>
 <20130208015028.GC3364@amt.cnet>
 <20130220081348.GC23246@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220081348.GC23246@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 04:13:49PM +0800, Hu Tao wrote:
> On Thu, Feb 07, 2013 at 11:50:28PM -0200, Marcelo Tosatti wrote:
> > On Wed, Jan 23, 2013 at 03:19:23PM +0800, Hu Tao wrote:
> > > From: Wen Congyang <wency@cn.fujitsu.com>
> > > 
> > > The guest should run after resetting it, but it does not run if its
> > > old state is RUN_STATE_INTERNAL_ERROR or RUN_STATE_PAUSED.
> > > 
> > > We don't set runstate to RUN_STATE_PAUSED when resetting the guest,
> > > so the runstate will be changed from RUN_STATE_INTERNAL_ERROR or
> > > RUN_STATE_PAUSED to RUN_STATE_RUNNING(not RUN_STATE_PAUSED).
> > 
> > It appears the last hunk will automatically reset state from 
> > RUN_STATE_INTERNAL_ERROR to RUN_STATE_RUNNING ?
> 
> Yes.
> 
> > 
> > I suppose the transition table allows, from RUN_STATE_INTERNAL_ERROR:
> > 
> > <monitor> system_reset
> > <monitor> cont
> > 
> > To resume the machine?
> 
> True.
> 
> I think the purpose of this patch is to always reset and _run_ the guest
> by `system_reset', avoiding an additional `cont' following `system_reset'.

Unclear why its essential to the feature being proposed?

