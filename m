Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3DPHYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:24:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab3DPHYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:24:17 -0400
Message-ID: <1366097041.4583.13.camel@marge.simpson.net>
Subject: Re: Very poor latency when using hard drive (raid1)
From: Mike Galbraith <bitbucket@online.de>
To: lkml@tigusoft.pl
Cc: linux-kernel@vger.kernel.org
Date: Tue, 16 Apr 2013 09:24:01 +0200
In-Reply-To: <kkis9q$g09$1@ger.gmane.org>
References: <kkgj31$jc6$1@ger.gmane.org> <kkis9q$g09$1@ger.gmane.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:vW75oxudd1g1TfcTAo1UVXAIycxu9GJCOzpovOo3XLJ
 IxQESiqgBHZ5oJTpbGv4m1DLZy3Wfgs7uzqEhf/5Z/EHT3WoWI
 orHoGk8JbKkOk+hydSlEwhEEv5zMbXLMYPguDiI8vPDqDUtnZ7
 TuVt1eMamP8/ulC0FaMhtTSETJ697WM2+uN6xtMkWY/SxjOdun
 Qa+NXnBS2nUw/h9JG0WA/XN8v2bPTEAijjut//iEC+DYro2Hrp
 2wv8T1Z8F0N1G1m9Asp36iEZ24eMcoaDnr45WNJlRhcnQPFJKd
 AFE4xs7g6jd6TDWZxIDJZT2qFh5xTM1DeTYbgtx0h/SsoZGMav
 Q1ILyQ/bctHj6UIKmaAkevo9O/TYYfDVrs9BbgRVQ+9lHAuau0
 lX2gtMu49dcfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-16 at 08:49 +0200, lkml@tigusoft.pl wrote: 
> On 15/04/13 11:59, lkml@tigusoft.pl wrote:
> > There are 2 hard drives (normal, magnetic) in software raid 1
> > on 3.2.41 kernel.
> > 
> > When I write into them e.g. using dd from /dev/zero to a local file
> > (ext4 on default settings), running 2 dd at once (writing two files) it
> > starves all other programs that try to use the disk.
> > 
> > Running ls on any directory on same disk (same fs btw), takes over half
> > minute to execute, same for any other disk touching action.
> > 
> > Did anyone seen such problem, where too look, what to test?
> > 
> > What could solve it (other then ionice on applications that I expect to
> > use hard drive)?
> 
> I got reply (by e-mail) suggesting to use XFS.
> Thanks, possible for other/next server.
> 
> But I fell this should work correctly as well on ext4.

It should not starve readers that badly, something is wrong.

You can try setting low_latency for the devices if you're using CFQ
ioscheduler.  For my box, that would be..

echo 1 > /sys/devices/pci0000:00/0000:00:1f.2/ata2/host0/target0:0:0/0:0:0:0/block/sda/queue/iosched/low_latency

Or, you can try a different scheduler.  cat (blabla)/sda/queue/scheduler
to see which choices are available, and echo your choice back to the
file to select it.

-Mike

