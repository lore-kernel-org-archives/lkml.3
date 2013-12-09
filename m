Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564Ab3LIVoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:44:15 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45021 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3LIVoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:44:14 -0500
MIME-Version: 1.0
In-Reply-To: <52A6389E.90404@zytor.com>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>
	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
	<52A6389E.90404@zytor.com>
Date: Mon, 9 Dec 2013 13:44:13 -0800
Message-ID: <CAMe9rOpuFzqA7tOGZ3Eh8Vb76+Y5T2xirAfB08NHbSS5R-OjuQ@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 1:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/09/2013 01:03 PM, H.J. Lu wrote:
>>
>> No, please don't do that.  Normally, PIE has zero load address and kernel
>> can load it anywhere.  There are multiple reasons why PIE has non-zero
>> load address.  Saying you need to load a program above 4GB under x86-64,
>> you can't do that with normal dynamic executable.  PIE with non-zero load
>> address is the only way to do that on x86-64.
>>
>
> Why does it have to be PIE?
>

x86-64 small model is limited to 4GB in size.  You can't build
a dynamic executable in small model larger than 4GB.

There are medium and large models.  But they are slower than
small models as well as small models in PIE.  Also there are
no glibc run-times for medium and large models.


-- 
H.J.
