Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646Ab3B0SN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:13:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab3B0SNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:13:24 -0500
Date: Wed, 27 Feb 2013 13:13:11 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Kees Cook <kees@outflux.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, eparis@redhat.com,
        Christian Kujau <lists@nerdbynature.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Message-ID: <20130227181311.GI2071@hansolo.jdub.homelinux.org>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
 <20130227180547.GR26411@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227180547.GR26411@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:05:47AM -0800, Kees Cook wrote:
> Hi,
> 
> On Fri, Feb 22, 2013 at 01:18:57PM -0500, Josh Boyer wrote:
> > Originally, the addition of dmesg_restrict covered both the syslog
> > method of accessing dmesg, as well as /dev/kmsg itself.  This was done
> > indirectly by security_syslog calling cap_syslog before doing any LSM
> > checks.
> 
> Actually, are the security_syslog() checks in /dev/kmsg correct? There is
> only one used in devkmsg_open which uses SYSLOG_ACTION_READ_ALL. Shouldn't
> it be using SYSLOG_ACTION_OPEN? And have SYSLOG_ACTION_READ_ALL added to
> devkmsg_read? (And should we add one for write?)

You ask wonderful questions!  I have no idea.  Either way, it needs to
still somehow check for capable(CAP_SYSLOG) which security_syslog
doesn't do.  So either what I have already, or your suggestion of using
the existing function with SYSLOG_ACTION_OPEN in devkmsg_open.

josh
