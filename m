Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaJNNTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:19:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59908 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbaJNNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:19:41 -0400
Date: Tue, 14 Oct 2014 15:19:35 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Message-ID: <20141014131935.GA5994@localhost.localdomain>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014115412.GC4019@localhost.localdomain>
 <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 01:04:35PM +0000, Thomas Shao wrote:
> > > +		/*
> > > +		* Use the Hyper-V time sample to adjust the guest time. The
> > > +		* algorithm is: If the sample offsets exceeds 1 second, we
> > > +		* directly set the clock to the server time. If the offset is
> > 
> > So the guests will experience random time jumps in the kernel, without any
> > rhyme or reason?
> 
> This behavior is designed for some extreme cases. Like manually setting guest time
> to some value. Or the host resumes from a hibernate state. Normally, we should not
> run into this.

But when it *does* happen, the guest software will have no way of
knowing what happened. That stinks.

Taking your example, when the guest sets its time, the time will
suddenly jump somewhere else, and for no apparent reason.

>From the guest's point of view, this is really not acceptable.

Thanks,
Richard
