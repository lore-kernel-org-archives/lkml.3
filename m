Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3IJCGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 22:06:13 -0400
Received: from ozlabs.org ([203.10.76.45]:51782 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3IJCGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 22:06:12 -0400
Message-ID: <1378778772.25578.1.camel@concordia>
Subject: Re: [PATCH V2 0/6] perf: New conditional branch filter
From: Michael Ellerman <michael@ellerman.id.au>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, eranian@google.com,
        acme@redhat.com, Michael Neuling <michael.neuling@au1.ibm.com>,
        svaidy@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com
Date: Tue, 10 Sep 2013 12:06:12 +1000
In-Reply-To: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 09:54 +0530, Anshuman Khandual wrote:
> 	This patchset is the re-spin of the original branch stack sampling
> patchset which introduced new PERF_SAMPLE_BRANCH_COND filter. This patchset
> also enables SW based branch filtering support for PPC64 platforms which have
> branch stack sampling support. With this new enablement, the branch filter support
> for PPC64 platforms have been extended to include all these combinations discussed
> below with a sample test application program.

...

> Mixed filters
> -------------
> (6) perf record -e branch-misses:u -j any_call,any_ret ./cprog
> Error:
> The perf.data file has no samples!
> 
> NOTE: As expected. The HW filters all the branches which are calls and SW tries to find return
> branches in that given set. Both the filters are mutually exclussive, so obviously no samples
> found in the end profile.

The semantics of multiple filters is not clear to me. It could be an OR,
or an AND. You have implemented AND, does that match existing behaviour
on x86 for example?

cheers


