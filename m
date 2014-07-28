Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbaG1Qwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:52:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaG1Qwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:52:53 -0400
Date: Mon, 28 Jul 2014 18:52:48 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Yuval Mintz <Yuval.Mintz@qlogic.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Benjamin Poirier <bpoirier@suse.de>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        Santosh Rastapur <santosh@chelsio.com>,
        "MPT-FusionLinux.pdl@avagotech.com" 
	<MPT-FusionLinux.pdl@avagotech.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] driver core: enable drivers to use deferred probe
	from init
Message-ID: <20140728165248.GE21930@wotan.suse.de>
References: <1406558067-25308-1-git-send-email-mcgrof@do-not-panic.com> <B5657A6538887040AD3A81F1008BEC63B06F9A@avmb3.qlogic.org> <20140728153811.GD21930@wotan.suse.de> <B5657A6538887040AD3A81F1008BEC63B06FCF@avmb3.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5657A6538887040AD3A81F1008BEC63B06FCF@avmb3.qlogic.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 03:46:32PM +0000, Yuval Mintz wrote:
> > Subject: Re: [PATCH 1/3] driver core: enable drivers to use deferred probe from
> > init
> > 
> > On Mon, Jul 28, 2014 at 03:12:11PM +0000, Yuval Mintz wrote:
> > > Perhaps this is a silly question, but what guarantees that the
> > > deferred probe list will actually be triggered, e.g., in case the
> > > delayed device is the last device in the system?
> > 
> > The dev->init_delayed_probe is used to ensure that we'd add the device to the
> > deferred probe list once making this a per device thing if the driver has the field
> > delay_probe set to true. This technically also allows this to be a per device thing
> > so with some more work we could enable drivers to only enable this for specific
> > devices but at this point this did not seem required.
> 
> Sorry for not being clear, but I didn't meant 'what guarantees that the device
> will be added to the deferred probe', but rather what guarantees that the
> deferred workqueue will be scheduled.
> 
> To the best of my knowledge the deferring mechanism works only if one device
> is dependent upon another, e.g., for Multi-function devices where one device
> probe is dependent upon the others - which are soon-to-be probed.

The workqueue will be kicked when driver_deferred_probe_trigger() gets
poked, we do that in the late_initcall(deferred_probe_initcall), it
also gets flushed there with a flush_workqueue(deferred_wq).

  Luis
