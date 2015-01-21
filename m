Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbbAUOxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:53:50 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:53773 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbAUOxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:53:40 -0500
Date: Wed, 21 Jan 2015 14:52:19 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Iulia Manda <iulia.manda21@gmail.com>
Cc: serge.hallyn@canonical.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        peterz@infradead.org, mhocko@suse.cz
Subject: Re: [PATCH] kernel: Conditionally support non-root users, groups
 and capabilities
Message-ID: <20150121145219.446d360c@lxorguk.ukuu.org.uk>
In-Reply-To: <20150120233308.GA6256@winterfell>
References: <20150120233308.GA6256@winterfell>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 01:33:08 +0200
Iulia Manda <iulia.manda21@gmail.com> wrote:

> There are a lot of embedded systems that run most or all of their functionality
> in init, running as root:root. For these systems, supporting multiple users is
> not necessary.

We probably shouldn't encourage such poor design ;-)

The proposed patch generates a whole mass of ifdefs all over the place.
If it's going to be done move all the functions in question together
somewhere logical and give them a single ifdef or a file of their own.

It also doesn't appear to be dropping all it should - why can't you
simply not compile in groups.c for example ? If you can't then it says
the patch is far from complete at this point.

Alan

