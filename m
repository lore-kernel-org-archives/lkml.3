Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbaIIB03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:26:29 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:37838 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaIIB01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140909012227.GE11706@mtj.dyndns.org>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
 <CAB=NE6Wti1RpAFk5q_YeZn2F9Rd=wsiwhyPszu74nG9fXwH5vQ@mail.gmail.com>
 <20140905141241.GC10455@mtj.dyndns.org> <20140905164405.GA28964@core.coreip.homeip.net>
 <20140905174925.GA12991@mtj.dyndns.org> <CAB=NE6VPTV39pNujOgO422wbUvU44HZ7s=aaxPVraNECqA6e4Q@mail.gmail.com>
 <20140905224047.GC15723@mtj.dyndns.org> <CAB=NE6Uz1VD5qpMFSBfQRV8ih9FQcCUhNtWMvD38t5hdDvix4Q@mail.gmail.com>
 <20140909011059.GB11706@mtj.dyndns.org> <20140909012227.GE11706@mtj.dyndns.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 8 Sep 2014 18:26:04 -0700
X-Google-Sender-Auth: lfi20wmJMaIPertxfewX3b_buSE
Message-ID: <CAB=NE6Vn3hA_VKJyi4kgMi6iMtTtA104-_UfFm6vgX14RoDOTw@mail.gmail.com>
Subject: Re: [RFC v2 3/6] kthread: warn on kill signal if not OOM
To: Tejun Heo <tj@kernel.org>
Cc: Lennart Poettering <lennart@poettering.net>, Kay Sievers <kay@vrfy.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Zhangjin <falcon@meizu.com>, Takashi Iwai <tiwai@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, hare@suse.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 6:22 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Sep 09, 2014 at 10:10:59AM +0900, Tejun Heo wrote:
>> I'm not too convinced this is such a difficult problem to figure out.
>> We already have most of logic in place and the only thing missing is
>> how to switch it.  Wouldn't something like the following work?
>>
>> * Add a sysctl knob to enable asynchronous device probing on module
>>   load and enable asynchronous probing globally if the knob is set.
>
> Alternatively, add a module-generic param "async_probe" or whatever
> and use that to switch the behavior should work too.  I don't know
> which way is better but either should work fine.

I take it by this you meant a generic system-wide sysctl or kernel cmd
line option to enable this for al drivers?

  Luis
