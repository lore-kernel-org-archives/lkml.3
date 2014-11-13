Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbaKMXf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:35:58 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34219 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934235AbaKMXf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:35:56 -0500
MIME-Version: 1.0
In-Reply-To: <1415918185.19075.1.camel@sipsolutions.net>
References: <1415913389-17734-1-git-send-email-johannes@sipsolutions.net>
	<CAGXu5jL8CBPXyiZM+AQpNUOvF=rQxay7ozmEaLuRL8WSiRQ2tA@mail.gmail.com>
	<1415918185.19075.1.camel@sipsolutions.net>
Date: Thu, 13 Nov 2014 15:35:56 -0800
Message-ID: <CAGXu5jLATjeNN_DnTgU7=42hezXx3O+tH2_kgKAou9dweVnjvQ@mail.gmail.com>
Subject: Re: [PATCH] devcoredump: provide a one-way disable function
From: Kees Cook <keescook@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartmann <gregkh@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 2:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2014-11-13 at 13:56 -0800, Kees Cook wrote:
>
>> > +       /*
>> > +        * This essentially makes the attribute write-once, since you can't
>> > +        * go back to not having it disabled. This is intentional, it serves
>> > +        * as a system lockdown feature.
>> > +        */
>> > +       if (tmp != 1)
>> > +               return -EINVAL;
>>
>> Just a nit, but writing "0" is valid if devcd_disabled = false?
>
> I thought about that too, but what would the point be? The only
> operation you ever can/want to do is writing "1" to it to disable the
> framework.

Yup, seems like not a useful thing to do, but figured I'd point it out
just in case. I think the patch is fine as-is.

-Kees

-- 
Kees Cook
Chrome OS Security
