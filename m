Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaBYP3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:29:42 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:47034 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaBYP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:29:40 -0500
MIME-Version: 1.0
In-Reply-To: <20140225152443.GA15552@sucs.org>
References: <20140225152443.GA15552@sucs.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 25 Feb 2014 09:29:20 -0600
Message-ID: <CAH2r5mvO+E9ouaEOBL-08pKZXo+C-KdWCsELpiqocLT4itradw@mail.gmail.com>
Subject: Re: Stable backport of cifs nlink workaround?
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jim McDonough <jmcd@samba.org>, Jeff Layton <jlayton@redhat.com>,
        David Disseldorp <ddiss@samba.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is a little larger than usual for stable but for those where
the backport is trivial, seems reasonable candidate for stable.

On Tue, Feb 25, 2014 at 9:24 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> Hi,
>
> Is there any chance that 74d290da476f672ad756634d12aa707375d3564d
> ([CIFS] Provide sane values for nlink) could be backported to the stable
> 3.2 kernel?
>
> The reason I ask is because if you Using a Debain Wheezy box with a
> 3.2.41-2+deb7u2 kernel the following is problematic:
>
> Mount a share using cifs from a Windows 2008 machine on to 2008share
> Use Samba 3.6 to export the share as //linux/2008share
> Using a Windows 2012 machine browse to \\linux\2008share
>
> because the directories will appear to be files to the Windows 2012
> machine.
>
> On the Debian box doing
> stat 2008share/dir
> says
> Device: 18h/24d Inode: 844424932383132  Links: 1
>
> Using a Fedora 20 box with a 3.13.3-201.fc20.x86_64 kernel to do the
> same says:
> Device: 27h/39d Inode: 844424932383132  Links: 2
>
> In https://bugzilla.kernel.org/show_bug.cgi?id=52791#c4 Jeff mentions
> that if there were demand a RHEL 6 customer could ask for a backport so
> it looks like the change is isolated enough to be put into stable...
>
> https://bugzilla.samba.org/show_bug.cgi?id=9346 also talks about the
> issue.
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Thanks,

Steve
