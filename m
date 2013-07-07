Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3GGQl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 12:41:59 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39545 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3GGQl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 12:41:56 -0400
MIME-Version: 1.0
In-Reply-To: <0000013f9aeb70c6-f6dad22c-bb88-4313-8602-538a3f5cedf5-000000@email.amazonses.com>
References: <1372069394-26167-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<1372069394-26167-2-git-send-email-liwanp@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1306241421560.25343@chino.kir.corp.google.com>
	<0000013f9aeb70c6-f6dad22c-bb88-4313-8602-538a3f5cedf5-000000@email.amazonses.com>
Date: Sun, 7 Jul 2013 19:41:54 +0300
X-Google-Sender-Auth: SuE5P5eOouMQ-Tc0XSW72oPrBd8
Message-ID: <CAOJsxLGXTcB2iVcg5SArVytakjeTSCZqLEqnBWhTrjA4aLnSSQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/slab: Sharing s_next and s_stop between slab and slub
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 6:48 PM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 24 Jun 2013, David Rientjes wrote:
>
>> On Mon, 24 Jun 2013, Wanpeng Li wrote:
>>
>> > This patch shares s_next and s_stop between slab and slub.
>> >
>>
>> Just about the entire kernel includes slab.h, so I think you'll need to
>> give these slab-specific names instead of exporting "s_next" and "s_stop"
>> to everybody.
>
> He put the export into mm/slab.h. The headerfile is only included by
> mm/sl?b.c .

But he then went on to add globally visible symbols "s_next" and
"s_stop" which is bad...

Please send me an incremental patch on top of slab/next to fix this
up. Otherwise I'll revert it before sending a pull request to Linus.

                      Pekka
