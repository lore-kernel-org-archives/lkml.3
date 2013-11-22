Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab3KVRGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:06:11 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:39096 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755723Ab3KVRGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:06:09 -0500
Message-ID: <528F8EFB.4040400@vmware.com>
Date: Fri, 22 Nov 2013 18:06:03 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [i915] BUG: Bad page state in process Xorg
References: <1384980928.3312.6.camel@localhost.localdomain> <alpine.DEB.2.00.1311221036020.16356@skynet.skynet.ie> <CAKMK7uGoAN=PHu+=1FmXPGyZxg3+Mm2awJgkOfO8zBDF2-5arQ@mail.gmail.com> <F6786E45-566F-47C5-974A-B2C1B9B674E4@m3y3r.de> <CAKMK7uEHo3N-R5W6m_-gyEkuq0WPN=YUzJUpdG=MeznPcY2Haw@mail.gmail.com>
In-Reply-To: <CAKMK7uEHo3N-R5W6m_-gyEkuq0WPN=YUzJUpdG=MeznPcY2Haw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 05:18 PM, Daniel Vetter wrote:
> On Fri, Nov 22, 2013 at 4:54 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>>> Am 22.11.2013 um 11:55 schrieb Daniel Vetter <daniel@ffwll.ch>:
>>>
>>> On Fri, Nov 22, 2013 at 11:36 AM, Dave Airlie <airlied@linux.ie> wrote:
>>>>> Hi,
>>>> cc'ing mailing list,
>>>>
>>>> Daniel any ideas?
>>> Nope, not really :( And no ideas how to triage this further - if it
>>> takes 9 days to hit it eventually we'll have a real hard time. Or does
>>> this happen even after just a short X run?
>> Seems to happen every time while stopping the x server. Also after a short run time.
>>
>> The current fedora 3.11 kernel doesn't show this bug. I'm using fedora 19, with a self compiled kernel.
>>
>> I did turn on config-debug-pagealloc but this didn't show any wrongness.
> In that case I think the bisect is the fastest way to insight - atm
> I'm really at loss what could be wrong here.

 From the error messages it looks like whatever's responsible for 
clearing page->mapping doesn't do it for these pages,
(shmem code?).

/Thomas

> -Daniel
