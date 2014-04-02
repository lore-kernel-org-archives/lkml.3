Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbaDBXsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:48:14 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46501 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbaDBXsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:48:12 -0400
Date: Thu, 3 Apr 2014 01:48:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        bp@suse.de, paul.gortmaker@windriver.com, JBeulich@suse.com,
        prarit@redhat.com, drjones@redhat.com, toshi.kani@hp.com,
        riel@redhat.com, gong.chen@linux.intel.com
Subject: Re: [PATCH v2 1/5] x86: replace timeouts when booting secondary
 CPU with infinite wait loop
Message-ID: <20140402234810.GO22728@two.firstfloor.org>
References: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
 <1396296565-19709-2-git-send-email-imammedo@redhat.com>
 <87ppkzk5zi.fsf@tassilo.jf.intel.com>
 <20140402232956.54848fbe@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402232956.54848fbe@thinkpad>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 11:29:56PM +0200, Igor Mammedov wrote:
> On Wed, 02 Apr 2014 10:15:29 -0700
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Igor Mammedov <imammedo@redhat.com> writes:
> > 
> > > Hang is observed on virtual machines during CPU hotplug,
> > > especially in big guests with many CPUs. (It reproducible
> > > more often if host is over-committed).
> > >
> > > It happens because master CPU gives up waiting on
> > > secondary CPU and allows it to run wild. As result
> > > AP causes locking or crashing system. For example
> > > as described here: https://lkml.org/lkml/2014/3/6/257
> > >
> > > If master CPU have sent STARTUP IPI successfully,
> > > make it wait indefinitely till AP boots.
> > 
> > 
> > But what happens on a real machine when the other CPU is dead?
> One possible way to boot such machine would be to disable dead CPU
> in kernel parameters.

That would need explicit user action. It's much better to recover 
automatically, even if somewhat crippled.

-Andi

