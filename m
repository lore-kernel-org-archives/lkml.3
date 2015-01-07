Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbbAGETf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 23:19:35 -0500
Received: from ozlabs.org ([103.22.144.67]:34199 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbbAGETc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 23:19:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: nick <xerofoify@gmail.com>
Cc: x86@kernel.org, ak@linux.intel.com, JBeulich@suse.com,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Implement Functions in boot.c
In-Reply-To: <54AC04CA.1000102@gmail.com>
References: <54AC04CA.1000102@gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 07 Jan 2015 12:31:59 +1030
Message-ID: <87bnmb4aco.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nick <xerofoify@gmail.com> writes:
> Greetings Rusty,
> I am wondering why we haven't implementing the below functions:
>  /* Let's just say, I wouldn't do debugging under a Guest. */
>  static unsigned long lguest_get_debugreg(int regno)
> {
>          /* FIXME: Implement */
>          return 0;
> }
>
>  static void lguest_set_debugreg(int regno, unsigned long value)
> {
>          /* FIXME: Implement */
> }
> Seems to me that this are needed for various areas in the lguest subsystem and should
> be implemented for debugging ease of use in the lguest subsystem.

Well, normal use of gdb works.  It can't use hardware watchpoints,
though.

To fix this, hypercalls would have to be added to manipulate the debug
registers, and these registers would have to be saved and restored in
the world switcher code.

Patches welcome!
Rusty.
