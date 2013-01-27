Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3A0WKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 17:10:18 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34580 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab3A0WKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 17:10:15 -0500
Date: Sun, 27 Jan 2013 14:10:16 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Simon Jeons <simon.jeons@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/11] ksm: get_ksm_page locked
In-Reply-To: <1359254927.4159.11.camel@kernel>
Message-ID: <alpine.LNX.2.00.1301271408100.17144@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251759470.29196@eggly.anvils> <1359254927.4159.11.camel@kernel>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2013, Simon Jeons wrote:
> 
> BTW, what's the meaning of ksm page forked? 

A ksm page is mapped into a process's mm, then that process calls fork():
the ksm page then appears in the child's mm, before ksmd has tracked it.
