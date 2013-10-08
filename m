Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3JHU2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:28:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3JHU2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:28:46 -0400
Date: Tue, 8 Oct 2013 13:28:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, joe@perches.com
Subject: Re: [PATCH 3/3] vsprintf: ignore %n again
Message-Id: <20131008132845.7e6c1c28f1c917f30ecb8dc5@linux-foundation.org>
In-Reply-To: <1381201011-4230-3-git-send-email-keescook@chromium.org>
References: <1381201011-4230-1-git-send-email-keescook@chromium.org>
	<1381201011-4230-3-git-send-email-keescook@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Oct 2013 19:56:51 -0700 Kees Cook <keescook@chromium.org> wrote:

> This ignores %n in printf again, as was originally documented. Implementing
> %n poses a greater security risk than utility, so it should stay ignored.
> To help anyone attempting to use %n, a warning will be emitted if it is
> encountered.
> 
> Based on earlier patch by Joe Perches.

Well this sucks.  Nowhere in this patchset are we told what is the
alleged security risk with %n.  There's even a runtime warning telling
people not to use it, but we've provided no way for them to find out
*why*.

Please send along suitable changelog text so I can fix this up.

A new checkpatch rule might be appropriate?

Two of these patches were acked-by:you.  But you sent the patches, so I
changed these to Signed-off-by:, as per
Documentation/SubmittingPatches, section 12.

