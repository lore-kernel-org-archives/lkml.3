Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaLJJH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:07:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbaLJJHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:07:54 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel\@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf\@aepfle.de" <olaf@aepfle.de>,
        "apw\@canonical.com" <apw@canonical.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
References: <1418126489-20627-1-git-send-email-decui@microsoft.com>
	<877fy1ht1u.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E9B80F@SIXPRD3002MB028.064d.mgd.msft.net>
Date: Wed, 10 Dec 2014 10:07:38 +0100
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E9B80F@SIXPRD3002MB028.064d.mgd.msft.net>
	(Dexuan Cui's message of "Wed, 10 Dec 2014 07:36:16 +0000")
Message-ID: <87ppbrhnz9.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

> Thanks,
> -- Dexuan
>
>> -----Original Message-----
>> From: Dexuan Cui
>> Sent: Wednesday, December 10, 2014 15:34 PM
>> To: 'Vitaly Kuznetsov'
>> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
>> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
>> Subject: RE: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
>> 
>> > -----Original Message-----
>> > From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>> > Sent: Tuesday, December 9, 2014 21:06 PM
>> > To: Dexuan Cui
>> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
>> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> > jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
>> > Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
>> >  ......
>> > > +	 * Here "dhcp_enabled" is only for IPv4 according to Hyper-V host
>> > team.
>> > > +	 *
>> > > +	 * In the case the host only injects 1 IPv6 address:
>> > > +	 * new_val->dhcp_enabled is true, but we can't pass
>> > BOOTPROTO=dhcp to
>> > > +	 * the script hv_set_ifconfig, because in some distros (like RHEL7)
>> > > +	 * BOOTPROTO=dhcp has a special meaning in the config file (e.g.,
>> > > +	 * /etc/sysconfig/network-scripts/ifcfg-eth0): the network init
>> > program
>> > > +	 * ignores any static IP addr information once there is
>> > > +	 * BOOTPROTO=dhcp; as a result, IPv6-only injection can't work.
>> > > +	 *
>> > > +	 * In the case of IPv6-only injection, BOOTPROTO=dhcp doesn't affect
>> > > +	 * Ubuntu because it's ignored by the Ubuntu version of
>> > > +	 * hv_set_ifconfig and it doesn't seem to have special meaning in
>> > > +	 * Ubuntu.
>> > > +	 */
>> >
>> > I just checked and adding "IPV6ADDR=something" when
>> "BOOTPROTO=dhcp"
>> > works for me with both RHEL7 and Fedora21.
>> It doesn't work in my side. :-(
>> Running 'ifup eth0' shows some errors(I use "set -x")
>> ...
>> + /sbin/dhclient -H localhost -1 -q -lf /var/lib/dhclient/dhclient--eth0.lease -pf
>> /var/run/dhclient-eth0.pid eth0
>> grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
> BTW, I run with root, and
> 'chown 777 /etc/sysconfig/network-scripts/ifcfg-eth0" doesn't help.
>

s,chown,chmod, :-) But it won't help in case of SELinux mislabeling.

> Thanks,
> -- Dexuan

-- 
  Vitaly
