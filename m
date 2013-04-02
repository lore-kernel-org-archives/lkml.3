Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761789Ab3DBNjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:39:03 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:57069 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761203Ab3DBNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:38:59 -0400
Message-ID: <1364909922.3617.41.camel@thor.lan>
Subject: Re: n_tty_write() going into schedule but NOT coming out
From: Peter Hurley <peter@hurleysoftware.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>
Date: Tue, 02 Apr 2013 09:38:42 -0400
In-Reply-To: <515ADC96.7090908@synopsys.com>
References: <5156DC21.20901@synopsys.com> <5159925B.5050806@synopsys.com>
	 <1364829008.3617.21.camel@thor.lan> <515ADC96.7090908@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 18:56 +0530, Vineet Gupta wrote:
> On 04/01/2013 08:40 PM, Peter Hurley wrote:
> > On Mon, 2013-04-01 at 19:27 +0530, Vineet Gupta wrote:
> >> On 03/30/2013 06:05 PM, Vineet Gupta wrote:
> >>> Hung find task is sitting in the schedule() call in n_tty_write()
> >>>
> >>> [ARCLinux]$ cat /proc/281/stack
> >>> [<8065945e>] n_tty_write+0x23a/0x424
> >>> [<80655cd4>] tty_write+0x1ac/0x2d4
> >>> [<805976ba>] vfs_write+0x92/0x110
> >>> [<80597816>] sys_write+0x4e/0x88
> >>> [<8050e780>] ret_from_system_call+0x0/0x4
> > Likely the writer is stuck because the receive buffer is full and the
> > reader is hung. What are the respective shells and telnetd doing?
> 
> I don't undersand how the receive buffer full/empty is coming into play - that
> schedule() call is not a wait queue or something

If n_tty_write() blocks [the schedule() call], then it is on a wait
queue (tty->write_wait) which is woken by pty's unthrottle() called from
n_tty_read from the linked pty when space becomes available in the
receive buffer.



