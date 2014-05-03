Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaECXxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 19:53:43 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:53821 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaECXxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 19:53:42 -0400
Message-ID: <1399161216.2573.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] IPC initialize shmmax and shmall from the current value
 not the default
From: Davidlohr Bueso <davidlohr@hp.com>
To: Marian Marinov <mm@1h.com>
Cc: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        Greg KH <gregkh@linuxfoundation.org>, manfred@colorfullife.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Date: Sat, 03 May 2014 16:53:36 -0700
In-Reply-To: <5365723D.7030303@1h.com>
References: <5365723D.7030303@1h.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-04 at 01:48 +0300, Marian Marinov wrote:
> When we are creating new IPC namespace that should be cloned from the current namespace it is a good idea to copy the 
> values of the current shmmax and shmall to the new namespace.

Why is this a good idea?

This would break userspace that relies on the current behavior.
Furthermore we've recently changed the default value of both these
limits to be as large as you can get, thus deprecating them. I don't
like the idea of this being replaced by namespaces.

Thanks,
Davidlohr

