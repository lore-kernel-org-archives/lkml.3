Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3H0Pmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:42:38 -0400
Received: from a9-92.smtp-out.amazonses.com ([54.240.9.92]:53708 "EHLO
	a9-92.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977Ab3H0Pmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:42:36 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Aug 2013 11:42:36 EDT
Date: Tue, 27 Aug 2013 15:37:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [guv v2 20/31] powerpc: Replace __get_cpu_var uses
In-Reply-To: <CAMuHMdUXSRQrPMYb3wH7RjH9J_L_yeXku=OfvZ79vc29c9cX7g@mail.gmail.com>
Message-ID: <00000140c06bf6b1-9f28d658-680c-4ce8-a27b-62312a7ced6f-000000@email.amazonses.com>
References: <20130826204351.725357339@linux.com> <00000140bc5f248c-92262df9-6616-4a69-b8c1-16a412386d6c-000000@email.amazonses.com> <CAMuHMdUXSRQrPMYb3wH7RjH9J_L_yeXku=OfvZ79vc29c9cX7g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.27-54.240.9.92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013, Geert Uytterhoeven wrote:

> On Mon, Aug 26, 2013 at 10:44 PM, Christoph Lameter <cl@linux.com> wrote:
> > __get_cpu_var() is used for multiple purposes in the kernel source. One of them is
> > address calculation via the form &__get_cpu_var(x). This calculates the address for
> > the instance of the percpu variable of the current processor based on an offset.
> >
> > Others usage cases are for storing and retrieving data from the current processors percpu area.
>
> use cases
>
> > __get_cpu_var() always only does a address determination. However, store and retrieve operations
>
> an address
>
> > This patch converts __get_cpu_var into either and explicit address calculation using this_cpu_ptr()
>
> an explicit
>
> > 4. Retrieve the content of a percpu struct
> >
> >         DEFINE_PER_CPU(struct mystruct, y);
> >         struct mystruct x = __get_cpu_var(y);
> >
> >    Converts to
> >
> >         memcpy(this_cpu_ptr(&y), x, sizeof(x));
>
> Let's hope the actual code copies in the other direction ;-)

Ok fixed that as well.

