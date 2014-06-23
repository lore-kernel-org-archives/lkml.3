Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaFWU2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:28:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:41060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbaFWU2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:28:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,532,1400050800"; 
   d="scan'208";a="562077486"
Message-ID: <53A88DE4.8050107@intel.com>
Date: Mon, 23 Jun 2014 13:28:20 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-3-git-send-email-qiaowei.ren@intel.com> <53A884B2.5070702@mit.edu> <53A88806.1060908@intel.com> <CALCETrXYZZiZsDiUvvZd0636+qHP9a0sHTN6wt_ZKjvLaeeBzw@mail.gmail.com>
In-Reply-To: <CALCETrXYZZiZsDiUvvZd0636+qHP9a0sHTN6wt_ZKjvLaeeBzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 01:06 PM, Andy Lutomirski wrote:
> Can the new vm_operation "name" be use for this?  The magic "always
> written to core dumps" feature might need to be reconsidered.

One thing I'd like to avoid is an MPX vma getting merged with a non-MPX
vma.  I don't see any code to prevent two VMAs with different
vm_ops->names from getting merged.  That seems like a bit of a design
oversight for ->name.  Right?

Thinking out loud a bit... There are also some more complicated but more
performant cleanup mechanisms that I'd like to go after in the future.
Given a page, we might want to figure out if it is an MPX page or not.
I wonder if we'll ever collide with some other user of vm_ops->name.  It
looks fairly narrowly used at the moment, but would this keep us from
putting these pages on, say, a tmpfs mount?  Doesn't look that way at
the moment.
