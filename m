Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaBDRLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:11:09 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:46037 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaBDRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:11:06 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402031308300.7898@chino.kir.corp.google.com>
References: <1391446195-9457-1-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.02.1402031308300.7898@chino.kir.corp.google.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 4 Feb 2014 12:10:45 -0500
Message-ID: <CAHGf_=qhRvcJAP0cwDgAjuPewmUoRe+sJZCDJ_uik48RXSaOZw@mail.gmail.com>
Subject: Re: [PATCH] mm: __set_page_dirty_nobuffers uses spin_lock_irqseve
 instead of spin_lock_irq
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Indeed, good catch.  Do we need the same treatment for
> __set_page_dirty_buffers() that can be called by way of
> clear_page_dirty_for_io()?

Indeed. I posted a patch fixed __set_page_dirty() too. plz see

Subject: [PATCH] __set_page_dirty uses spin_lock_irqsave instead of
spin_lock_irq
