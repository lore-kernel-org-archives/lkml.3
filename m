Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaJPAHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 20:07:38 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:49101 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaJPAHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 20:07:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141015170637.4063.22185.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	<20141015170637.4063.22185.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Date: Wed, 15 Oct 2014 17:07:33 -0700
Message-ID: <CAHLZz13Hbeozz2-PC7a617NkXHkMs==+Ekg0+u7LBg8qB-HFQA@mail.gmail.com>
Subject: Re: [PATCH v1 08/10] kgdb: Remove "weak" from kgdb_arch_pc() declaration
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 10:06 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> kernel/debug/debug_core.c provides a default kgdb_arch_pc() definition
> explicitly marked "weak".  Several architectures provide their own
> definitions intended to override the default, but the "weak" attribute on
> the declaration applied to the arch definitions as well, so the linker
> chose one based on link order (see 10629d711ed7 ("PCI: Remove __weak
> annotation from pcibios_get_phb_of_node decl")).
>
> Remove the "weak" attribute from the declaration so we always prefer a
> non-weak definition over the weak one, independent of link order.
>
> Fixes: 688b744d8bc8 ("kgdb: fix signedness mixmatches, add statics, add declaration to header")
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Harvey Harrison <harvey.harrison@gmail.com>

Reviewed-by: Harvey Harrison <harvey.harrison@gmail.com>

This was likely simply an error in my patch, likely just copied the
function definition and didn't even notice the
weak annotation at the time.

Harvey
