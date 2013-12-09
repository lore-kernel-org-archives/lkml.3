Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3LIJJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:09:05 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52306 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab3LIJI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:08:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131208152737.GB26218@kroah.com>
References: <1385061348-13153-1-git-send-email-dh.herrmann@gmail.com>
	<CANq1E4TcjmcPbj2GvgUcXA7_+AaevbMTC6+2CsbrugJjjC755A@mail.gmail.com>
	<20131208152737.GB26218@kroah.com>
Date: Mon, 9 Dec 2013 10:08:57 +0100
Message-ID: <CANq1E4SzPzbsWEBUqucyOZoeoMqQy3TfdJVn9idF9GQXV=dHuQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix device_create() error path
From: David Herrmann <dh.herrmann@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

On Sun, Dec 8, 2013 at 4:27 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Dec 08, 2013 at 03:42:33PM +0100, David Herrmann wrote:
>> Hi Greg
>>
>> Ping?
>
> It's in my "todo" queue, don't worry, it's not lost.
>
>> On Thu, Nov 21, 2013 at 8:15 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> > We call put_device() in the error path, which is fine for dev==NULL.
>> > However, in case kobject_set_name_vargs() fails, we have dev!=NULL but
>> > device_initialized() wasn't called, yet.
>
> If kobject_set_name_vargs() fails, we have bigger problems than this :)
>
> And I think it's safe for a put_device() on a device that wasn't
> initialized(), we just get a warning message if that happens.

I think it results in a call to kref_sub(), which will call
atomic_sub_and_test() which will fail as the new value is -1. So the
memory isn't freed.

I was just going through my pending patches to make sure they're not
forgotten. Nothing important, but I saw you already applied it.

Thanks
David

> Not to say that your patch is wrong, I'll look at it soon, but things
> should still recover ok from what I can tell.
>
> Oh, and there's the much-complained about memory leak in
> kobject_set_name_vargs() if something goes wrong there as well, I have a
> patch sitting in my queue to hopefully fix that up.
>
> thanks,
>
> greg k-h
