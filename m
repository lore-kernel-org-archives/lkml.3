Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaIEXFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:05:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:26184 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaIEXFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:05:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="382161185"
Message-ID: <540A41BA.4010105@linux.intel.com>
Date: Fri, 05 Sep 2014 16:05:30 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Tejun Heo <tj@kernel.org>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Zhangjin <falcon@meizu.com>, Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, hare@suse.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>, Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC v2 3/6] kthread: warn on kill signal if not OOM
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com> <CAB=NE6Wti1RpAFk5q_YeZn2F9Rd=wsiwhyPszu74nG9fXwH5vQ@mail.gmail.com> <20140905141241.GC10455@mtj.dyndns.org> <20140905164405.GA28964@core.coreip.homeip.net> <20140905174925.GA12991@mtj.dyndns.org> <20140905181003.GA29003@core.coreip.homeip.net> <20140905222956.GA15723@mtj.dyndns.org> <540A3CF4.5070508@linux.intel.com> <20140905225248.GC35667@core.coreip.homeip.net>
In-Reply-To: <20140905225248.GC35667@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/2014 3:52 PM, Dmitry Torokhov wrote:
> On Fri, Sep 05, 2014 at 03:45:08PM -0700, Arjan van de Ven wrote:
>> On 9/5/2014 3:29 PM, Tejun Heo wrote:
>>> Hello, Dmitry.
>>>
>>> On Fri, Sep 05, 2014 at 11:10:03AM -0700, Dmitry Torokhov wrote:
>>>> I do not agree that it is actually user-visible change: generally speaking you
>>>> do not really know if device is there or not. They come and go. Like I said,
>>>> consider all permutations, with hot-pluggable buses, deferred probing, etc,
>>>
>>> It is for storage devices which always have guaranteed synchronous
>>> probing on module load and well-defined probing order.  Sure, modern
>>> setups are a lot more dynamic but I'm quite certain that there are
>>> setups in the wild which depend on storage driver loading being
>>> synchronous.  We can't simply declare one day that such behavior is
>>> broken and break, most likely, their boots.
>>
>> we even depend on this in the mount-by-label cases
>>
>> many setups assume that the internal storage prevails over the USB stick in the case of conflicts.
>> it's a security issue; you don't want the built in secure bootloader that has a kernel root argument
>> by label/uuid.
>> the security there tends to assume that built-in wins over USB
>
> Ahem... and they sure it works reliably with large storage arrays? With
> SCSI doing probing asynchronously already?

you tend to trust your large storage array
you tend to not trust the walk up USB stick.

