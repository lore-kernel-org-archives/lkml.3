Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3CEI1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:27:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab3CEI1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:27:17 -0500
Message-ID: <5135ABB8.5070202@redhat.com>
Date: Tue, 05 Mar 2013 09:24:24 +0100
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
Subject: Re: [PATCH v13 1/8] save/load cpu runstate
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <df20999140db716e8b1ccd57a7cbcb0fa343a78c.1362051582.git.hutao@cn.fujitsu.com> <513469C8.30602@redhat.com> <20130305023308.GK16362@localhost.localdomain>
In-Reply-To: <20130305023308.GK16362@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/03/2013 03:33, Hu Tao ha scritto:
> On Mon, Mar 04, 2013 at 10:30:48AM +0100, Paolo Bonzini wrote:
>> Il 28/02/2013 13:13, Hu Tao ha scritto:
>>> This patch enables preservation of cpu runstate during save/load vm.
>>> So when a vm is restored from snapshot, the cpu runstate is restored,
>>> too.
>>
>> I don't think this feature is worth breaking backwards migration
>> compatibility.  It is usually handled at a higher-level (management,
>> like libvirt).
> 
> If guest panic happens during migration, runstate will still be running
> on destination host without this patch. But, it does be a problem to break
> backwards migration compatibility.

Yes, but the source management (libvirt for example) will have the
occasion to observe the change and cancel the migration or forward the
information on the wire.  There are already similar reasons why libvirt
always starts guests with -S.

Paolo
