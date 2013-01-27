Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3A0NEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:04:43 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:50427 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3A0NEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:04:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130125141842.58010c25@annuminas.surriel.com>
References: <20130125140553.060b8ced@annuminas.surriel.com>
	<20130125141842.58010c25@annuminas.surriel.com>
Date: Sun, 27 Jan 2013 05:04:40 -0800
Message-ID: <CANN689EAykWXS4QTVDKaCb4in_2b_Bqyoh-xg=EbX7ivOPry4w@mail.gmail.com>
Subject: Re: [PATCH -v4 4/5] x86,smp: keep spinlock delay values per hashed
 spinlock address
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:18 AM, Rik van Riel <riel@redhat.com> wrote:
> +       u32 delay = (ent->hash == hash) ? ent->delay : MIN_SPINLOCK_DELAY;

I still don't like the reseting of delay to MIN_SPINLOCK_DELAY when
there is a hash collision.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
