Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3ISIbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:31:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:10191 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab3ISIbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:31:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,935,1371106800"; 
   d="scan'208";a="398016782"
Date: Thu, 19 Sep 2013 01:31:02 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/11] x86: Use asm goto to implement better
 modify_and_test() functions
Message-ID: <20130919083102.GB11427@tassilo.jf.intel.com>
References: <20130917082838.218329307@infradead.org>
 <20130917091143.387880231@infradead.org>
 <CA+55aFyVZNb3ZrLfh5FkV4E_P5_LE4-LpDHBwFNp=W1H7CnSBg@mail.gmail.com>
 <4ec87843-c29a-401a-a54f-2cd4d61fba62@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ec87843-c29a-401a-a54f-2cd4d61fba62@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 02:02:37PM -0500, H. Peter Anvin wrote:
> Yes, a bit sad.  We allow bracketing with the get/put_user_try/catch blocks, but that is x86-specific.
> 
> I don't think a generic option is possible without compiler support, but it might be possible to do better than we do know.

Letting the compiler do it is a bit risky, because it may open it up for
really large blocks, thus defeating the security advantages.

-Andi
