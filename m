Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3CAHgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:36:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:30085 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab3CAHgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:36:42 -0500
X-IronPort-AV: E=Sophos;i="4.84,760,1355068800"; 
   d="scan'208";a="6792898"
Date: Fri, 1 Mar 2013 15:36:48 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Eric Blake <eblake@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 1/8] save/load cpu runstate
Message-ID: <20130301073648.GD16362@localhost.localdomain>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <df20999140db716e8b1ccd57a7cbcb0fa343a78c.1362051582.git.hutao@cn.fujitsu.com>
 <512FC845.9080209@redhat.com>
MIME-Version: 1.0
In-Reply-To: <512FC845.9080209@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 15:35:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 15:35:46,
	Serialize complete at 2013/03/01 15:35:46
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 02:12:37PM -0700, Eric Blake wrote:
> On 02/28/2013 05:13 AM, Hu Tao wrote:
> > This patch enables preservation of cpu runstate during save/load vm.
> > So when a vm is restored from snapshot, the cpu runstate is restored,
> > too.
> 
> What happens if a management app wants to override the runstate when
> restoring the domain?  I can think of several useful scenarios:
> 
> 1. management app pauses the guest, then saves domain state and other
> things (management state, or disk clones), then resumes the guest.
> Later, the management wants to revert to the saved state, but have the
> guest running right away.  I guess here, knowing that the guest was
> saved in a paused state doesn't hurt, since the management app can
> resume it right away.
> 
> 2. management app saves domain state of a live guest, then copies that
> state elsewhere.  In its new location, the management app wants to
> investigate the state for forensic analysis - so even though the guest
> remembers that it was running, management wants to start it paused.
> Here, it is important that there must not be a window of time where the
> guest can run, otherwise, the results are not reproducible.

-S takes precedence in the case. But for in-migration, runstate is
loaded from src.
