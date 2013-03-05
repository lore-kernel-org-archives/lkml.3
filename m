Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3CEI12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:27:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab3CEI10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:27:26 -0500
Message-ID: <5135AC2A.8010008@redhat.com>
Date: Tue, 05 Mar 2013 09:26:18 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hu Tao <hutao@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
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
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <ab47cb1ef5a962848b2390d5b602b36aca1f149a.1362051582.git.hutao@cn.fujitsu.com> <51346BFF.5000704@redhat.com> <20130305031701.GN16362@localhost.localdomain>
In-Reply-To: <20130305031701.GN16362@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/03/2013 04:17, Hu Tao ha scritto:
> Will 
> 
>          if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
>              runstate_check(RUN_STATE_SHUTDOWN) ||
>              runstate_check(RUN_STATE_GUEST_PANICKED)) {
>              runstate_set(RUN_STATE_PAUSED);
>          }
> 
> be OK? Or I must be misunderstanding you.
> 

Please move

       return (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
               runstate_check(RUN_STATE_SHUTDOWN) ||
               runstate_check(RUN_STATE_GUEST_PANICKED));

to a separate function (runstate_needs_reset for example), so that you
can reuse it in the two or three places that need it.

Paolo
