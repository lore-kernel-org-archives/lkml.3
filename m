Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3GJR1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:27:38 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:33502 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3GJR1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:27:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130710015936.GC13855@redhat.com>
References: <51DCBE24.3030406@gmail.com>
	<20130710015936.GC13855@redhat.com>
Date: Wed, 10 Jul 2013 13:27:36 -0400
Message-ID: <CAJzLF9=vWCd2JZTNG0dX4YmLAc=B05x-+bZgU0RaSZCaR5D38g@mail.gmail.com>
Subject: Re: [REGRESSION] x86 vmalloc issue from recent 3.10.0+ commit
From: "Michael L. Semon" <mlsemon35@gmail.com>
To: Dave Jones <davej@redhat.com>, "Michael L. Semon" <mlsemon35@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        d.hatayama@jp.fujitsu.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.  I'll re-review this, anyway, and re-bisect if time allows.
The kernel/SGI-XFS combo pulled last night did much better in this
regard.  The problem is down to a different and single backtrace about
vmalloc, and the PC is controllable now.  The old git was moved to a
different folder, though, in case it's still needed.

Michael

On Tue, Jul 9, 2013 at 9:59 PM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Jul 09, 2013 at 09:51:32PM -0400, Michael L. Semon wrote:
>
>  > kernel: [ 2580.395592] vmap allocation for size 20480 failed: use vmalloc=<size> to increase size.
>  > kernel: [ 2580.395761] vmalloc: allocation failure: 16384 bytes
>
> I was seeing a lot of these recently too.
> (Though I also saw memory corruption afterwards possibly caused by
>  a broken fallback path somewhere when that vmalloc fails)
>
> http://comments.gmane.org/gmane.linux.kernel.mm/102895
>
>         Dave
>
