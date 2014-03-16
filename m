Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaCPPIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 11:08:49 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53514 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaCPPIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 11:08:47 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bruce Fields <bfields@fieldses.org>, linux-man@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>
Subject: Re: name_to_handle_at() and persistent filesystem IDs
In-Reply-To: <CAHO5Pa0Y8r1DxHTc0YN-4geoLJ3JYwHT99EcuaGL6k++ek+aEQ@mail.gmail.com>
References: <CAHO5Pa0Y8r1DxHTc0YN-4geoLJ3JYwHT99EcuaGL6k++ek+aEQ@mail.gmail.com>
User-Agent: Notmuch/0.17+7~gc734dd75344e (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 16 Mar 2014 20:38:32 +0530
Message-ID: <8761netc3z.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031615-9264-0000-0000-000005A5640C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> writes:

> Hello Aneesh,
>
> I'm currently working on a man page for name_to_handle_at() and
> open_by_handle_at(), and I have a question relating to a point that
> probably needs to be covered in the man page.
>
> Back in July 2010, in this thread:
> http://thread.gmane.org/gmane.linux.file-systems/41782/focus=43131
> you said:
>
> [[
> mount id should not be looked at as a persistent identifier. It should
> be used to derive a persistent identifier from /proc/self/mountinfo. The
> persistent identifier could be the combination of device properties,
> file system properties or the uuid which is going to be an optional
> tag in /proc/self/mountinfo.
> ]]
>
> In the man page, I'd like to briefly describe how one derives such a
> persistent ID from mountinfo. AFAICS, the optional UUID tag in
> /proc/self/mountinfo has not come to pass. So, what then is the
> recommended practice for deriving the persistent ID?
>

Anything that work for the application. mount_id will indicate which
mount it is ie. from /proc/self/mountinfo

30 20 8:1 / /boot rw,relatime - ext4 /dev/sda1 rw,data=ordered

The value 30 helps us to figure out that we are looking at device
/dev/sda1. With that we can derive the uuid using libblkid.  I am not sure we
concluded anything really about how to identify an nfs mount. May be we
can do that based on server and mount point details ?.But from the
syscall point, what we return is mount_id, which gives a hint regarding
which mount point we are talking about in /proc/self/mountinfo. From
that information applications can use any method that work for them
to derivce an unique identifier.

I know that NFS ganesha use these syscall. May we can check with them
what worked for them ? (Added to CC:)
 
-aneesh

