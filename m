Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaFCMY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:24:27 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59038 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaFCMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:24:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        hpa@zytor.com, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org, cluster-devel@redhat.com, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, fuse-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        linux-scsi@vger.kernel.org, logfs@logfs.org,
        ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org,
        samba-technical@lists.samba.org, xfs@oss.sgi.com
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Tue, 03 Jun 2014 14:21:29 +0200
Message-ID: <7080340.W1OdttOEiZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1401546649.2413.6.camel@slavad-CELSIUS-H720>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401546649.2413.6.camel@slavad-CELSIUS-H720>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GCyaEvXF+a6CqYvAIaD0XSvsGbKpYYC5pdLSfa2ibf4
 Pcj0L183367z9YpUfkI0zMCoBBAbor65lVV3SpkMzMdFMcwDHc
 cfAnvxNh7gW05d7+o+2el/OyWfxkhvcR0D0Tb+xV0Vy5dpH91o
 pY4UZWrXwtr0Iq1SGVphgKfFWLfR0I4CVnsuBM+kRZO9FYi/SO
 hytz0QhkW+DkpzflHPftTZGti1QrvH+Dd8NpzmjCujnVW5uKwj
 EMMCCvOmtUw3TITRCAG0/rmMrwDreABG+IcFMdFwLUFBRDe7sI
 ErjL/tgjro7hcPU/n6EnFUG2bHXpmp6ss/j16yfdHv2ynJlUjA
 lE8GQX1SC90Ljh0tuiGQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2014 18:30:49 Vyacheslav Dubeyko wrote:
> By the way, what about NILFS2? Is NILFS2 ready for suggested approach
> without any changes?

nilfs2 and a lot of other file systems don't need any changes for
this, because they don't assign the inode time stamp fields to
a 'struct timespec'.

FWIW, nilfs2 uses a 64-bit seconds value, which is always safe and
can represent the full range of user space timespec on all machines.

	Arnd
