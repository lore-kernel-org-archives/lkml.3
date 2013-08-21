Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3HUTae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:30:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3HUTad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:30:33 -0400
Date: Wed, 21 Aug 2013 12:30:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, linux-aio@kvack.org
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-Id: <20130821123032.8d0668d34231aabeddff24ea@linux-foundation.org>
In-Reply-To: <20130821130231.GG13330@kvack.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
	<20130821130231.GG13330@kvack.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 09:02:31 -0400 Benjamin LaHaise <bcrl@kvack.org> wrote:

> One of the major problems your changeset continues to carry is that your 
> new read_iter/write_iter operations permit blocking (implicitely), which 
> really isn't what we want for aio.  If you're going to introduce a new api, 
> it should be made non-blocking, and enforce that non-blocking requirement 

It's been so incredibly long and I've forgotten everything AIO :(

In this context, "non-blocking" means no synchronous IO, yes?  Even for
indirect blocks, etc.  What about accidental D-state blockage in page
reclaim, or against random sleeping locks?

Also, why does this requirement exist?  "99% async" is not good enough?
How come?

