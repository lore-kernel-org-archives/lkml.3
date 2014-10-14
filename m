Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaJNQbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:31:02 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35714 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaJNQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:31:00 -0400
Date: Tue, 14 Oct 2014 18:30:53 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Mike Surcouf <mps.surcouf.lkml@gmail.com>
Cc: Thomas Shao <huishao@microsoft.com>,
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
Message-ID: <20141014163053.GA7473@localhost.localdomain>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014115412.GC4019@localhost.localdomain>
 <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141014132551.GB5994@localhost.localdomain>
 <CAL7Bo8EHOgBFtE87ecC9PSwUy2=M5Q31ka6BX2Eut-eqXSbang@mail.gmail.com>
 <20141014143346.GC6469@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014143346.GC6469@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:33:46PM +0200, Richard Cochran wrote:
> 
> IMHO, you should let the guest steer its own clock. That gives the end
> user the most flexibility. Just provide the offset information, and
> let a dedicated service (like ntpd or linuxptp's phc2sys) do the rest.

So if it really about the convenience of not having to run a service
on the guests, then why not expose the guest clock to the host as a
dynamic posix clock? Then you could use phc2sys to tune the guest
without writing even a line of servo code...
 
Thanks,
Richard
