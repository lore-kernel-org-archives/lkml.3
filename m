Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaJNSMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 14:12:37 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51940 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaJNSMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 14:12:36 -0400
In-Reply-To: <1413296756-25071-5-git-send-email-seth.forshee@canonical.com>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com> <1413296756-25071-5-git-send-email-seth.forshee@canonical.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
MIME-Version: 1.0
Subject: Re: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs only	with a
 mount option
X-KeepSent: D40DA8DF:F78EA39D-86257D71:0057C4DC;
 type=4; name=$KeepSent
X-Mailer: IBM Notes Release 9.0.1 October 14, 2013
From: Michael j Theall <mtheall@us.ibm.com>
Message-ID: <OFD40DA8DF.F78EA39D-ON86257D71.0057C4DC-86257D71.0064055D@us.ibm.com>
Date: Tue, 14 Oct 2014 13:12:26 -0500
X-MIMETrack: Serialize by Router on D03NM132/03/M/IBM(Release 9.0.1FP1|April  03, 2014) at
 10/14/2014 12:12:28,
	Serialize complete at 10/14/2014 12:12:28
Content-Type: text/plain; charset="US-ASCII"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101418-0029-0000-0000-000004E7F423
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> wrote on 10/14/2014 09:25:55 AM:

> From: Seth Forshee <seth.forshee@canonical.com>
> To: Miklos Szeredi <miklos@szeredi.hu>
> Cc: fuse-devel@lists.sourceforge.net, "Serge H. Hallyn" 
> <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, Seth 
> Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" 
> <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org
> Date: 10/14/2014 09:27 AM
> Subject: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs
> only with a mount option
> 
> Allowing unprivileged users to provide arbitrary xattrs via fuse
> mounts bypasses the normal restrictions on setting xattrs. Such
> mounts should be restricted to reading and writing xattrs in the
> user.* namespace.
> 

Can you explain how the normal restrictions on setting xattrs are 
bypassed?
My filesystem still needs security.* and system.*, and it looks like
xattr_permission already prevents non-privileged users from accessing
trusted.*

> It's difficult though to tell whether a mount is being performed
> on behalf of an unprivileged user since fuse mounts are ususally
> done via a suid root helper. Thus a new mount option,
> privileged_xattrs, is added to indicated that xattrs from other
> namespaces are allowed. This option can only be supplied by
> system-wide root; supplying the option as an unprivileged user
> will cause the mount to fail.

I can't say I'm convinced that this is the right direction to head.

Regards,
Michael Theall

