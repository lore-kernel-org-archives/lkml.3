Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3KBARD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 20:17:03 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:62114 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3KBARB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 20:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DDA4D@USINDEM103.corp.hds.com>
References: <87ppqk6qvx.fsf@redhat.com>
	<CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
	<CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com>
	<A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com>
	<52740A3A.70202@nod.at>
	<A5ED84D3BB3A384992CBB9C77DEDA4D47F9DDA4D@USINDEM103.corp.hds.com>
Date: Fri, 1 Nov 2013 17:17:00 -0700
Message-ID: <CA+8MBbKMRw28Ubr5F8U=5SKuaeutR+KEVDgJC70Xebj4O5BzpA@mail.gmail.com>
Subject: Re: [PATCH] Make efi-pstore return a unique id
From: Tony Luck <tony.luck@gmail.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Richard Weinberger <richard@nod.at>, Madper Xie <cxie@redhat.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        =?UTF-8?B?6LCi5oiQ6aqP?= <bbboson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 1:57 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
>> What about feeding the bytes of all three integers into a non-cryptographic hash function?
>> Using this way you get a cheap unique id.
>
> It is reasonable to me.

How does efivars backend handle "unlink(2)" in the pstore file system.
pstore will call the backend->erase function passing the "id".  The
backend should then erase the right record from persistent storage.

With the  ((timestamp * 100 + part) * 100 + count function - you can
easily reverse it to find timestamp, part and count - would that make life
easier for the backend to find the record to be erased?  If you use a
hash function you will need to check each record and compute the
hash to see if it matches (probably not a big deal because the backend
will generally only hold a handful of records).

-Tony
