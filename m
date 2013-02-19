Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553Ab3BSWCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:02:49 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56094 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934512Ab3BSWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:02:48 -0500
Date: Wed, 20 Feb 2013 02:02:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiederm@xmission.com, xemul@parallels.com,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 1/2] kcmp: Make it to depend on CONFIG_KCMP
Message-ID: <20130219220244.GQ20312@moon>
References: <20130219064800.719149796@openvz.org>
 <20130219065210.030802820@openvz.org>
 <5123444D.6000806@suse.cz>
 <20130219093154.GF20312@moon>
 <5123BC2B.6000304@zytor.com>
 <20130219182838.GL20312@moon>
 <20130219134256.f4cedf44.akpm@linux-foundation.org>
 <5123F32B.3000401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5123F32B.3000401@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 01:48:27PM -0800, H. Peter Anvin wrote:
> >
> >This permits people to select kcmp with CONFIG_CHECKPOINT_RESTORE=n.
> >Is there any point in doing that?
> >
> >What would be wrong with just doing
> >
> >	obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
> >
> 
> The real question is if there are any potential use cases of kcmp()
> outside checkpoint/restore.  It is actually a very general facility.

As far as I remember Eric was pointing to such potential use at early
time when kcmp being only started developing (I'm trying to find this
email in archive, if only my memory doesn't betray me and it was about
something else ;) Nevertheless, one may write utility to output
statistics on shared "resource" used by a task (don't know if it's
that useful since we use kcmp for c/r sake, but still).
