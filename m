Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3ENHwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:52:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab3ENHwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:52:18 -0400
X-IronPort-AV: E=Sophos;i="4.87,668,1363104000"; 
   d="scan'208";a="7264509"
Message-ID: <5191ED9E.4000100@cn.fujitsu.com>
Date: Tue, 14 May 2013 15:54:06 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasily Kulikov <segoon@openwall.com>
Subject: Re: For review: user_namespaces(7) man page
References: <1367264746.18069.186@driftwood>
In-Reply-To: <1367264746.18069.186@driftwood>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 15:51:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 15:51:11,
	Serialize complete at 2013/05/14 15:51:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 03:45 AM, Rob Landley wrote:
> On 04/29/2013 02:45:45 AM, richard -rw- weinberger wrote:
>> On Thu, Mar 21, 2013 at 4:52 PM, Michael Kerrisk (man-pages)
>> <mtk.manpages@gmail.com> wrote:
>> > Hi Serge,
>> >
>> > On Fri, Mar 15, 2013 at 4:38 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
>> >> Hi,
>> >>
>> >> you mention that after creating a new user namespace you at first have
>> >> all capabilities in the new ns.  You don't explicitly mention (or I
>> >> missed it - I did see the mention of securebits) that if you want to
>> >> keep those capabilities after doing an exec, you need to first have
>> >> something mapped to uid 0 in the userns, and do setuid(0).
>> >
>> > Good point. I'll add something on that.
>> >
>> >> You might not want to list manpages from other projects,
>> >
>> > Actually, not a problem. Many of the pages in my set already do this.
>> >
>> >> but Eric's
>> >> shadow patches introduce some good new manpages as well.  Those aren't yet
>> >> accepted upstream, but if/when they are then mention at least of
>> >> subuid(5), subgid(5), and newuidmap(1) and newgidmap(1) might be good.
>> >
>> > I'll add those.
>> >
>> > Cheers,
>> >
>> > Michael
>>
>> Can we please also document which capabilities are useless within an
>> user namespace?
>> E.g. CAP_MKNOD.
>> You get this capability but the kernel always checks it against the
>> initial userns.
> 
> Is there a device namespace?
> 

No,and I don't think we need device namespace now.

> I vaguely recall OpenVZ implemented moving individual PCI devices into containers so some large movie company could put one video card in each container for render farms. There are lots of devices
> that aren't _really_ privileged (/dev/zero, /dev/null, /dev/full, /dev/ram) and more that could be emulated...

You can create these devices on host for container, and use device cgroup to limit which container can use these devices.

> 
> (Really this seems like a situation where devtmpfs needs -o newinstance and a corresponding filtered event netlink feed to pass to udev/mdev. And that might even have been feasible before Greg decided
> that devtmpfs needed to have opinions about uids. Oh well.)
> 
> Rob--
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
