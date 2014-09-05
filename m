Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaIEOM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:12:56 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46650 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaIEOMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:12:54 -0400
Date: Fri, 5 Sep 2014 23:12:41 +0900
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wu Zhangjin <falcon@meizu.com>, Takashi Iwai <tiwai@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
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
Message-ID: <20140905141241.GC10455@mtj.dyndns.org>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
 <1409899047-13045-4-git-send-email-mcgrof@do-not-panic.com>
 <20140905071925.GC9323@mtj.dyndns.org>
 <CAB=NE6Wti1RpAFk5q_YeZn2F9Rd=wsiwhyPszu74nG9fXwH5vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6Wti1RpAFk5q_YeZn2F9Rd=wsiwhyPszu74nG9fXwH5vQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 12:47:16AM -0700, Luis R. Rodriguez wrote:
> Ah -- well without it the way we "find" drivers that need this new
> "async feature" is by a bug report and folks saying their system can't
> boot, or they say their device doesn't come up. That's all. Tracing
> this to systemd and a timeout was one of the most ugliest things ever.
> There two insane bug reports you can go check:
> 
> mptsas was the first:
> 
> http://article.gmane.org/gmane.linux.kernel/1669550
> https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1297248
> 
> Then cxgb4:
> 
> https://bugzilla.novell.com/show_bug.cgi?id=877622
> 
> I only had Cc'd you on the newest gem pata_marvell :
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=59581
> 
> We can't seriously expect to be doing all this work for every driver.
> a WARN_ONCE() would enable us to find the drivers that need this new
> async probe "feature".

This whole approach of trying to mark specific drivers as needing
"async probing" is completely broken for the problem at hand.  It
can't address the problem adequately while breaking backward
compatibility.  I don't think this makes much sense.

Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
