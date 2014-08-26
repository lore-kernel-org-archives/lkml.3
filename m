Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaHZQCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:02:41 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:56166 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaHZQCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:02:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140826155418.GA3034@kroah.com>
References: <1409067741-3378-1-git-send-email-andreas.noever@gmail.com> <20140826155418.GA3034@kroah.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Tue, 26 Aug 2014 18:02:19 +0200
Message-ID: <CAMxnaaX5e_NwT9S45WyzKLnbwtkcZk1fU4bb5P2FkggqVRvhRg@mail.gmail.com>
Subject: Re: [PATCH] thunderbolt: Clear hops before overwriting
To: Greg KH <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 5:54 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Aug 26, 2014 at 05:42:21PM +0200, Andreas Noever wrote:
>> Zero hops in tb_path_activate before writing a new path.
>>
>> This fixes the following scenario:
>>  - Boot with a coldplugged device
>>  - Unplug device
>>  - Plug device back in
>>  - PCI hotplug fails
>>
>> The hotplug operation fails because our new path matches the (now
>> defunct) path which was setup by the firmware for the coldplugged
>> device. By writing zeros before writing our path configuration we can
>> force thunderbolt to retrain the path.
>>
>> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
>> ---
>>  drivers/thunderbolt/path.c | 21 ++++++++++++++++++++-
>>  1 file changed, 20 insertions(+), 1 deletion(-)
>
> Should this get in for 3.17-final or can it wait for 3.18?  I'm thinking
> 3.17, but want to make sure.

I would prefer 3.17.

> thanks,
>
> greg k-h
