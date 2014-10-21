Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaJUXOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 19:14:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbaJUXOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 19:14:17 -0400
From: Paul Moore <pmoore@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] audit: log join and part events to the read-only multicast log socket
Date: Tue, 21 Oct 2014 19:14:16 -0400
Message-ID: <22812928.JUueEH5vDi@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1413930629.30946.68.camel@localhost>
References: <30ef5c1ba42b52953e5684a0322975c3f0fadc77.1412706089.git.rgb@redhat.com> <20141021210511.GL15532@madcap2.tricolour.ca> <1413930629.30946.68.camel@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2014 06:30:29 PM Eric Paris wrote:
> I've always hated the fact that we include this in ANY current audit
> message.  I truly believe we need two new record types.
> 
> AUDIT_PROCESS_INFO
> AUDIT_EXTENDED_PROCESS_INFO
> 
> What does my UID have to do with a syscall?  Why is it in the record?
> It's a pretty big change, like, RHEL8, but splitting the reporting of
> process info from other records will make all matter of things, in the
> kernel and in userspace so much cleaner...
> 
> Nuts:
> type=SYSCALL msg=audit(10/13/2014 03:07:39.919:117953) : arch=x86_64
> syscall=stat success=yes exit=0 a0=0x1332f60 a1=0x7fff8749e6d0
> a2=0x7fff8749e6d0 a3=0x0 items=1 ppid=28212 pid=30066 auid=root uid=root
> gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root
> tty=(none) ses=367 comm=lsof exe=/usr/sbin/lsof
> subj=system_u:system_r:system_cronjob_t:s0-s0:c0.c1023 key=(null)
> 
> Slightly (and yes, just slightly) Less Nuts:
> type=SYSCALL msg=audit(10/13/2014 03:07:39.919:117953) : arch=x86_64
> syscall=stat success=yes exit=0 a0=0x1332f60 a1=0x7fff8749e6d0
> a2=0x7fff8749e6d0 a3=0x0 type=AUDIT_PROCESS_INFO msg=audit(10/13/2014
> 03:07:39.919:117953) : pid=30066 auid=root uid=root gid=root tty=(none)
> ses=367 comm=lsof exe=/usr/sbin/lsof
> subj=system_u:system_r:system_cronjob_t:s0-s0:c0.c1023 key=(null)
> type=AUDIT_EXTENDED_PROCESS_INFO msg=audit(10/13/2014 03:07:39.919:117953)
> : ppid=28212 euid=root suid=root fsuid=root egid=root sgid=root fsgid=root
> key=(null)
> 
> It'd be weird is a syscall record actually only had syscall information....

I'm definitely in favor of this change.  We already have the concept of 
multiple records per event, we should use this to our advantage to make things 
a bit more sane.

-- 
paul moore
security and virtualization @ redhat

