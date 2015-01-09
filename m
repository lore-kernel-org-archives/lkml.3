Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbbAIUzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:55:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbbAIUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:55:47 -0500
From: Paul Moore <pmoore@redhat.com>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Stephen Smalley <stephen.smalley@gmail.com>,
        selinux <selinux@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Smalley <sds@epoch.ncsc.mil>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: noisy selinux messages on tmpfs mount.
Date: Fri, 09 Jan 2015 15:55:37 -0500
Message-ID: <6645675.NppomaThWx@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150109191329.GA19400@codemonkey.org.uk>
References: <20150108190822.GB4365@codemonkey.org.uk> <CAB9W1A2nTN2DJ699BXL_r_aXCk-O9-KrTLSi731isQWpPUmkwg@mail.gmail.com> <20150109191329.GA19400@codemonkey.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 09, 2015 02:13:29 PM Dave Jones wrote:
> On Fri, Jan 09, 2015 at 08:06:49AM -0500, Stephen Smalley wrote:
>  > We already reduced that message to KERN_DEBUG.  Is that not sufficient?
> 
> That doesn't really help with the flooding of dmesg, so no.
> I should also note that it's not just logging in that creates a new
> session, it also seems to be getting triggered by cron jobs, or
> whatever the systemd replacement is.

I wonder if this is cron/systemd/whatever creating a new namespace and 
mounting a new tmpfs in the namespace?  If yes, I wonder if we could limit the 
messages to the initial namespace ... ?

-- 
paul moore
security @ redhat

