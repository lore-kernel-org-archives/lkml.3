Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaFAG0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 02:26:15 -0400
Received: from tango.0pointer.de ([85.214.72.216]:34508 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaFAG0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 02:26:13 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2014 02:26:12 EDT
Date: Sun, 1 Jun 2014 08:15:47 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, luto@mit.edu,
        Keir Fraser <keir@xen.org>, Tim Deegan <tim@xen.org>,
        Ian Jackson <ian.jackson@eu.citrix.com>, linux-kernel@vger.kernel.org,
        systemd-devel@lists.freedesktop.org,
        linux-security-module@vger.kernel.org, ebiederm@xmission.com,
        Jan Beulich <jbeulich@suse.com>, xen-devel@lists.xenproject.org,
        morgan@kernel.org
Subject: Re: [systemd-devel] [PATCH v5 12/14] autoconf: xen: enable
 explicit 	preference	option for xenstored preference
Message-ID: <20140601061547.GC16257@tango.0pointer.de>
References: <1400589095-3872-1-git-send-email-mcgrof@do-not-panic.com>
 <1400589095-3872-13-git-send-email-mcgrof@do-not-panic.com>
 <1400687040.7272.28.camel@kazak.uk.xensource.com>
 <20140521230233.GA13289@wotan.suse.de>
 <1400753147.14637.10.camel@kazak.uk.xensource.com>
 <20140523232031.GA26450@wotan.suse.de>
 <1401269449.24800.7.camel@kazak.uk.xensource.com>
 <20140529232918.GG26450@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529232918.GG26450@wotan.suse.de>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30.05.14 01:29, Luis R. Rodriguez (mcgrof@suse.com) wrote:

> I'm cc'ing a few security folks as I'd appreciate review on the ideas here,
> in particular that of a launcher idea on system to replace alternatives on the
> ExecStart= line of a systemd service unit file, alternative ideas are of
> course welcomed. I'm also Cc'ing systemd-devel as this subject was reviewed
> a little while ago with nothing concrete being recommended but instead a few
> options being now archived as possibilities. I'm looking for a bit wider
> review of the approaches and recomendations.
> 
> Some general background for non xen folks: old xen requires the launch of
> a daemon which implements supports of the xenstore, which is the database
> that xen uses for information about guests / dom0. There are two supported
> daemons, xenstored (C version) and oxenstored (Ocaml version) but they do the
> same thing. Right now old init lets you override which one you pick through
> an environment variable on /etc/{sysconfig,default}/xencommons, the script
> will use the appropriate on there. Systemd doesn't let you use variables on
> the ExecStart line of a service unit file so alternatives are required.
> 
> The reason I'm being very careful here this could set a precedent and at
> least for the launcher idea it'd require the usage of getenv() and execve(),
> and secure alternatives for these (secure_getenv(), execve_nosecurity())
> have either been merged or suggested before for Linux. The systemd discussion
> is only specific to Linux but if we have a launcher we could consider it for
> other supported OSes. All that said I'd like proper review of the security
> implications of *all* strategies but obviously in particular the launcher
> idea. I want to tread carefuly before setting precedents.

You can also just invoke a shell script from ExecStart=. I mean, we try
to deemphesize them in the boot process, but there's nothing wrong with
using shell, if you need to parse shell configuraiton fragments and just
want to execute on ot another program...

That said, I'd certainly make a clean cut and drop support for
/etc/sysconfig from any project I see, earlier rather than later, since
it's just cruft, a bad idea and should really just go away. But then
again, I would also just not do the thing with supporting two
implementations at the same time... 

Lennart

-- 
Lennart Poettering, Red Hat
