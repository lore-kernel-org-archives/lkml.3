Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3IQVWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:22:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3IQVWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:22:30 -0400
Date: Tue, 17 Sep 2013 14:22:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smp: harmonize prototypes of smp functions
Message-Id: <20130917142228.0cb08371ea5259ca53055fe4@linux-foundation.org>
In-Reply-To: <1378132393-17089-1-git-send-email-javi.merino@arm.com>
References: <1378132393-17089-1-git-send-email-javi.merino@arm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Sep 2013 15:33:13 +0100 Javi Merino <javi.merino@arm.com> wrote:

> Avoid unnecessary casts from int to bool in smp functions.  Some
> functions in kernel/smp.c have a wait parameter that can be set to one
> if you want to wait for the command to complete.  It's defined as bool
> in a few of them and int in the rest.  If a function with wait
> declared as int calls a function whose prototype has wait defined as
> bool, the compiler needs to test if the int is != 0 and change it to 1
> if so.  This useless check can be avoided if we are consistent and
> make all the functions use the same type for this parameter.

Yes, that's a problem with bool.

But the `wait' argument *is* a boolean and switching everything over to
use "bool" (instead of "int") should provide similar code-size savings.
Did you evaluate that approach?

