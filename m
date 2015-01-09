Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbbAIVBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:01:09 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58244 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbbAIVBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:01:07 -0500
Message-ID: <1420837263.31986.0.camel@gmail.com>
Subject: Re: noisy selinux messages on tmpfs mount.
From: Dominick Grift <dac.override@gmail.com>
To: Paul Moore <pmoore@redhat.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, Stephen Smalley <sds@epoch.ncsc.mil>,
        James Morris <james.l.morris@oracle.com>,
        selinux <selinux@tycho.nsa.gov>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 09 Jan 2015 22:01:03 +0100
In-Reply-To: <6645675.NppomaThWx@sifl>
References: <20150108190822.GB4365@codemonkey.org.uk>
	 <CAB9W1A2nTN2DJ699BXL_r_aXCk-O9-KrTLSi731isQWpPUmkwg@mail.gmail.com>
	 <20150109191329.GA19400@codemonkey.org.uk> <6645675.NppomaThWx@sifl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9 (3.12.9-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 15:55 -0500, Paul Moore wrote:
> On Friday, January 09, 2015 02:13:29 PM Dave Jones wrote:
> > On Fri, Jan 09, 2015 at 08:06:49AM -0500, Stephen Smalley wrote:
> >  > We already reduced that message to KERN_DEBUG.  Is that not sufficient?
> > 
> > That doesn't really help with the flooding of dmesg, so no.
> > I should also note that it's not just logging in that creates a new
> > session, it also seems to be getting triggered by cron jobs, or
> > whatever the systemd replacement is.
> 
> I wonder if this is cron/systemd/whatever creating a new namespace and 
> mounting a new tmpfs in the namespace?  If yes, I wonder if we could limit the 
> messages to the initial namespace ... ?
> 

It is systemd logind creating sessions (e.g. creating /run/user/$UID and
mounting a tmpfs on it)




