Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaIIBLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:11:11 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48168 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaIIBLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:11:09 -0400
Date: Tue, 9 Sep 2014 10:10:59 +0900
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
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
Subject: Re: [RFC v2 3/6] kthread: warn on kill signal if not OOM
Message-ID: <20140909011059.GB11706@mtj.dyndns.org>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
 <CAB=NE6Wti1RpAFk5q_YeZn2F9Rd=wsiwhyPszu74nG9fXwH5vQ@mail.gmail.com>
 <20140905141241.GC10455@mtj.dyndns.org>
 <20140905164405.GA28964@core.coreip.homeip.net>
 <20140905174925.GA12991@mtj.dyndns.org>
 <CAB=NE6VPTV39pNujOgO422wbUvU44HZ7s=aaxPVraNECqA6e4Q@mail.gmail.com>
 <20140905224047.GC15723@mtj.dyndns.org>
 <CAB=NE6Uz1VD5qpMFSBfQRV8ih9FQcCUhNtWMvD38t5hdDvix4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6Uz1VD5qpMFSBfQRV8ih9FQcCUhNtWMvD38t5hdDvix4Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Luis.

On Mon, Sep 08, 2014 at 06:04:23PM -0700, Luis R. Rodriguez wrote:
> > I have no idea how the selection should be.  It could be per-insmod or
> > maybe just a system-wide flag with explicit exceptions marked on
> > drivers is good enough.  I don't know.
> 
> Its perfectly understandable if we don't know what path to take yet
> and its also understandable for it to take time to figure out --
> meanwhile though systemd already has merged a policy of a 30 second
> timeout for *all drivers* though so we therefore need:

I'm not too convinced this is such a difficult problem to figure out.
We already have most of logic in place and the only thing missing is
how to switch it.  Wouldn't something like the following work?

* Add a sysctl knob to enable asynchronous device probing on module
  load and enable asynchronous probing globally if the knob is set.

* Identify cases which can't be asynchronous and make them
  synchronous.  e.g. keep who's doing request_module() and avoid
  asynchronous probing if current is probing one of those.

Thanks.

-- 
tejun
