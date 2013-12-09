Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab3LIV5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:57:25 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35564 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761687Ab3LIVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:52:25 -0500
MIME-Version: 1.0
In-Reply-To: <52A63AD4.2030101@zytor.com>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>
	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
	<alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>
	<CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>
	<52A63AD4.2030101@zytor.com>
Date: Mon, 9 Dec 2013 13:52:25 -0800
Message-ID: <CAMe9rOqEO271PUUkPAQu5hnZFyTX2viUXg8R0hpwDky0B-seyg@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 1:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> PT_LOAD being non-zero causing randomization to be turned off seems like
>>> quite unexpected behavior to me, with a great potential to cause a lot of
>>> confusion.
>>
>> There should be no difference between dynamic executable and PIE
>> with non-zero vaddr when choosing where to load them.
>>
>
> Why is that?  It would seem to be a big difference between a relocatable
> binary (PIE) and one with a load address fixed at link time.
>

PIE with non-zero vaddr should be loaded at non-zero
vaddr.  Otherwise, PIE may not work as expected.


-- 
H.J.
