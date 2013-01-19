Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab3ASImR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 03:42:17 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:64621 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3ASImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 03:42:15 -0500
MIME-Version: 1.0
In-Reply-To: <50F87BCA.10201@redhat.com>
References: <1358385543.7040.54.camel@host028-server-9.lan.domdv.de>
	<1358456179.18551.34.camel@haakon2.linux-iscsi.org>
	<50F87BCA.10201@redhat.com>
Date: Sat, 19 Jan 2013 14:12:14 +0530
X-Google-Sender-Auth: oaAIec-KqgBEZM-SDwKK0ZABqiI
Message-ID: <CAP0eoCwV3Rg2s9qcb-_-jqnxX3iZY2qoQV91gaiCUP43fo6nZQ@mail.gmail.com>
Subject: Re: LIO - the broken iSCSI target implementation
From: Ritesh Raj Sarraf <rrs@debian.org>
To: Andy Grover <agrover@redhat.com>, Andreas Steinmetz <ast@domdv.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org,
        target-devel <target-devel@vger.kernel.org>,
        Kugesh Veeraraghavan <kugeshv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 4:01 AM, Andy Grover <agrover@redhat.com> wrote:
> On 01/17/2013 12:56 PM, Nicholas A. Bellinger wrote:
>> On Thu, 2013-01-17 at 02:19 +0100, Andreas Steinmetz wrote:
>>> This is not a technical point of view. This is a more or less political
>>> and user point of view. And for any replies, I'm not subscribed (haven't
>>> been now for years).
>>>
>>> As a user, I was in need for an iSCSI target. Actually, I needed to
>>> export a SAS tape device (Ultrium 5) - which is one of the devices still
>>> sufficiently expensive to go the iSCSI target way) - well, not any disks
>>> (cheap enough, NFS available) or CD/DVD writers (I'd call these penny
>>> targets nowadays).
>>>
>>> Thus, lio (http://www.linux-iscsi.org/) seemed to be the politically and
>>> technically favoured solution. Except: it simply doesn't work, userspace
>>> utilities are seemingly not maintained,
>>
>> I'm not sure what you mean.  There are targetcli+rtslib packages are
>> available for virtually every distribution
>>
>> http://www.linux-iscsi.org/wiki/Targetcli#Linux_distributions
>
> [CCing rrs@debian.org]
>
> No... actually upstream targetcli/rtslib are not very well maintained.
> Around 5 patches each in the last year.
>

I am not sure what errors you are facing but there are users already
using it. I just checked the iSCSI LIO Target, and it seems to work
fine in my limited tests.
If you run into issues, please file bug reports.

14:38:00 root@debian-x64:~# /etc/init.d/open-iscsi restart
[ ok ] Unmounting iscsi-backed filesystems: Unmounting all devices
marked _netdev.
[....] Disconnecting iSCSI targets:iscsiadm: No matching sessions found
. ok
[ ok ] Stopping iSCSI initiator service:.
[ ok ] Starting iSCSI initiator service: iscsid.
[....] Setting up iSCSI targets:
Logging in to [iface: default, target:
iqn.2003-01.org.linux-iscsi.debian-x64.x8664:sn.f32deae5534e, portal:
192.168.122.21,3260] (multiple)
Login to [iface: default, target:
iqn.2003-01.org.linux-iscsi.debian-x64.x8664:sn.f32deae5534e, portal:
192.168.122.21,3260] successful.
. ok
[ ok ] Mounting network filesystems:.


14:38:05 root@debian-x64:~# lsb_release -a
No LSB modules are available.
Distributor ID:	Debian
Description:	Debian GNU/Linux unstable (sid)
Release:	unstable
Codename:	sid

14:38:22 root@debian-x64:~# uname -a
Linux debian-x64 3.2.0-4-amd64 #1 SMP Debian 3.2.32-1 x86_64 GNU/Linux


We are currently under freeze for the Wheezy release. That is why you
don't see any updates. I could surely do latest and greatest updates
into experimental branch of the debian archive, but I have limited
volunteer time for Debian.
And anyways, there have not been much updates in the upstream
repositories, like Andy mentioned. Once the licensing issues are
sorted out, we will see which route we want to move ahead with.

-- 
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."
