Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab3LLUma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:42:30 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:38251 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3LLUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:42:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAL3q7H54avUCPLe-u4szswvumLvnp5iJkWRegzQ1i86fdWdMtA@mail.gmail.com>
References: <CAL3q7H54avUCPLe-u4szswvumLvnp5iJkWRegzQ1i86fdWdMtA@mail.gmail.com>
Date: Thu, 12 Dec 2013 12:42:28 -0800
Message-ID: <CAK7N6vo9gwrwmrnCSN2woX5DSv3b1X85ZNmUya-dcy061yWtEA@mail.gmail.com>
Subject: Re: list_empty atomic?
From: anish singh <anish198519851985@gmail.com>
To: fdmanana@gmail.com
Cc: kernelnewbies <kernelnewbies@kernelnewbies.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 12:21 PM, Filipe David Manana
<fdmanana@gmail.com> wrote:
> Hello,
>
> I have a list that is manipulated by several threads. Insert, remove
> and iteration are protected by a lock. Is the locking necessary too
> just for checking if the list is empty, i.e., is list_empty()
> atomic/safe to call without the lock held or not?
Which lock are you taking here?If mutex is used then
you still need to take a lock even when you are checking
the list.Incase of spinlock it depends on the code i.e.
if you are writing interrupt handler and if the interrupt
handler can run on all the cores simultaneously then
you still need to protect it with the spinlock AFICT.

best advice is to just take the damn lock.
>
> thanks
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
