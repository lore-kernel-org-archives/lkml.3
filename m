Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaHRUiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 16:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbaHRUiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 16:38:16 -0400
Date: Mon, 18 Aug 2014 16:38:08 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/5] softlockup: make detector be aware of task switch of
 processes hogging cpu
Message-ID: <20140818203801.GE49576@redhat.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-3-git-send-email-dzickus@redhat.com>
 <20140818090319.GA25495@gmail.com>
 <20140818150658.GQ49576@redhat.com>
 <20140818180158.GA4540@gmail.com>
 <20140818184339.GB49576@redhat.com>
 <20140818190200.GB5074@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818190200.GB5074@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 09:02:00PM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > > > > So I agree with the motivation of this improvement, but 
> > > > > is this implementation namespace-safe?
> > > > 
> > > > What namespace are you worried about colliding with?  I 
> > > > thought softlockup_ would provide the safety??  Maybe I 
> > > > am missing something obvious. :-(
> > > 
> > > I meant PID namespaces - a PID in itself isn't guaranteed 
> > > to be unique across the system.
> > 
> > Ah, I don't think we thought about that.  Is there a better 
> > way to do this?  Is there a domain id or something that can 
> > be OR'd with the pid?
> 
> What is always unique is the task pointer itself. We use pids 
> when we interface with user-space - but we don't really do that 
> here, right?

No, I don't believe so.  Ok, so saving 'current' and comparing that should
be enough, correct?

Cheers,
Don
