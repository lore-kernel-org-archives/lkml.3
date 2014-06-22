Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaFVQpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 12:45:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33516 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751801AbaFVQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 12:45:43 -0400
Date: Sun, 22 Jun 2014 12:45:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
In-Reply-To: <4507844.xYQKbujFj3@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1406221239060.17183-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2014, Rafael J. Wysocki wrote:

> > How would you treat them specially?  Add a "runtime_pm_not_supported" 
> > flag?
> 
> I thought about a "runtime PM has been enabled at least once" flag rather
> that would be set by pm_runtime_enable() every time it is called and never
> cleared.  That would allow the core to distinguish between "runtime PM
> disabled temporarily" and "runtime PM not used" which turn out to be
> sufficiently different cases.

Interesting idea, but it can't tell the difference between "runtime PM
not supported" and "runtime PM not enabled yet".  I think a simple "not
supported" flag will be more straightforward.

> Yes.  The core definitely needs to be able to distinguish between the
> "runtime PM disabled temporarily" and "runtime PM not supported/not used"
> situations.

Let me work out a patch, and we'll see what you think.  For the time
being we can stick with our "runtime PM must be disabled (or in error)  
when the status is changed" approach.

Alan Stern

