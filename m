Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaCQV0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:26:09 -0400
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:49795 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbaCQV0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:26:06 -0400
X-Greylist: delayed 15888 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2014 17:26:05 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=qZF0qCRIUCqM0EShqWIkr4hwOf9YwISARqEzmzDppKxDnQHiwxpE9+z2gM0PM5cy;
  h=Received:From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:Thread-Index:Content-Language:X-Antivirus-Status:X-ELNK-Trace:X-Originating-IP;
From: "Frank Filz" <ffilzlnx@mindspring.com>
To: "'Aneesh Kumar K.V'" <aneesh.kumar@linux.vnet.ibm.com>,
        "'Michael Kerrisk'" <mtk.manpages@gmail.com>
Cc: "'Andreas Dilger'" <adilger@dilger.ca>, <linux-man@vger.kernel.org>,
        "'Miklos Szeredi'" <miklos@szeredi.hu>, "'NeilBrown'" <neilb@suse.de>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Linux-Fsdevel'" <linux-fsdevel@vger.kernel.org>,
        "'Ganesha NFS List'" <nfs-ganesha-devel@lists.sourceforge.net>
References: <CAHO5Pa0Y8r1DxHTc0YN-4geoLJ3JYwHT99EcuaGL6k++ek+aEQ@mail.gmail.com> <8761netc3z.fsf@linux.vnet.ibm.com>
In-Reply-To: <8761netc3z.fsf@linux.vnet.ibm.com>
Subject: RE: [Nfs-ganesha-devel] name_to_handle_at() and persistent	filesystem IDs
Date: Mon, 17 Mar 2014 10:01:03 -0700
Message-ID: <009901cf4202$7c310970$74931c50$@mindspring.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQM1Yw7w6Vp4EG3t/yazwK6rQGgzoQIOALWGmAjOBTA=
Content-Language: en-us
X-Antivirus: avast! (VPS 140317-0, 03/17/2014), Outbound message
X-Antivirus-Status: Clean
X-ELNK-Trace: 136157f01908a8929c7f779228e2f6aeda0071232e20db4dba50757a2fa0a19859796e662643a722350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.236.153.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Michael Kerrisk <mtk.manpages@gmail.com> writes:
> 
> > Hello Aneesh,
> >
> > I'm currently working on a man page for name_to_handle_at() and
> > open_by_handle_at(), and I have a question relating to a point that
> > probably needs to be covered in the man page.
> >
> > Back in July 2010, in this thread:
> > http://thread.gmane.org/gmane.linux.file-systems/41782/focus=43131
> > you said:
> >
> > [[
> > mount id should not be looked at as a persistent identifier. It should
> > be used to derive a persistent identifier from /proc/self/mountinfo.
> > The persistent identifier could be the combination of device
> > properties, file system properties or the uuid which is going to be an
> > optional tag in /proc/self/mountinfo.
> > ]]
> >
> > In the man page, I'd like to briefly describe how one derives such a
> > persistent ID from mountinfo. AFAICS, the optional UUID tag in
> > /proc/self/mountinfo has not come to pass. So, what then is the
> > recommended practice for deriving the persistent ID?
> >
> 
> Anything that work for the application. mount_id will indicate which mount
it
> is ie. from /proc/self/mountinfo
> 
> 30 20 8:1 / /boot rw,relatime - ext4 /dev/sda1 rw,data=ordered
> 
> The value 30 helps us to figure out that we are looking at device
/dev/sda1.
> With that we can derive the uuid using libblkid.  I am not sure we
concluded
> anything really about how to identify an nfs mount. May be we can do that
> based on server and mount point details ?.But from the syscall point, what
> we return is mount_id, which gives a hint regarding which mount point we
> are talking about in /proc/self/mountinfo. From that information
applications
> can use any method that work for them to derivce an unique identifier.
> 
> I know that NFS ganesha use these syscall. May we can check with them
> what worked for them ? (Added to CC:)

Ganesha ignores the mount id. It's not really clear how it would be used
(would it help detect file system junctions?) since it isn't required on
open_by_handle_at, it's just a return param from name_to_handle_at.

Frank

