Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650Ab3B0SF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:05:56 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46046 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760238Ab3B0SFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:05:55 -0500
Date: Wed, 27 Feb 2013 10:05:47 -0800
From: Kees Cook <kees@outflux.net>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, eparis@redhat.com,
        Christian Kujau <lists@nerdbynature.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Message-ID: <20130227180547.GR26411@outflux.net>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 22, 2013 at 01:18:57PM -0500, Josh Boyer wrote:
> Originally, the addition of dmesg_restrict covered both the syslog
> method of accessing dmesg, as well as /dev/kmsg itself.  This was done
> indirectly by security_syslog calling cap_syslog before doing any LSM
> checks.

Actually, are the security_syslog() checks in /dev/kmsg correct? There is
only one used in devkmsg_open which uses SYSLOG_ACTION_READ_ALL. Shouldn't
it be using SYSLOG_ACTION_OPEN? And have SYSLOG_ACTION_READ_ALL added to
devkmsg_read? (And should we add one for write?)

-Kees

-- 
Kees Cook
Chrome OS Security
