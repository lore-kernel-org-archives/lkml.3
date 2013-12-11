Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab3LKNle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:41:34 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37899 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LKNlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:41:32 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1312111435470.1413@pobox.suse.cz>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>
	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
	<alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>
	<CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>
	<52A63AD4.2030101@zytor.com>
	<CAMe9rOqEO271PUUkPAQu5hnZFyTX2viUXg8R0hpwDky0B-seyg@mail.gmail.com>
	<52A63BF3.1000608@zytor.com>
	<CAMe9rOqF5f2Wktsqf_43hwa_c20+_S+W8N5VDZ6TVqPXDh7puw@mail.gmail.com>
	<52A63DCF.2060504@zytor.com>
	<CAMe9rOqAV5_+H97XSnrOHxcruouC=hCjDuEkiiyM8UM0BH5CWw@mail.gmail.com>
	<alpine.LNX.2.00.1312111435470.1413@pobox.suse.cz>
Date: Wed, 11 Dec 2013 05:41:32 -0800
Message-ID: <CAMe9rOoS6aZFCP=NNCcUuOanFcj0Y2Uq4jyC+KGC2qCR8M=s=A@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 5:36 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 9 Dec 2013, H.J. Lu wrote:
>
>> >> so that he could load his program compiled as PIE above 4GB.
>> >> If kernel is changed not to honor it, his program won't work any more.
>> >> In normal case, PIE has zero vaddr and this doesn't apply.
>> >>
>> >
>> > That doesn't seem to be PIE at all, and if it is PIE, then it should be
>> > relocatable (I agree btw with randomizing upward from the selected address.)
>>
>> Kernel can consider PIE with non-zero vaddr isn't real PIE.
>
> Why?
>
> I still think PIE with non-zero vaddr should be randomized by putting
> random offset to the vaddr. Don't you think so? Why?
>

When -Ttext-segment=XXX is used, the program is expected to
load at XXX, regardless -pie is used or not.  I will change the
linker to set type to ET_EXEC in this case so that it will be
independent of kernel.


-- 
H.J.
