Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab3H3QXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:23:17 -0400
Received: from relay.ihostexchange.net ([66.46.182.51]:30724 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3H3QXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:23:15 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Aug 2013 12:23:15 EDT
Message-ID: <5220C5B9.3000908@tributary.com>
Date: Fri, 30 Aug 2013 11:18:01 -0500
From: Jeremy Linton <jlinton@tributary.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
CC: Marcus Meissner <meissner@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: scsi: make scsi reset permissions more relaxed (RFC)
References: <20130830120450.GB31120@suse.de> <5220945A.2090906@interlog.com>
In-Reply-To: <5220945A.2090906@interlog.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/2013 7:47 AM, Douglas Gilbert wrote:

> I proposed the following patch some time back to give the user space finer
> resolution on resets with the option of stopping the escalation but it has
> gone nowhere: http://marc.info/?l=linux-scsi&m=136104139102048&w=2
> 
> With that patch you might only allow an unprivileged user the
> non-escalating LU and target reset variants.
> 
> If changes are made in that area, we might like to think about adding a new
> RESET variant mapping through to the I_T Nexus Reset TMF.

And a fine, incredibly useful patch it is. To the point of basically being a
requirement for SAN environments. Without it, all kinds of havoc can ensue.

But, the problem of burners going out to lunch, shows why its a stopgap. As most
burners are going to be SATA attached (without an expander), you probably want
to escalate all the way to the host reset if none of the other options work.

With a few other tweaks and the no-escalate patch, its possible to implement
escalation logic outside of the kernel that is aware of the device topology and
individual device states. That way HBA's aren't getting reset under active
functional devices.



