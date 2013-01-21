Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3AUAkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:40:45 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47907 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab3AUAko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:40:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Add TAINT_NOKEY_MODULE
Date: Mon, 21 Jan 2013 01:46:31 +0100
Message-ID: <13201196.eooFfVZZkZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <8738xvxv55.fsf@rustcorp.com.au>
References: <20130104191205.GD27554@hansolo.jdub.homelinux.org> <20130117150202.GB32586@redhat.com> <8738xvxv55.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 10:30:22 AM Rusty Russell wrote:
> Dave Jones <davej@redhat.com> writes:
> > On Thu, Jan 17, 2013 at 11:27:27AM +1030, Rusty Russell wrote:
> >  
> >  > taint: add explicit flag to show whether lock dep is still OK.
> >  > 
> >  > Fix up all callers as they were before, with make one change: an
> >  > unsigned module taints the kernel, but doesn't turn off lockdep.
> >  > 
> >  > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> >  
> > This made my brain itch a little until I got to the bottom of the
> > patch and saw the new definition of add_taint.  Perhaps instead of
> > false/true, we have LOCKDEP_LIVES/LOCKDEP_DIES or similar defines
> > to make it clearer what's actually happening without having to
> > go read the function ?
> 
> The reason I didn't do that is because it's theoretically more than
> lockdep: it's anything which relies on kernel integrity.
> 
> Then I got the true/false thing mixed up myself, so I think you're right
> :)
> 
> BTW, ACPI people: those TAINT_OVERRIDDEN_ACPI_TABLE taints were
> disabling lockdep: is that overzealous?

I think so, although it's quite difficult to say what the intention was at
this point.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
