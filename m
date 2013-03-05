Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab3CED04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:26:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65404 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759092Ab3CED0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:26:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,784,1355068800"; 
   d="scan'208";a="6812619"
Date: Tue, 5 Mar 2013 11:06:23 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 2/8] start vm after resetting it
Message-ID: <20130305030623.GM16362@localhost.localdomain>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <d1f8b5689b05b9db923d86941e914d08ac4c2b7c.1362051582.git.hutao@cn.fujitsu.com>
 <51346A21.3010601@redhat.com>
MIME-Version: 1.0
In-Reply-To: <51346A21.3010601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 11:05:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 11:05:19,
	Serialize complete at 2013/03/05 11:05:19
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:32:17AM +0100, Paolo Bonzini wrote:
> Il 28/02/2013 13:13, Hu Tao ha scritto:
> > From: Wen Congyang <wency@cn.fujitsu.com>
> > 
> > The guest should run after resetting it, but it does not run if its
> > old state is RUN_STATE_INTERNAL_ERROR or RUN_STATE_PAUSED.
> > 
> > We don't set runstate to RUN_STATE_PAUSED when resetting the guest,
> > so the runstate will be changed from RUN_STATE_INTERNAL_ERROR or
> > RUN_STATE_PAUSED to RUN_STATE_RUNNING(not RUN_STATE_PAUSED).
> 
> This is also debatable.  In particular, restarting an INTERNAL_ERROR
> guest makes it harder to inspect the state at the time of the failure.
> 
> INTERNAL_ERROR should never happen, let's separate this patch too.

Sure.

> 
> Paolo
