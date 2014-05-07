Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaEGE24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:28:56 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58390 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaEGE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:28:55 -0400
MIME-Version: 1.0
In-Reply-To: <1399429930-5073-1-git-send-email-xindong.ma@intel.com>
References: <1399429930-5073-1-git-send-email-xindong.ma@intel.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Wed, 7 May 2014 12:28:14 +0800
Message-ID: <CAHz2CGUo2SevOPXw7PqNyUroc4xD2Z4fOHEFUeJ+FQU-6rib0g@mail.gmail.com>
Subject: Re: [PATCH] rmap: validate pointer in anon_vma_clone
To: Leon Ma <xindong.ma@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, iamjoonsoo.kim@lge.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        kirill.shutemov@linux.intel.com, gorcunov@gmail.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 10:32 AM, Leon Ma <xindong.ma@intel.com> wrote:
> If memory allocation failed in first loop, root will be NULL and
> will lead to kernel panic.

Hello, Leon,

I am afraid not.  unlock_anon_vma_root() has a sanity check NULLness of root,
so it is impossible to panic for a dangling root pointer.



Thanks,
Jianyu Zhan
