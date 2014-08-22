Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaHVUqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:46:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaHVUq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:46:29 -0400
Date: Fri, 22 Aug 2014 13:46:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tj@kernel.org,
        avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com
Subject: Re: [patch 4/4] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP
 operation, v3
Message-Id: <20140822134628.5df9cda87d744e35d794b5c2@linux-foundation.org>
In-Reply-To: <20140822203809.GC25918@moon>
References: <20140804172255.109539743@openvz.org>
	<20140804172610.965949916@openvz.org>
	<20140821155115.8433bb37bf631b8ae8340f84@linux-foundation.org>
	<20140822063242.GI14072@moon>
	<20140821234912.f007e2fb.akpm@linux-foundation.org>
	<20140822203809.GC25918@moon>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2014 00:38:09 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> > 
> > Or will we?  What happens if we later decide that some additional field
> > needs to be added?  Do we version the interface?  Add a new prctl()
> > mode?  Let's cook up a plan for that and at least add to changelog?
> 
> I don't expect to change it anytime soon but we still have an option --
> if we decide to extend or shrink it we always can use sizeof/offsetof
> helpers to check which exactly version userspace asks us to use.

How does that work?  We just have a blob of bytes coming in from
userspace.

> As far as I understand the mm_struct is not the structure which
> changes that frequently, right?

We might find existing things which criu wants to access.  And criu
lives forever, yes?  The mm_struct is likely to change over that time
period ;)
