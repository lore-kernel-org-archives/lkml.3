Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab3GDCdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 22:33:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3GDCdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 22:33:02 -0400
Date: Wed, 3 Jul 2013 23:32:40 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Karen Noel <knoel@redhat.com>, Rik van Riel <riel@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: watchdog: print stolen time increment at softlockup detection
Message-ID: <20130704023240.GA7454@amt.cnet>
References: <20130628025723.GA12719@amt.cnet>
 <20130628141215.GF126784@redhat.com>
 <20130628203739.GA25847@amt.cnet>
 <20130703164401.GS126784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703164401.GS126784@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 12:44:01PM -0400, Don Zickus wrote:
> > And why overcommitment is not a valid reason to generate a softlockup in
> > the first place ?
> 
> For the guest I don't believe it is.  It isn't the guest's fault it
> couldn't run processes.  A warning should be scheduled on the host that it
> couldn't run a process in a very long time.

An interesting viewpoint is this: it does not matter who is at fault,
whether the host or the guest. What matters is that an application in
the guest is being starved of the least amount of resources for proper
functioning (as specified by the watchdog threshold).

The responsability for verifying that the least amount of resources for
functioning of the guest application should not be entirely on the part
of the host.

