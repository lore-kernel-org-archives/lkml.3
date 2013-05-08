Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3EHClj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:41:39 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:49986 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3EHCli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3drwbt_YX-jWrwsp0X2CH3t9ms65fX40cvumr4FyRhKBcbyw@mail.gmail.com>
References: <1367967522-3934-1-git-send-email-j.glisse@gmail.com>
 <CAHGf_=ofADKRCgDN5Tanx4PyvoJFF9r=cHYMd+VRc=N3=4FGuA@mail.gmail.com> <CAH3drwbt_YX-jWrwsp0X2CH3t9ms65fX40cvumr4FyRhKBcbyw@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 7 May 2013 22:41:17 -0400
Message-ID: <CAHGf_=rFd7xktoom2kg_1QgoCrqsVwdo2gzVR6UDzvm53ngjgw@mail.gmail.com>
Subject: Re: [PATCH] mm: honor FOLL_GET flag in follow_hugetlb_page v2
To: Jerome Glisse <j.glisse@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 8:51 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
> On Tue, May 7, 2013 at 8:47 PM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com> wrote:
>> On Tue, May 7, 2013 at 6:58 PM,  <j.glisse@gmail.com> wrote:
>>> From: Jerome Glisse <jglisse@redhat.com>
>>>
>>> Do not increase page count if FOLL_GET is not set. None of the
>>> current user can trigger the issue because none of the current
>>> user call __get_user_pages with both the pages array ptr non
>>> NULL and the FOLL_GET flags non set in other word all caller
>>> of __get_user_pages that don't set the FOLL_GET flags also call
>>> with pages == NULL.
>>
>> Because, __get_user_pages() doesn't allow pages==NULL and FOLL_GET is on.
>
> Yes but this allow pages != NULL and FOLL_GET not set and as i said
> there is no such user of that yet and this is exactly what i was
> trying to use.

Why? The following bug_on inhibit both case.

>>     VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
