Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3D2PqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:46:15 -0400
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:36428 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756826Ab3D2PqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:46:14 -0400
Date: Mon, 29 Apr 2013 15:46:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <517E8EE1.6090306@parallels.com>
Message-ID: <0000013e5679080c-d205d4fa-a545-439d-a976-f234f48e1bcc-000000@email.amazonses.com>
References: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp> <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp> <201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp> <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com>
 <517E8758.9040803@parallels.com> <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <517E8EE1.6090306@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Glauber Costa wrote:

> On 04/29/2013 06:59 PM, Christoph Lameter wrote:
> > The code in kmalloc_index() creates a BUG() and preferentially should
> > create a compile time failure when a number that is too big is passed to it.
> >
> > What is MAX_ORDER on the architecture?
>
> Returning NULL is fine, but kmalloc_index currently does not check for
> MAX_ORDER at all.

Could easily add that and BUG() on it?
