Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaJOPLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:11:07 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:60259 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaJOPLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:11:04 -0400
Date: Wed, 15 Oct 2014 17:11:00 +0200
From: Seth Forshee <seth.forshee@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] fuse: Restrict allow_other to uids already
 controlled by the user
Message-ID: <20141015151100.GA988@ubuntu-mba51>
Mail-Followup-To: Andy Lutomirski <luto@amacapital.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.sourceforge.net,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
 <1413296756-25071-4-git-send-email-seth.forshee@canonical.com>
 <543E8BB3.6040701@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543E8BB3.6040701@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 07:58:59AM -0700, Andy Lutomirski wrote:
> On 10/14/2014 07:25 AM, Seth Forshee wrote:
> > Unprivileged users are normally restricted from mounting with the
> > allow_other option by system policy, but this could be bypassed
> > for a mount done with user namespace root permissions. In such
> > cases allow_other should not allow users outside the user
> > namespace to access the mount as doing so would give the
> > unprivileged user the ability to manipulate processes it would
> > otherwise be unable to manipulate.
> 
> What threat is this intended to protect against?  I think that, if this
> is needed, tasks outside the userns or its descendents should be
> blocked, even if the user ids match.  That is, I think you should check
> the namespace, not the uid and gid.

allow_other is an existing option in fuse to protect against DoS
attacks against more privileged users by making file operations block
indefinitely. So this change makes it work the same way inside a user
namespace but only to users mapped into the namespace. Checking the
namespace does seem to make more sense, so I'll make that change.

Thanks,
Seth
