Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3CFJDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:03:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4725 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab3CFJDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:03:12 -0500
X-IronPort-AV: E=Sophos;i="4.84,793,1355068800"; 
   d="scan'208";a="6823401"
Date: Wed, 6 Mar 2013 17:03:18 +0800
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
Subject: Re: [PATCH v13 4/8] add a new runstate: RUN_STATE_GUEST_PANICKED
Message-ID: <20130306090318.GC4719@localhost.localdomain>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <ab47cb1ef5a962848b2390d5b602b36aca1f149a.1362051582.git.hutao@cn.fujitsu.com>
 <51346BFF.5000704@redhat.com>
 <20130305031701.GN16362@localhost.localdomain>
 <5135AC2A.8010008@redhat.com>
MIME-Version: 1.0
In-Reply-To: <5135AC2A.8010008@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 17:02:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 17:02:07,
	Serialize complete at 2013/03/06 17:02:07
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 09:26:18AM +0100, Paolo Bonzini wrote:
> Il 05/03/2013 04:17, Hu Tao ha scritto:
> > Will 
> > 
> >          if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
> >              runstate_check(RUN_STATE_SHUTDOWN) ||
> >              runstate_check(RUN_STATE_GUEST_PANICKED)) {
> >              runstate_set(RUN_STATE_PAUSED);
> >          }
> > 
> > be OK? Or I must be misunderstanding you.
> > 
> 
> Please move
> 
>        return (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
>                runstate_check(RUN_STATE_SHUTDOWN) ||
>                runstate_check(RUN_STATE_GUEST_PANICKED));
> 
> to a separate function (runstate_needs_reset for example), so that you
> can reuse it in the two or three places that need it.

See it now. Thanks!
