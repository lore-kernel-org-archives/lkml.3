Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbaJNOVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:21:45 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43813 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbaJNOVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:21:44 -0400
Date: Tue, 14 Oct 2014 16:21:38 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Mike Surcouf <mps.surcouf.lkml@gmail.com>
Cc: Thomas Shao <huishao@microsoft.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Message-ID: <20141014142138.GA6469@localhost.localdomain>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014111915.GV23154@mwanda>
 <CD2CABCB2C0A0D4682C5F8AD840141540BFD19@HKXPRD3002MB006.064d.mgd.msft.net>
 <CAL7Bo8ESE-=FY0KyQDc2Ne1SfX=fF0Q088jo_j-JpMmQYvArGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL7Bo8ESE-=FY0KyQDc2Ne1SfX=fF0Q088jo_j-JpMmQYvArGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 02:16:34PM +0100, Mike Surcouf wrote:
> What is your expected value for TICK_USEC?  I cant make the arithmetic work.
> You double the check time if you are close but you never reduce the
> check time if you are not.
> Adjusting the tick count is a coarse adjustment of the clock.  You
> will end up chasing the host time but never stabilizing it.

We should not be putting hardcoded servos into random drivers.

Instead, why not export the time offset to the guest as a series of
PPS samples, or the like?  Then, a user space program in the guest can
decide whether it will use the information and how to filter the
signal.
 
> Regarding the comment we have NTP for this I agree that would be
> better than this implementation and I think Thomas agrees (as he said
> NTP is the preferred option)
> In order for this to be a good source of time for RTP and other time
> sensitive stuff . you will have to have to re-implement parts of NTP
> such as adjusting the clock frequency decreasing the check period when
> error becomes too great etc. etc..

No, lets not re-implement NTP. That would be a waste of effort.

Thanks,
Richard
