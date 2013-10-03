Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3JCUtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:49:06 -0400
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:43403 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754617Ab3JCUtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <1380802143.19256.95.camel@haakon3.risingtidesystems.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
 <20130920203222.GA14306@kroah.com> <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
 <524180B7.7090307@gmail.com> <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
 <5241C9E7.2000404@cs.wisc.edu> <bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
 <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
 <ff6a93ed5d234c14874d03415812a3ec@SN2PR03MB061.namprd03.prod.outlook.com> <1380802143.19256.95.camel@haakon3.risingtidesystems.com>
From: Eric Seppanen <eric@purestorage.com>
Date: Thu, 3 Oct 2013 13:48:42 -0700
Message-ID: <CADOQvuPWaSntci+4pNCbsP-Ug6P=xf1_5ZqqoaA+fXumgfHmeA@mail.gmail.com>
Subject: Re: Drivers: scsi: FLUSH timeout
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 5:09 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> On Wed, 2013-10-02 at 18:29 +0000, KY Srinivasan wrote:
> > Ideally, I want this to be adjustable like the way we can change the I/O timeout.
> > Since that has been attempted earlier and rejected (not clear what the reasons were),
> > I was suggesting that we pick a larger number. James, let me know how I should proceed here.
> >
>
> I think the objection was to making a module parameter for doing this
> globally for all struct scsi_disk, and not the idea of making it
> adjustable on an individual basis per-say..
>
> What about adding a /sys/class/scsi_disk/$HCTL/flush_timeout..?

Do I/O timeouts and flush timeouts need to be independently adjusted?
If you're having trouble with slow operations, it seems likely to be
across the board.

Flush timeout could be defined as 2x the read/write timeout.  Any
other command-specific timeouts could be scaled the same way.
