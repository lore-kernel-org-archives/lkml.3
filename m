Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaKKP1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:27:34 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:57906 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKKP1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:27:32 -0500
Date: Tue, 11 Nov 2014 09:27:29 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, seth.forshee@canonical.com
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of
 init_user_ns
Message-ID: <20141111152729.GB7906@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Michael j Theall <mtheall@us.ibm.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
 <20141111140454.GD333@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111140454.GD333@tucsk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 03:04:54PM +0100, Miklos Szeredi wrote:
> On Wed, Oct 22, 2014 at 04:24:18PM -0500, Seth Forshee wrote:
> > Update fuse to translate uids and gids to/from the user namspace
> > of the process servicing requests on /dev/fuse. Any ids which do
> > not map into the namespace will result in errors. inodes will
> > also be marked bad when unmappable ids are received from
> > userspace.
> 
> Okay.
> 
> > Due to security concerns the namespace used should be fixed,
> > otherwise a user might be able to gain elevated privileges or
> > influence processes that the user would otherwise be unable to
> > manipulate. Thus the namespace of the mounting process is used
> > for all translations, and this namespace is required to be the
> > same as the one in use when /dev/fuse was opened.
> 
> Maybe I'm being dense, but can someone give a concrete example of such an
> attack?

I'm repeating myself, but the only specific example I'm aware of is the
suid example with is prevented by other mechanisms (both in fuse and in
Andy's proposed patch). Perhaps Eric or Andy could give examples of
other potential problems, and I'll also see what I can come up with.

> That might also help me understand how exactly user/pid namespaces work...
> 
> Patch otherwise looks okay.

Great, thanks for the review.

Seth

> 
> Thanks,
> Miklos
