Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaJCULh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:11:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaJCULe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:11:34 -0400
Date: Fri, 3 Oct 2014 22:11:26 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, tiwai@suse.de,
        tj@kernel.org, arjan@linux.intel.com, teg@jklm.no, rmilasan@suse.com,
        werner@suse.com, oleg@redhat.com, hare@suse.com, bpoirier@suse.de,
        santosh@chelsio.com, pmladek@suse.cz, dbueso@suse.com,
        linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 5/5] driver-core: add driver asynchronous probe
	support
Message-ID: <20141003201126.GW14081@wotan.suse.de>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com> <1411768637-6809-6-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411768637-6809-6-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 02:57:17PM -0700, Luis R. Rodriguez wrote:
> +	queue_work(system_unbound_wq, &priv->attach_work->work);

Tejun,

based on my testing so far using system_highpri_wq instead of
system_unbound_wq yields close to par / better boot times
than synchronous probe support for all modules. How set are
you on using system_unbound_wq? About to punt out a new
series which also addresses built-in.

  Luis
