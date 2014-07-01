Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbaGAPpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:45:04 -0400
Received: from mailsec106.isp.belgacom.be ([195.238.20.102]:42369 "EHLO
	mailsec106.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356AbaGAPpA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:45:00 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=0I4RXl3vBzpC9C0LkGzOScdFrA33WtKNJhCMihYJJm8= c=1 sm=2
 a=yw6KEcBww1AA:10 a=IkcTkHD0fZMA:10 a=JfrnYn6hAAAA:8
 a=J7pb0BecPb-Ols3oF6QA:9 a=QEXdDO2ut3YA:10 a=3Rfx1nUSh_UA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQFAKXWslPD7hTU/2dsb2JhbABagw2EGqhDAQEBAQEGmkUBgQ0WdYQDAQEEASNWBQsFBg4KAgIYDgICVwYBEhGIKQysW4Z/lR8XgSuERIh9MweCd4FMBaYqiD6DRDs
Date: Tue, 1 Jul 2014 17:44:59 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
Cc: joe@perches.com, linux-kernel@vger.kernel.org
Message-ID: <1550610470.218141.1404229499026.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140701081759.GA19708@infradead.org>
References: <1404154997-15490-1-git-send-email-fabf@skynet.be> <20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org> <20140701081759.GA19708@infradead.org>
Subject: Re: [RFC 1/1] proc: constify seq_operations
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 01 July 2014 at 10:17 Christoph Hellwig <hch@infradead.org> wrote:
>
>
> On Mon, Jun 30, 2014 at 01:39:39PM -0700, Andrew Morton wrote:
> > On Mon, 30 Jun 2014 21:03:17 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> >
> > > proc_uid_seq_operations, proc_gid_seq_operations and
> > > proc_projid_seq_operations
> > > are only called in proc_id_map_open with seq_open as
> > > const struct seq_operations so we can constify the 3 structures and update
> > > proc_id_map_open prototype.
> >
> > There are an absolutely enormous number of places where we could
> > constify things.  For sheer sanity's sake I'm not inclined to churn the
> > code in this way unless a patch provides some sort of runtime benefit.
> > And this particular patch doesn't appear to change the generated code
> > at all.
>
> Unlike a lot of the cleanup patches which provide no benefit at all
> constifying op vectors moves them from .text to .data which is not
> marked executable and thus reduce the attack vector for kernel exploits.

Sorry Christoph but earlier reports by Andrew and Joe show the opposite ie
it moves vectors from data to text (code/executable) segment...

Fabian

>
> So I defintively like to see these much more than a lot of the other
> things filling up the lists.
