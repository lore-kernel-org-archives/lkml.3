Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaLAMeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:34:00 -0500
Received: from mx2.parallels.com ([199.115.105.18]:40873 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaLAMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:33:57 -0500
Message-ID: <547C6022.1030904@parallels.com>
Date: Mon, 1 Dec 2014 15:33:38 +0300
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Florian Weimer <fw@deneb.enyo.de>, Andy Lutomirski <luto@amacapital.net>
CC: <criu@openvz.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>	<87k32d13d5.fsf@mid.deneb.enyo.de>	<CALCETrV_aArOr7v4AqLHdyGGNU-5XBPmvBXEqbVU36EJ_G26uQ@mail.gmail.com> <87egsjrhmp.fsf@mid.deneb.enyo.de>
In-Reply-To: <87egsjrhmp.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: US-EXCH2.sw.swsoft.com (10.255.249.46) To
 US-EXCH.sw.swsoft.com (10.255.249.47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 09:47 AM, Florian Weimer wrote:
> * Andy Lutomirski:
> 
>> On Nov 30, 2014 1:47 AM, "Florian Weimer" <fw@deneb.enyo.de> wrote:
>>>
>>> * Andy Lutomirski:
>>>
>>>> The initial implementation is straightforward: highpid is simply a
>>>> 64-bit counter. If a high-end system can fork every 3 ns (which
>>>> would be amazing, given that just allocating a pid requires at
>>>> atomic operation), it would take well over 1000 years for highpid to
>>>> wrap.
>>>
>>> I'm not sure if I'm reading the patch correctly, but is the counter
>>> namespaced?  If yes, why?
>>
>> It's namespaced so that CRIU can migrate/restore a whole pid namespace.
> 
> Oh well, this requirement is at odds with system-wide uniqueness.  Is
> CRIU really that important? :-)

Well, in this context it is. Since the main (if not the only) use-case for
highpid is to read one, remember, then compare to new value, restoring it
to wrong/arbitrary value will break the using applications in 100% cases.

Thus we really need the ability to restore this value.

Thanks,
Pavel

