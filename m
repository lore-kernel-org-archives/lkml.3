Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbbA0Vfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:35:37 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52354 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbA0Vff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:35:35 -0500
Date: Wed, 28 Jan 2015 00:35:32 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>, Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Calvin Owens <calvinowens@fb.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150127213532.GP651@moon>
References: <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
 <20150124031544.GA1992748@mail.thefacebook.com>
 <20150126124731.GA26916@node.dhcp.inet.fi>
 <20150126210054.GG651@moon>
 <20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
 <CAGXu5jLDkg0hJSMm3CdoO-77yiK5GQWHSe3+1h7mq76LERpNBA@mail.gmail.com>
 <20150127073713.GJ651@moon>
 <CAGXu5jJFFib7F7uKYgvX4ecyMnbincd22FaO_bFy=VRVKdFbvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJFFib7F7uKYgvX4ecyMnbincd22FaO_bFy=VRVKdFbvA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 11:53:19AM -0800, Kees Cook wrote:
> >>
> >> Are mount namespaces handled in this output?
> >
> > Could you clarify this moment, i'm not sure i get it.
> 
> I changed how I asked this question in my review of the documentation,
> but it looks like these symlinks aren't "regular" symlinks (that are
> up to the follower to have access to the file system path shown), but
> rather they bypass VFS. As a result, I'm wondering how things like
> mount namespaces might change this behavior: what is shown, the path
> from the perspective of the target, or from the viewer (which may be
> in separate mount namespaces).

I must admit I personally didn't investigating how mount namespaces
might itercat with map-files. Pavel, could you share the thoughts?
