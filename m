Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaBEXBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:01:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaBEXBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:01:03 -0500
Date: Wed, 5 Feb 2014 15:01:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        "Michel Lespinasse" <walken@google.com>,
        "Shaohua Li" <shli@kernel.org>,
        "Jerome Marchand" <jmarchan@redhat.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>,
        "Joonsoo Kim" <iamjoonsoo.kim@lge.com>,
        "Joe Perches" <joe@perches.com>,
        "David Rientjes" <rientjes@google.com>,
        "Alexey Dobriyan" <adobriyan@gmail.com>, "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH v7 1/3] mm: add kstrdup_trimnl function
Message-Id: <20140205150101.f6fbe53db7d30a09854a5c5c@linux-foundation.org>
In-Reply-To: <20140205225552.16730.1677@capellas-linux>
References: <1391546631-7715-1-git-send-email-sebastian.capella@linaro.org>
	<1391546631-7715-2-git-send-email-sebastian.capella@linaro.org>
	<20140205135052.4066b67689cbf47c551d30a9@linux-foundation.org>
	<20140205225552.16730.1677@capellas-linux>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Feb 2014 14:55:52 -0800 Sebastian Capella <sebastian.capella@linaro.org> wrote:

> Quoting Andrew Morton (2014-02-05 13:50:52)
> > On Tue,  4 Feb 2014 12:43:49 -0800 Sebastian Capella <sebastian.capella@linaro.org> wrote:
> > 
> > > kstrdup_trimnl creates a duplicate of the passed in
> > > null-terminated string.  If a trailing newline is found, it
> > > is removed before duplicating.  This is useful for strings
> > > coming from sysfs that often include trailing whitespace due to
> > > user input.
> > 
> > hm, why?  I doubt if any caller of this wants to retain leading and/or
> > trailing spaces and/or tabs.
> 
> Hi Andrew,
> 
> I agree the common case doesn't usually need leading or trailing whitespace.
> 
> Pavel and others pointed out that a valid filename could contain
> newlines/whitespace at any position.

The number of cases in which we provide the kernel with a filename via
sysfs will be very very small, or zero.

If we can go through existing code and find at least a few sites which
can usefully employ kstrdup_trimnl() then fine, we have evidence.  But
I doubt if we can do that?
