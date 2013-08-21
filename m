Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab3HUQaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:30:06 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58117 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3HUQaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:30:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130821141926.GT18673@moon>
References: <5214C524.1050900@citrix.com>
	<dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
	<20130821141926.GT18673@moon>
Date: Wed, 21 Aug 2013 09:30:03 -0700
X-Google-Sender-Auth: pmqaVf7WwEO-bv22FdUGB_Pacqs
Message-ID: <CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Vrabel <david.vrabel@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 7:19 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Aug 21, 2013 at 04:11:25PM +0200, H. Peter Anvin wrote:
>>
>> Eep.  This should be reverted, indeed.  This isn't a manifest bug on !Xen but we
>> have gotten requests for WT support which would mean adding in the PAT but again.
>
> Please no, letme fix it. That's what I'm having in mind: don't use pse bit in swap
> entry but always mark page read from swap as dirty one (it's better than having
> no tracker at all and  will be the case on old machines with 32bit ptes only).

Quite frankly, unless I see a patch later today that is

 (a) obvious
 (b) explains what is going on
 (c) tested

I will be reverting the whole soft-dirty mess. I thought the
bit-mapping games it played were already too complicated (the patch to
pgtable-2level.h in commit 41bb3476b361 just makes me want to barf and
came in very late, so I'm not positive about the whole soft-dirty mess
in the first place). I really am not at all inclined to want to play
games in this area any more. It's too damn late in the release window.

            Linus
