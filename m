Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3CDJmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:42:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686Ab3CDJmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:42:01 -0500
Message-ID: <51346C15.3050900@redhat.com>
Date: Mon, 04 Mar 2013 10:40:37 +0100
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
Subject: Re: [PATCH v13 5/8] add a new qevent: QEVENT_GUEST_PANICKED
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <664d63ad19ae6ec25a5a7bd6411c8ab7e289f632.1362051582.git.hutao@cn.fujitsu.com>
In-Reply-To: <664d63ad19ae6ec25a5a7bd6411c8ab7e289f632.1362051582.git.hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/02/2013 13:13, Hu Tao ha scritto:
> This event will be emited when the guest is panicked.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  include/monitor/monitor.h | 1 +
>  monitor.c                 | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/monitor/monitor.h b/include/monitor/monitor.h
> index 87fb49c..4006905 100644
> --- a/include/monitor/monitor.h
> +++ b/include/monitor/monitor.h
> @@ -45,6 +45,7 @@ typedef enum MonitorEvent {
>      QEVENT_WAKEUP,
>      QEVENT_BALLOON_CHANGE,
>      QEVENT_SPICE_MIGRATE_COMPLETED,
> +    QEVENT_GUEST_PANICKED,
>  
>      /* Add to 'monitor_event_names' array in monitor.c when
>       * defining new events here */
> diff --git a/monitor.c b/monitor.c
> index bf974b4..d65218d 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -463,6 +463,7 @@ static const char *monitor_event_names[] = {
>      [QEVENT_WAKEUP] = "WAKEUP",
>      [QEVENT_BALLOON_CHANGE] = "BALLOON_CHANGE",
>      [QEVENT_SPICE_MIGRATE_COMPLETED] = "SPICE_MIGRATE_COMPLETED",
> +    [QEVENT_GUEST_PANICKED] = "GUEST_PANICKED",
>  };
>  QEMU_BUILD_BUG_ON(ARRAY_SIZE(monitor_event_names) != QEVENT_MAX)
>  
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
