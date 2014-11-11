Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaKKUnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:43:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKUnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:43:43 -0500
Date: Tue, 11 Nov 2014 12:43:41 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH v2] dell-wmi: Update code for processing WMI events
Message-ID: <20141111204341.GA13729@vmdeb7>
References: <20141111060243.GC56947@vmdeb7>
 <1415733682-8699-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415733682-8699-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 08:21:22PM +0100, Pali Rohár wrote:
> WMI buffer can contains more events. First value in buffer is length of event
> followed by data of specified length. After that is next length and next data.
> When length is zero then there is no more events in bufffer.
> 
> This patch adds support for processing all events in buffer (not only first)
> and parse more event types (not only hotkey events). Because of variable length
> of events sometimes BIOS fills more hotkeys (or other values) into single WMI
> event. In this case this patch process also these multiple hotkeys (and not
> only first one).
> 
> Some event types are just ignored because kernel is not interested for them
> (e.g. NIC Link status, battery unplug, ...).
> 
> This patch is based on DSDT table from Dell Latitude E6440. Code should be
> backward compatible so will process other events of old types same as before
> this patch.
> 
> This patch also fixes problem when in kernel log are written messages about
> unknown WMI events. Now all know events are parsed and those which are not
> interesting for kernel are dropped without unknown message.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>

Queued, thanks. I took the liberty of cleaning up the commit message just a bit:

    dell-wmi: Update code for processing WMI events

    The WMI buffer can contain multiple events. First value in buffer is
    length of event followed by data of specified length. After that is next
    length and next data.  When length is zero then there is no more events
    in bufffer.

    This patch adds support for processing all events in buffer (not only
    first) and parse more event types (not only hotkey events). Because of
    variable length of events sometimes BIOS fills more hotkeys (or other
    values) into single WMI event. In this case this patch also processes
    these multiple hotkeys (and not only first one).

    Some event types are just ignored because kernel is not interested in
    them (e.g. NIC Link status, battery unplug, ...).

    This patch is based on DSDT table from Dell Latitude E6440. Code should
    be backward compatible so will process other events of old types same as
    before this patch.

    This patch also fixes a problem with unknown WMI event messages being
    written to the log. Now all known events are parsed and those which are
    not interesting to the kernel are dropped without an unknown WMI event
    message.

    Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
    Tested-by: Pali Rohár <pali.rohar@gmail.com>
    Signed-off-by: Darren Hart <dvhart@linux.intel.com>

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
