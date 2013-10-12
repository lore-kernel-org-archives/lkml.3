Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3JLSML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 14:12:11 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:39297 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198Ab3JLSMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 14:12:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=szEXKcbJxY0/R8AjauZ1u+tkbcwE1nSzIYEX0hRLwckvVwVNGHWdwZLcvS/EXhbl;
  h=Received:From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:Thread-Index:Content-Language:X-ELNK-Trace:X-Originating-IP;
From: "Frank Filz" <ffilzlnx@mindspring.com>
To: "'Jeff Layton'" <jlayton@redhat.com>,
        "'Scott Lovenberg'" <scott.lovenberg@gmail.com>
Cc: "'Jeremy Allison'" <jra@samba.org>, "'Andreas Dilger'" <adilger@dilger.ca>,
        <linux-fsdevel@vger.kernel.org>,
        "'Ganesha NFS List'" <nfs-ganesha-devel@lists.sourceforge.net>,
        <samba-technical@lists.samba.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>	<20131011200756.GB22160@fieldses.org>	<EE732BCB-C38E-4874-AEDF-2EB9E1389A86@dilger.ca>	<20131011192118.483e436f@tlielax.poochiereds.net>	<20131011234923.GD8688@samba2>	<B0205F0B-0AC4-4B80-91C2-E3BD2D4B8E81@gmail.com> <20131011204244.72c2d672@corrin.poochiereds.net>
In-Reply-To: <20131011204244.72c2d672@corrin.poochiereds.net>
Subject: RE: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX) locks
Date: Sat, 12 Oct 2013 11:12:03 -0700
Message-ID: <024101cec776$8f004130$ad00c390$@mindspring.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIaxc2XaXMwhFVmMgrl8lqeyFTt4AHYOUbiArnvCugBgxKMZgIPcxlDA0h1vzIB7gYOMJjuhyEw
Content-Language: en-us
X-ELNK-Trace: 136157f01908a8929c7f779228e2f6aeda0071232e20db4dd14ff0356e43788764bd315707775cfa350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.236.153.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This blog post of Jeremy's explains some of the history:
> 
> 
> http://www.samba.org/samba/news/articles/low_point/tale_two_stds_os2
> .html
> 
> See the section entitled "First Implementation Past the Post".

Interesting that Jeremy actually suggested the implementation should have
had an arbitrary lock owner as part of the flock structure:

"This is an example of a POSIX interface not being future-proofed against
modern techniques such as threading. A simple amendment to the original
primitive allowing a user-defined "locking context" (like a process id) to
be entered in the struct flock structure used to define the lock would have
fixed this problem, along with extra flags allowing the number of locks per
context to be recorded if needed."

But I'm happy with the lock context per kernel struct file as a solution,
especially since that will allow locks to be sensibly passed to a forked
process.

Another next step would be an asynchronous blocking lock...

Frank


