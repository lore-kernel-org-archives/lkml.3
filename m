Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3IUGzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 02:55:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41348 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3IUGzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 02:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <1378778772.25578.1.camel@concordia>
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com>
	<1378778772.25578.1.camel@concordia>
Date: Sat, 21 Sep 2013 08:55:37 +0200
Message-ID: <CABPqkBREXH5VUkULAsWvmpCer-s4SCxuof6LdqRO0i-iBOG8pA@mail.gmail.com>
Subject: Re: [PATCH V2 0/6] perf: New conditional branch filter
From: Stephane Eranian <eranian@google.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Neuling <michael.neuling@au1.ibm.com>,
        svaidy@linux.vnet.ibm.com,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 4:06 AM, Michael Ellerman
<michael@ellerman.id.au> wrote:
>
> On Fri, 2013-08-30 at 09:54 +0530, Anshuman Khandual wrote:
> >       This patchset is the re-spin of the original branch stack sampling
> > patchset which introduced new PERF_SAMPLE_BRANCH_COND filter. This patchset
> > also enables SW based branch filtering support for PPC64 platforms which have
> > branch stack sampling support. With this new enablement, the branch filter support
> > for PPC64 platforms have been extended to include all these combinations discussed
> > below with a sample test application program.
>
> ...
>
> > Mixed filters
> > -------------
> > (6) perf record -e branch-misses:u -j any_call,any_ret ./cprog
> > Error:
> > The perf.data file has no samples!
> >
> > NOTE: As expected. The HW filters all the branches which are calls and SW tries to find return
> > branches in that given set. Both the filters are mutually exclussive, so obviously no samples
> > found in the end profile.
>
> The semantics of multiple filters is not clear to me. It could be an OR,
> or an AND. You have implemented AND, does that match existing behaviour
> on x86 for example?
>
The semantic on the API is OR. AND does not make sense: CALL & RETURN?
On x86, the HW filter is an OR (default: ALL, set bit to disable a
type). I suspect
it is similar on PPC.

>
> cheers
>
>
