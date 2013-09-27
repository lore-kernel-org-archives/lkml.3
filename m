Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3I0TCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:02:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab3I0TCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:02:20 -0400
Message-ID: <5245D626.6090209@redhat.com>
Date: Fri, 27 Sep 2013 21:01:58 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Veaceslav Falico <vfalico@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        linux.nics@intel.com,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kobject_add_internal failed for msi_irqs with -EEXIST
References: <5245896A.70705@redhat.com> <CAErSpo6L-Ud08=JPM7d=RYuPO=UFvq_9hZGbne0iQnCHiFbuHQ@mail.gmail.com> <20130927160125.GB14139@redhat.com>
In-Reply-To: <20130927160125.GB14139@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 27.9.2013 18:01, Veaceslav Falico napsal(a):
> On Fri, Sep 27, 2013 at 09:58:28AM -0600, Bjorn Helgaas wrote:
>> [+cc Veaceslav, linux-pci]
>>
>> On Fri, Sep 27, 2013 at 7:34 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
>>> Hi
>>>
>>> With recent build of 3.12-rc2 I'm getting this warning report from kernel:
>>> (hw Lenovo T61, C2D, 4GB Ram)
>>> (repost since linux-kernel@ rejected my gmail email....)
>>
>> This looks related to the MSI/kobject issues Veaceslav is working on.
>> See
>> http://lkml.kernel.org/r/1379382464-7920-2-git-send-email-vfalico@redhat.com
>> and related messages.
>>
>> We don't have a resolution yet.  If you have
>> CONFIG_DEBUG_KOBJECT_RELEASE=y, you could try turning that off.  I
>> don't know if it would help, and it would only be a temporary
>> workaround anyway.
>
> I've looked at the original post -
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg510798.html
> hope that's it - and it seems that it's disabling DEBUG_KOBJECT_RELEASE
> won't help - the warning is about the re-registering, not about freeing it.
>
> As a workaround I'd suggest adding some kind of delay between removing and
> adding the msi - as in - rmmod e1000e; sleep 1; modprobe e1000e; - or
> something like that, so that there is enough time for the /msqi_irqs/ to go
> away.
>

I'm not readding e1000e modules myself - however I've no idea what 
NetworkManager does. Here are messages prior warning:

NetworkManager[304]: <info> monitoring kernel firmware directory '/lib/firmware'.
NetworkManager[304]: <info> rfkill1: found WiFi radio killswitch (at 
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1) 
(driver iwl3945)
NetworkManager[304]: <info> WiFi hardware radio set enabled
NetworkManager[304]: <info> WiFi enabled by radio killswitch; enabled by state 
file
NetworkManager[304]: <info> WWAN enabled by radio killswitch; disabled by 
state file
NetworkManager[304]: <info> WiMAX enabled by radio killswitch; enabled by 
state file
NetworkManager[304]: <info> Networking is enabled by state file
NetworkManager[304]: <info> (eth0): carrier is OFF
NetworkManager[304]: <info> (eth0): new Ethernet device (driver: 'e1000e' 
ifindex: 2)
NetworkManager[304]: <info> (eth0): exported as 
/org/freedesktop/NetworkManager/Devices/0
NetworkManager[304]: <info> (eth0): device state change: unmanaged -> 
unavailable (reason 'managed') [10 20 2]
NetworkManager[304]: <info> (eth0): bringing up device.
rpcbind: cannot create socket for udp6
rpcbind: cannot create socket for tcp6
kernel: [    5.727025] WARNING! power/level is deprecated; use power/control 
instead


So it looks like  'bringing up' causes recreation of msi_irqs ?

Zdenek





