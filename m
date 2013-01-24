Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3AXXH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 18:07:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab3AXXHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 18:07:50 -0500
Date: Thu, 24 Jan 2013 15:07:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Rob Landley <rob@landley.net>, George Spelvin <linux@horizon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>, mingo@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] lib: vsprintf: Add %pa format specifier for
 phys_addr_t types
Message-Id: <20130124150748.b41767bd.akpm@linux-foundation.org>
In-Reply-To: <1358900093-16412-1-git-send-email-stepanm@codeaurora.org>
References: <1358833677-15611-1-git-send-email-stepanm@codeaurora.org>
	<1358900093-16412-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013 16:14:53 -0800
Stepan Moskovchenko <stepanm@codeaurora.org> wrote:

> Add the %pa format specifier for printing a phys_addr_t
> type and its derivative types (such as resource_size_t),
> since the physical address size on some platforms can vary
> based on build options, regardless of the native integer
> type.

Looks sane.

Now, how do we hunt down the existing callsites which can be converted
to use this?

It would be nice to change at least a few of them right now, so your
patch gets tested.  Common x86 ones, ideally.
