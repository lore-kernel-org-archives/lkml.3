Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaHVVbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:31:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaHVVbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:31:19 -0400
Date: Fri, 22 Aug 2014 14:31:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, George Spelvin <linux@horizon.com>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] GCD: add binary GCD algorithm
Message-Id: <20140822143117.29474ac2ac8092e27d26660a@linux-foundation.org>
In-Reply-To: <1408106956-12986-1-git-send-email-zhaoxiu.zeng@gmail.com>
References: <1408106956-12986-1-git-send-email-zhaoxiu.zeng@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2014 20:49:16 +0800 Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com> wrote:

> Because some architectures (alpha, armv6, etc.) don't provide hardware division,
> the mod operation is slow! Binary GCD algorithm uses simple arithmetic operations,
> it replaces division with arithmetic shifts, comparisons, and subtraction.

I had a look around and it seems that most (all?) gcd() and lcd()
callers are on initialization-time slowpaths.

Do you know of a workload which will significantly benefit from this
change?  If so, by how much?

Otherwise I don't think we can justify the additional maintenance
cost/risk, sorry.

And if we *do* decide to proceed with this patch, we should include a
patch which enables it on as many architectures as possible, so it gets
runtime tested.

