Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3EHAra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:47:30 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:54862 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3EHAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:47:29 -0400
MIME-Version: 1.0
In-Reply-To: <1367967522-3934-1-git-send-email-j.glisse@gmail.com>
References: <1367967522-3934-1-git-send-email-j.glisse@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 7 May 2013 20:47:08 -0400
Message-ID: <CAHGf_=ofADKRCgDN5Tanx4PyvoJFF9r=cHYMd+VRc=N3=4FGuA@mail.gmail.com>
Subject: Re: [PATCH] mm: honor FOLL_GET flag in follow_hugetlb_page v2
To: Jerome Glisse <j.glisse@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 6:58 PM,  <j.glisse@gmail.com> wrote:
> From: Jerome Glisse <jglisse@redhat.com>
>
> Do not increase page count if FOLL_GET is not set. None of the
> current user can trigger the issue because none of the current
> user call __get_user_pages with both the pages array ptr non
> NULL and the FOLL_GET flags non set in other word all caller
> of __get_user_pages that don't set the FOLL_GET flags also call
> with pages == NULL.

Because, __get_user_pages() doesn't allow pages==NULL and FOLL_GET is on.


long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
{
(snip)
    VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
