Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab3KYXnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:43:32 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:58741 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3KYXnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:43:31 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrVsZfHqKT-+SHBq7kYx-_3Gvr=mUYUw81uvNuiMxgLWNA@mail.gmail.com>
References: <CALCETrVsZfHqKT-+SHBq7kYx-_3Gvr=mUYUw81uvNuiMxgLWNA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 25 Nov 2013 15:43:08 -0800
Message-ID: <CALCETrUMS_Rb4Uuw1XEwULzkYYJnaFeLYOYD-7Ao_MjEBABxTw@mail.gmail.com>
Subject: Re: Setting stack NUMA policy?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 3:35 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> I'm trying to arrange for a process to have a different memory policy
> on its stack as compared to everything else (e.g. mapped libraries).
> Before I start looking for kludges, is there any clean way to do this?
>
> So far, the best I can come up with is to either parse /proc/self/maps
> on startup or to deduce the stack range from the stack pointer and
> then call mbind.  Then, for added fun, I'll need to hook mmap so that
> I can mbind MAP_STACK vmas that are created for threads.
>
> This is awful.  Is there something better?
>
> (What I really want is a separate policy for MAP_SHARED vs MAP_PRIVATE.)

After a bit more thought, I think that what I *really* want is for the
stack for a thread that has affinity for a single NUMA node to
automatically end up on that node.  This seems like a straightforward
win if it's implementable.

--Andy
