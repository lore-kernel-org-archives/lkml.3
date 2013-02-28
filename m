Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3B1NY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 08:24:57 -0500
Received: from goliath.siemens.de ([192.35.17.28]:17440 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3B1NYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 08:24:55 -0500
Message-ID: <512F5A5E.9020504@siemens.com>
Date: Thu, 28 Feb 2013 14:23:42 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Hu Tao <hutao@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>, Blue Swirl <blauwirbel@gmail.com>,
        Eric Blake <eblake@redhat.com>, Andrew Jones <drjones@redhat.com>,
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
Subject: Re: [PATCH v13 2/8] start vm after resetting it
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <d1f8b5689b05b9db923d86941e914d08ac4c2b7c.1362051582.git.hutao@cn.fujitsu.com>
In-Reply-To: <d1f8b5689b05b9db923d86941e914d08ac4c2b7c.1362051582.git.hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-28 13:13, Hu Tao wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
> 
> The guest should run after resetting it, but it does not run if its
> old state is RUN_STATE_INTERNAL_ERROR or RUN_STATE_PAUSED.
> 
> We don't set runstate to RUN_STATE_PAUSED when resetting the guest,
> so the runstate will be changed from RUN_STATE_INTERNAL_ERROR or
> RUN_STATE_PAUSED to RUN_STATE_RUNNING(not RUN_STATE_PAUSED).

I just wonder what will happen if I interrupted the guest via gdb and
then issue "monitor system_reset", also via gdb - common pattern if you
set a breakpoint on some BUG() or fault handler and then want to restart
the guest. Will the guest continue then while gdb thinks it is still
stopped? Likely, we do not differentiate between gdb-initiated stops and
the rest. Could you clarify?

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
