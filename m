Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3ITJxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:53:08 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:53936 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754238Ab3ITJxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:53:06 -0400
Message-ID: <1379670782.5938.14.camel@x220.thuisdomein>
Subject: Re: [PATCH] scsi: fix the build warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joe Perches <joe@perches.com>, Zhi Yong Wu <zwu.kernel@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Date: Fri, 20 Sep 2013 11:53:02 +0200
In-Reply-To: <CAC5umyhVNcwu2k7wEND5DvxRGE+_tyWBNpWjVdQ9DRTyV2qCaw@mail.gmail.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	 <1377133329.12003.9.camel@joe-AO722>
	 <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	 <1377134271.12003.15.camel@joe-AO722> <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
	 <CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
	 <1377181627.2009.2.camel@dabdike.int.hansenpartnership.com>
	 <CAC5umyhVNcwu2k7wEND5DvxRGE+_tyWBNpWjVdQ9DRTyV2qCaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Sep 2013 09:53:02.0979 (UTC) FILETIME=[32823530:01CEB5E7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 23:49 +0900, Akinobu Mita wrote:
> 2013/8/22 James Bottomley <jbottomley@parallels.com>:
> > On Thu, 2013-08-22 at 21:42 +0900, Akinobu Mita wrote:
> >> Unfortunately, this warning isn't fixed in linux-next, either.
> >> Paul Bolle also sent a patch that fixes the same warning in a little
> >> bit different way.
> >
> > Well, it is and it isn't.  Whether you see the warning seems to depend
> > on how gcc was built.  My take is that an impossible default case just
> > to keep some versions of gcc quiet is a bit pointless.
> 
> As Joe said in the other reply, scsi_debug_guard could be a negative
> value (scsi_debug_guard > 1 is only prohibited).  So this warning
> does not seem a false positive.

I too think that GCC is correct here. Perhaps the people not seeing this
warning don't have CONFIG_SCSI_DEBUG set.

A week ago Antonia also submitted a patch to silence this warning
( https://lkml.org/lkml/2013/9/13/649 ). That's at least the third time
someone tried to silence it since it got introduced in the v3.11 cycle.

Akinobu, could you please say how you'd like this warning to be
silenced? Or is an actual fix queued somewhere?


Paul Bolle

