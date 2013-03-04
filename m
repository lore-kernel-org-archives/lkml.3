Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3CDLhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:37:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab3CDLhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:37:51 -0500
Message-ID: <513486EC.1050709@redhat.com>
Date: Mon, 04 Mar 2013 12:35:08 +0100
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
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <20130303091738.GB23616@redhat.com> <513471F1.5020702@redhat.com> <20130304102131.GK23616@redhat.com> <51347735.9090204@redhat.com> <20130304104301.GL23616@redhat.com> <51347C23.8080802@redhat.com> <20130304105928.GM23616@redhat.com> <51348142.4070206@redhat.com> <20130304112023.GN23616@redhat.com>
In-Reply-To: <20130304112023.GN23616@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/03/2013 12:20, Gleb Natapov ha scritto:
> On Mon, Mar 04, 2013 at 12:10:58PM +0100, Paolo Bonzini wrote:
>>> It is additional device that
>>> may or may not be present depending on a command line. So what if
>>> someone configures debugcon or debugexit to use this port?
>>
>> I haven't checked if debug{con,exit} will pass the _STA test, but if
>> they do, the user will get a Ctrl-A or respectively an exit of QEMU when
>> the guest panics.
>>
>> What if someone configures debugcon on port 0x3f8?  Some guest will use
>> it, some will not.
>>
> Qemu should fail to start since conflict will be detected during
> initialization.

Not if you _remove_ the serial port and place debugcon at 0x3f8.

Same here, you can remove the panic event port and add debugcon at
0x505.  That's the problematic case.  But if the user goes to that
length, I think we can honestly say we don't care.

Paolo

>>> We can always
>>> blame the users, but I fill that we are making unnecessary compromises.
>>
>> Once we choose an ISA device, where the user has full control of the
>> address space, we already know we'll have to accept compromises.  I
>> don't think this compromise is particularly bad: do discovery via ACPI
>> (nice), accept that the user can trick the AML (ugly).
>
> Why would have we accept compromises, we may, but I disagree that it
> is necessary? If user configures conflicting ports QEMU will detect
> it during init, if configuration is correct DSDT should provide enough
> information for guests to use configured devices.
> 
> --
> 			Gleb.
> 

