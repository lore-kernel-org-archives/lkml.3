Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3CDMWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:22:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab3CDMWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:22:49 -0500
Message-ID: <513491B6.6050706@redhat.com>
Date: Mon, 04 Mar 2013 13:21:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Hu Tao <hutao@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Blue Swirl <blauwirbel@gmail.com>,
        Eric Blake <eblake@redhat.com>, Andrew Jones <drjones@redhat.com>,
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
Subject: Re: [PATCH v13 0/8] pv event interface between host and guest
References: <20130303091738.GB23616@redhat.com> <513471F1.5020702@redhat.com> <20130304102131.GK23616@redhat.com> <51347735.9090204@redhat.com> <20130304104301.GL23616@redhat.com> <51347C23.8080802@redhat.com> <20130304105928.GM23616@redhat.com> <51348142.4070206@redhat.com> <20130304112023.GN23616@redhat.com> <513486EC.1050709@redhat.com> <20130304115207.GO23616@redhat.com>
In-Reply-To: <20130304115207.GO23616@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/03/2013 12:52, Gleb Natapov ha scritto:
> > Same here, you can remove the panic event port and add debugcon at
> > 0x505.  That's the problematic case.  But if the user goes to that
> > length, I think we can honestly say we don't care.
>
> IMO there is a big difference between well know serial ISA ports and
> PIO ports we allocate for our devices. Later have to be discoverable
> without resorting to probing. On CPU level we do the same with CPUID
> bits instead of relaying on MSRs #GP. On KVM API level we do the same
> with capabilities instead of relying on ioctls returning errors. This
> is not different.

Ok, I see your point now.  Yes, this is a good reason why patching is
better in the long run.

Paolo
