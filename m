Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3CDJgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:36:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab3CDJgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:36:39 -0500
Message-ID: <51346A21.3010601@redhat.com>
Date: Mon, 04 Mar 2013 10:32:17 +0100
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
Subject: Re: [PATCH v13 2/8] start vm after resetting it
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <d1f8b5689b05b9db923d86941e914d08ac4c2b7c.1362051582.git.hutao@cn.fujitsu.com>
In-Reply-To: <d1f8b5689b05b9db923d86941e914d08ac4c2b7c.1362051582.git.hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/02/2013 13:13, Hu Tao ha scritto:
> From: Wen Congyang <wency@cn.fujitsu.com>
> 
> The guest should run after resetting it, but it does not run if its
> old state is RUN_STATE_INTERNAL_ERROR or RUN_STATE_PAUSED.
> 
> We don't set runstate to RUN_STATE_PAUSED when resetting the guest,
> so the runstate will be changed from RUN_STATE_INTERNAL_ERROR or
> RUN_STATE_PAUSED to RUN_STATE_RUNNING(not RUN_STATE_PAUSED).

This is also debatable.  In particular, restarting an INTERNAL_ERROR
guest makes it harder to inspect the state at the time of the failure.

INTERNAL_ERROR should never happen, let's separate this patch too.

Paolo
