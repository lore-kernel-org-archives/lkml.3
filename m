Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaBXTYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:24:32 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45931 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaBXTYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:24:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140224115907.07092911@lwn.net>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
	<1393206162-18151-4-git-send-email-n1ght.4nd.d4y@gmail.com>
	<20140224115907.07092911@lwn.net>
Date: Mon, 24 Feb 2014 11:24:28 -0800
Message-ID: <CAJ3m7BphKMafsFPwQP60_OUYeo0So24GwO+J9hUvuOit2mswZQ@mail.gmail.com>
Subject: Re: [RFC PATCH for-next 3/4] epoll: struct epoll support
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/14, Jonathan Corbet <corbet@lwn.net> wrote:
> So I was just looking things over quickly, and something jumped out at
> me.  In ep_control():
>
>> +	} else if (!(*io) && epi) {
>> +		/* delete this eventpoll entry */
>> +		if (is_file_epoll(target)) {
>> +			tep = target->private_data;
>> +			mutex_lock_nested(&tep->mtx, 1);
>> +		}
>> +		if (is_file_epoll(target))
>> +			mutex_lock_nested(&tep->mtx, 1);
>
> How could that possibly work?  I can't imagine tep->mtx is going to
> react well to being locked a second time...

Wow...I have no idea how I missed that, must've been moving stuff
around and accidentally duplicated that somehow. Thanks for setting
me straight, this is why I like to start with an RFC :)

Appreciate the input,
Nate
