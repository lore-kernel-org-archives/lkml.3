Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaDAWBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:01:14 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35578 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751450AbaDAWBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:01:12 -0400
Date: Tue, 1 Apr 2014 18:01:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>, Jim Lin <jilin@nvidia.com>
Subject: Re: [PATCH] usb: xhci: Correct last context entry calculation for
 Configure Endpoint
In-Reply-To: <CAODwPW9i-pwgzE-OELwwkw2M_Vnhtsq4p=_5ppO7R6xXpzu==w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1404011753420.8643-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2014, Julius Werner wrote:

> > http://marc.info/?l=linux-usb&m=137158978503741&w=2
> >
> > There's an xHCI spec ambiguity:  Does the last valid context entry refer
> > to the last valid endpoint context in the *input* device context or the
> > *output* device context?

It's not ambiguous at all.  6.2.2.2 clearly states:

	A 'valid' Input Slot Context for a Configure Endpoint Command
	requires the Context Entries field to be initialized to the
	index of the last valid Endpoint Context that is defined by the
	_target configuration_.

(my emphasis).

Thus, if the current config has ep0, ep1, and ep2 and the command drops
ep1, the Context Entries field should be set to the index of ep2 since
that is the last valid Endpoint Context in the target config (which
has only ep0 and ep2).

Alan Stern

