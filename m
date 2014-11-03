Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaKCRPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:15:25 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60155 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaKCRPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:15:19 -0500
Date: Mon, 3 Nov 2014 11:15:15 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20141103171515.GB7554@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Michael j Theall <mtheall@us.ibm.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:24:16PM -0500, Seth Forshee wrote:
> Here's another update to the patches to enable userns mounts in fuse.
> The changes this time around center on xattrs and allow_other. I'm
> considering the following patch to be a prerequisite for this series:
> 
> http://lkml.kernel.org/g/252a4d87d99fc2b5fe4411c838f65b312c4e13cd.1413330857.git.luto@amacapital.net
> 
> With this patch I'm dropping the xattr restrictions from the v4 patches.
> This leaves the situation with xattrs unchanged in init_user_ns. A fuse
> userns mount could still supply xattrs which the user would normally be
> unable to set, but since the mount will be inaccessible outside of that
> userns or its descendants those xattrs will never be seen by the host.
> 
> I'm also in agreement with Andy that some decision regarding this patch
> should be made before merging the fuse userns support as well:
> 
> http://lkml.kernel.org/g/2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net
> 
> Changes since v4:
>  - Drop patch to restrict xattrs
>  - Update allow_other to restrict based on userns of current rather than
>    uid/gid

Miklos, Eric - Any feedback from either of you on these patches?

Thanks,
Seth
