Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3AQUeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:34:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab3AQUd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:33:59 -0500
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
References: <87wqvdli1o.fsf@xmission.com> <1358344859.4593.66.camel@falcor1>
	<20130116144836.GB29845@redhat.com>
	<1358350391.4593.112.camel@falcor1>
	<20130116163453.GD29845@redhat.com>
	<1358359715.4593.146.camel@falcor1>
	<20130116182804.GF29845@redhat.com>
	<1358364290.4593.178.camel@falcor1> <20130116215341.GA4222@redhat.com>
	<CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
	<20130117151825.GA12165@redhat.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 17 Jan 2013 15:33:47 -0500
In-Reply-To: <20130117151825.GA12165@redhat.com> (Vivek Goyal's message of "Thu, 17 Jan 2013 10:18:25 -0500")
Message-ID: <y0my5frsg5w.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> [...]
>> Can you please tell a bit more how this patch protect against direct
>> writing to the blocks?
>
> If you have loaded all the pages from disk and locked them in memory and
> verified the signature, then even if somebody modifies a block on disk
> it does not matter. We will not read pages from disk anymore for this
> exec(). We verified the signature of executable loaded in memory and
> in-memory copy is intact.

Does this imply dramatically increasing physical RAM pressure and load
latency, because binaries (and presumably all their shared libraries)
have to be locked & loaded?  (Else if they are paged out to
encrypted-swap, is that sufficient protection against manipulation?)

- FChE
