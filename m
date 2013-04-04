Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab3DDIBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:01:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797Ab3DDIBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:01:13 -0400
Date: Thu, 4 Apr 2013 10:01:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Huzefa Kankroliwala <huzefa.nomanx.kankroliwala@intel.com>,
        mika.westerberg@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-hid: fix length for set/get report in i2c hid
In-Reply-To: <CAN+gG=GuEuzekoMAsRiGJNs73PFzRK8oxjjRB4xP1kQeBp0DCw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1304041000270.30938@pobox.suse.cz>
References: <1364993121-18800-1-git-send-email-huzefa.nomanx.kankroliwala@intel.com> <alpine.LNX.2.00.1304040946170.30938@pobox.suse.cz> <CAN+gG=GuEuzekoMAsRiGJNs73PFzRK8oxjjRB4xP1kQeBp0DCw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Apr 2013, Benjamin Tissoires wrote:

> >> With the current i2c hid driver set/get report does not work
> >> as expected, for e.g sensor hub properties like power state,
> >> frequency etc is not set properly on the device as a result
> >> we do not get events.
> >> The problem is that i2c hid driver in function i2c_hid_request
> >> sets length equal to default buffer size for which the sensor
> >> hub does not respond on get/set commands. Use report length
> >> and calculate it based on report size and id.
> >>
> >> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >> Signed-off-by: Huzefa Kankroliwala <huzefa.nomanx.kankroliwala@intel.com>
> >
> > This is based on some old version of the driver though. Could you please
> > rebase it so that it applies on top of for-next branch of
> >
> >         git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
> >
> > and resend? (actually rebasing on Linus' current tree would be absolutely
> > sufficient).
> 
> Actually, the patch goes smoothly on your for-next branch on my computer...
> And there is no point rebasing it on top of Linus' tree as the
> i2c_hid_request() callback is scheduled for 3.10.
> 
> Could you double check Jiri?

Apologies, that was an error on my side, I have forgotten about the 
i2c_hid_request()-related refactoring that is queued.

I will review and apply the patch shortly, thanks.

-- 
Jiri Kosina
SUSE Labs
