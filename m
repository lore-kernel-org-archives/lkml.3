Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaIIXCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:02:03 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61748 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaIIXCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:02:00 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tejun Heo <tj@kernel.org>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>,
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
        Cas ey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC v2 3/6] kthread: warn on kill signal if not OOM
Date: Tue, 09 Sep 2014 16:01:32 -0700
Message-ID: <5762134.BLS0EbmNJd@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-34-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1410302783.13298.50.camel@jarvis.lan>
References: <20140905174925.GA12991@mtj.dyndns.org> <20140909224143.GB3154@mtj.dyndns.org> <1410302783.13298.50.camel@jarvis.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 09, 2014 03:46:23 PM James Bottomley wrote:
> On Wed, 2014-09-10 at 07:41 +0900, Tejun Heo wrote:
> > 
> > The thing is that we have to have dynamic mechanism to listen for
> > device attachments no matter what and such mechanism has been in place
> > for a long time at this point.  The synchronous wait simply doesn't
> > serve any purpose anymore and kinda gets in the way in that it makes
> > it a possibly extremely slow process to tell whether loading of a
> > module succeeded or not because the wait for the initial round of
> > probe is piggybacked.
> 
> OK, so we just fire and forget in userland ... why bother inventing an
> elaborate new infrastructure in the kernel to do exactly what
> 
> modprobe <mod> &
> 
> would do?

Just so we do not forget: we also want the no-modules case to also be able
to probe asynchronously so that a slow device does not stall kernel booting.

Thanks.

-- 
Dmitry
