Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3JYMiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 08:38:19 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44081 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3JYMiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 08:38:18 -0400
MIME-Version: 1.0
In-Reply-To: <20131023050502.1886.15779.stgit@hemant-fedora>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
	<20131023050502.1886.15779.stgit@hemant-fedora>
Date: Fri, 25 Oct 2013 14:38:17 +0200
X-Google-Sender-Auth: NihYnsYmSlaZI65US06hWPZ8Y4M
Message-ID: <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
From: Pekka Enberg <penberg@kernel.org>
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        aravinda@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hemant,

On Wed, Oct 23, 2013 at 7:05 AM, Hemant Kumar <hkshaw@linux.vnet.ibm.com> wrote:
> This allows perf to probe into the sdt markers/notes present in
> the libraries and executables. We try to find the associated location
> and handle prelinking (since, stapsdt notes section is not allocated
> during runtime). Prelinking is handled with the help of base
> section which is allocated during runtime. This address can be compared
> with the address retrieved from the notes' description. If its different,
> we can take this difference and then add to the note's location.
>
> We can use existing '-a/--add' option to add events for sdt markers.
> Also, we can add multiple events at once using the same '-a' option.
>
> Usage:
> perf probe -x /lib64/libc.so.6 -a 'my_event=%libc:setjmp'
>
> Output:
> Added new event:
>   libc:my_event        (on 0x35981)
>
> You can now use it in all perf tools, such as:
>
>     perf record -e libc:my_event -aR sleep 1

Is there a technical reason why 'perf list' could not show all the
available SDT markers on a system and that the 'market to event'
mapping cannot happen automatically?

So instead of doing all the command line magic above I'd do:

  perf list

  libc:setjmp [SDT marker]

and I could just do

  perf record -e libc:setjmp -AR sleep 1

?

                    Pekka
