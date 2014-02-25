Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaBYQDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:03:13 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:39406 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaBYQDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:03:11 -0500
X-Greylist: delayed 2304 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 11:03:11 EST
Date: Tue, 25 Feb 2014 15:24:43 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jim McDonough <jmcd@samba.org>, Jeff Layton <jlayton@redhat.com>,
        David Disseldorp <ddiss@samba.org>, Steve French <smfrench@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Stable backport of cifs nlink workaround?
Message-ID: <20140225152443.GA15552@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any chance that 74d290da476f672ad756634d12aa707375d3564d
([CIFS] Provide sane values for nlink) could be backported to the stable
3.2 kernel?

The reason I ask is because if you Using a Debain Wheezy box with a
3.2.41-2+deb7u2 kernel the following is problematic:

Mount a share using cifs from a Windows 2008 machine on to 2008share
Use Samba 3.6 to export the share as //linux/2008share
Using a Windows 2012 machine browse to \\linux\2008share

because the directories will appear to be files to the Windows 2012
machine.

On the Debian box doing
stat 2008share/dir
says
Device: 18h/24d	Inode: 844424932383132  Links: 1

Using a Fedora 20 box with a 3.13.3-201.fc20.x86_64 kernel to do the
same says:
Device: 27h/39d	Inode: 844424932383132  Links: 2

In https://bugzilla.kernel.org/show_bug.cgi?id=52791#c4 Jeff mentions
that if there were demand a RHEL 6 customer could ask for a backport so
it looks like the change is isolated enough to be put into stable...

https://bugzilla.samba.org/show_bug.cgi?id=9346 also talks about the
issue.

-- 
Sitsofe | http://sucs.org/~sits/
