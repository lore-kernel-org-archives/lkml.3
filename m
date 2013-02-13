Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab3BMEQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 23:16:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab3BMEQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 23:16:35 -0500
Date: Tue, 12 Feb 2013 23:16:29 -0500
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130213041629.GA28622@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20130212193901.GA18906@redhat.com>
 <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com>
 <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 04:56:55PM -0800, Hugh Dickins wrote:
 
 > > so I can hit this pretty quickly with this..
 > > 
 > > while [ 1 ];
 > > do
 > >  rtcwake -s 5 -m no ; pm-suspend
 > > done
 > > 
 > > Which should make it bisectable at least..
 > 
 > Thanks, I'll give that a try this evening.
 
So uh, put a 'sleep 5' in that loop.

Turns out that the firmware on my Thinkpad craps itself when it tries to suspend while
the cpu fan is still spinning back up, and eventually it gets in a state (on a 'good' boot)
where the fan is stuck in the 'off' state.

Result: hot laptop, machine check exceptions, and then a nice
"CPU FAN ERROR" message from the BIOS on next reboot.

Full marks Lenovo.

	Dave
