Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBSAbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:31:55 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:60526 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaBSAby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:31:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140218170730.GA32227@kroah.com>
References: <1392722606-965-1-git-send-email-sj38.park@gmail.com>
 <1392722606-965-2-git-send-email-sj38.park@gmail.com> <20140218170730.GA32227@kroah.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Wed, 19 Feb 2014 09:31:23 +0900
Message-ID: <CAEjAshp__=_+zN-PoLE=LxOAvtmZ=czOMGXk6XO+03vPnEJ92Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: android: binder: use stack for locally used variable
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 19, 2014 at 2:07 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Feb 18, 2014 at 08:23:26PM +0900, SeongJae Park wrote:
>> The variable `binder_debugfs_dir_entry_root` is declared as static
>> global variable although it is accessed from init function only. Declare
>> it as init function's local variable because it would be better to read
>> and memory efficiency.
>
> Are you sure?  You now just lost that pointer and it can never be freed.

Oops, you are right.

>
> Not that it ever was, but before it was obvious as to what would need to
> be done if the module could ever be made to be unloaded...
>
> As it is, this code is fine, I can't take this patch.

I agree. Thank you.

>
> greg k-h
