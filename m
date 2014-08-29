Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaH2Nxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:53:54 -0400
Received: from mx2.parallels.com ([199.115.105.18]:40367 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaH2Nxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:53:51 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "hare@suse.de" <hare@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs
 that may have been removed.
Thread-Topic: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs
 that may have been removed.
Thread-Index: AQHPwzLQRMccNdeHjES9hD4SioHjqZvnkT6AgAAWbACAAAmVAIAAXv0A
Date: Fri, 29 Aug 2014 13:53:42 +0000
Message-ID: <1409320422.2036.5.camel@jarvis.lan>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
	 <1408244988-27456-1-git-send-email-kys@microsoft.com>
	 <1408244988-27456-2-git-send-email-kys@microsoft.com>
	 <20140819175431.GA4617@infradead.org> <53FDEBB9.5070704@suse.de>
	 <53FFE87B.9040802@cs.wisc.edu> <54001B5F.9040506@suse.de>
	 <54002E2E.7030301@acm.org> <54003638.5010301@suse.de>
In-Reply-To: <54003638.5010301@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.103.107]
Content-Type: text/plain; charset="utf-8"
Content-ID: <39D09D14E9FB88409B62F001C01BFF34@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7TDs2OT025301

On Fri, 2014-08-29 at 10:13 +0200, Hannes Reinecke wrote:
> On 08/29/2014 09:39 AM, Bart Van Assche wrote:
> > On 08/29/14 08:19, Hannes Reinecke wrote:
> >> On 08/29/2014 04:42 AM, Mike Christie wrote:
> >>> How are distros handling 0x6/0x3f/0x0e (report luns changed) when it
> >>> gets passed to userspace? Is everyone kicking off a new full (add and
> >>> delete) scan to handle this or logging it? Is the driver returning this
> >>> when the LUNs change?
> >>>
> >> Currently it's logged to userspace and ignored.
> >> Doing an automated rescan has proven to be dangerous, as it
> >> might disconnect any LUNs which are still in use by applications.
> >> Especially HA or database setups tends to become very annoyed
> >> when you do an automated rescan.
> >
> > Has it already been considered to add newly discovered LUNs
> > automatically and to leave it to the user to remove stale LUNs manually
> > ? That would be similar to what the rescan-scsi-bus.sh script does
> > without option -r/--remove.
> >
> 
> As of now we're still missing an in-kernel infrastructure which 
> would allow us to react on any sense codes; currently we're relying 
> on the administrator to setup a udev rule here.

Um, I thought this was supposed to solve that problem:

commit 279afdfe78a020b4b1a68bffd0009b961b12982e
Author: Ewan D. Milne <emilne@redhat.com>
Date:   Thu Aug 8 15:07:48 2013 -0400

    [SCSI] Generate uevents on certain unit attention codes

The idea was supposed to be that, as you say, log scrubbers are hard to
configure and break every time someone fixes a spelling error, so we
could now listen for a report luns data change uevent instead.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
