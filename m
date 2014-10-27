Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaJ0H22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:28:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaJ0H21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:28:27 -0400
Date: Mon, 27 Oct 2014 08:28:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
Message-ID: <20141027072816.GD10501@worktop.programming.kicks-ass.net>
References: <5446787E.60202@linux.intel.com>
 <20141024153656.GM12706@worktop.programming.kicks-ass.net>
 <544DE5CF.9040501@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544DE5CF.9040501@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 02:27:27PM +0800, Li, Aubrey wrote:
> > Now I suppose the problem is with cpu_pause() which needs IPIs to
> > complete? Do we really need cpuidle_pause() there?
> > cpuidle_uninstall_handlers() seems like a daft thing to call just about
> > there.
> 
> Please check the log of 8651f97bd951d0bb1c10fa24e3fa3455193f3548.
> Rafael should know more this question than me.

That changelog explains its complete bollocks to do it here. We _want_
to enter and/or remain in deep idle states.
